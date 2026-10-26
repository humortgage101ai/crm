-- Hu's CRM — database tables. Paste into the Supabase SQL editor (safe to run again).
-- Every table is locked by row-level security: only an email listed in crm_users can read or write.

create table if not exists crm_users (
  email text primary key
);

create or replace function crm_ok() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from crm_users where lower(email) = lower(auth.jwt()->>'email'));
$$;

create table if not exists crm_settings (
  id int primary key default 1 check (id = 1),
  default_split numeric not null default 90,      -- % of gross commission Hu keeps
  contact_days int not null default 120,          -- renewal within this many days = contact now
  upcoming_days int not null default 180,         -- renewal within this many days = coming up
  file_email text                                 -- Hu's +file Gmail address (forwarded docs land in Drive "Inbox - to file")
);
alter table crm_settings add column if not exists file_email text;
insert into crm_settings (id) values (1) on conflict do nothing;

create table if not exists crm_clients (
  code text primary key,                          -- C0042, same as the Drive folder "Last, First (C0042)"
  last_name text not null,
  first_name text not null default '',
  email text,
  phone text,
  kind text not null default 'Mortgage',          -- Mortgage / Insurance / Both
  drive_url text,
  source text,                                    -- where the client came from (ad, referral…)
  notes text,
  created_at timestamptz not null default now()
);

create table if not exists crm_deals (
  id uuid primary key default gen_random_uuid(),
  client_code text not null references crm_clients(code) on update cascade on delete cascade,
  lender text,
  property text,
  amount numeric,
  rate numeric,
  term_months int,
  funded_date date,
  maturity_date date,                             -- lender's maturity date; renewal = this, else funded + term
  status text not null default 'Active',          -- In progress / Active / Renewed / Paid out / Lost
  renewal_outcome text,
  gross numeric,                                  -- gross commission
  split numeric,                                  -- per-deal override of the default split (%)
  paid boolean not null default false,
  paid_date date,
  received numeric,
  notes text,
  created_at timestamptz not null default now()
);

create table if not exists crm_policies (
  id uuid primary key default gen_random_uuid(),
  client_code text not null references crm_clients(code) on update cascade on delete cascade,
  carrier text,
  product text,                                   -- Life / Critical illness / Disability / Home / Auto / …
  policy_no text,
  premium numeric,
  frequency text default 'Monthly',
  start_date date,
  renewal_date date,
  status text not null default 'Active',
  gross numeric,
  split numeric,
  paid boolean not null default false,
  paid_date date,
  received numeric,
  notes text,
  created_at timestamptz not null default now()
);

create table if not exists crm_notes (
  id uuid primary key default gen_random_uuid(),
  client_code text not null references crm_clients(code) on update cascade on delete cascade,
  at timestamptz not null default now(),
  text text not null
);

create table if not exists crm_adspend (
  id uuid primary key default gen_random_uuid(),
  day date not null,
  platform text not null,
  campaign text,
  amount numeric not null default 0,
  leads int,
  notes text,
  created_at timestamptz not null default now()
);

do $$
declare t text;
begin
  foreach t in array array['crm_settings','crm_clients','crm_deals','crm_policies','crm_notes','crm_adspend'] loop
    execute format('alter table %I enable row level security', t);
    execute format('drop policy if exists owner_all on %I', t);
    execute format('create policy owner_all on %I for all to authenticated using (crm_ok()) with check (crm_ok())', t);
  end loop;
end $$;
alter table crm_users enable row level security;   -- no policies: nobody reads it from the page

-- Then add Hu's login email (run once, with the real address):
-- insert into crm_users (email) values ('you@example.com') on conflict do nothing;
