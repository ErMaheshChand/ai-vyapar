
-- Vyapar AI - FINAL FULL SCHEMA (All modules)
-- Tables: profiles, customers, products, sales, payments

-- Enable UUID
create extension if not exists "uuid-ossp";

-- PROFILES
create table if not exists profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  business_name text,
  gstin text,
  state text default 'Rajasthan',
  upi_id text,
  phone text,
  email text,
  created_at timestamp with time zone default now()
);

-- CUSTOMERS (Khatabook)
create table if not exists customers (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references auth.users(id) on delete cascade,
  name text not null,
  phone text,
  email text,
  address text,
  balance_due numeric default 0,
  total_sale numeric default 0,
  total_paid numeric default 0,
  created_at timestamp with time zone default now()
);
alter table customers add column if not exists user_id uuid references auth.users(id) on delete cascade;
alter table customers add column if not exists phone text;
alter table customers add column if not exists email text;
alter table customers add column if not exists address text;
alter table customers add column if not exists balance_due numeric default 0;
alter table customers add column if not exists total_sale numeric default 0;
alter table customers add column if not exists total_paid numeric default 0;

-- PRODUCTS (Stock)
create table if not exists products (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references auth.users(id) on delete cascade,
  name text not null,
  cost_price numeric,
  selling_price numeric,
  stock int default 0,
  hsn_code text,
  gst_rate int default 18,
  barcode text,
  category text,
  created_at timestamp with time zone default now()
);
alter table products add column if not exists user_id uuid references auth.users(id) on delete cascade;
alter table products add column if not exists cost_price numeric;
alter table products add column if not exists selling_price numeric;
alter table products add column if not exists stock int default 0;
alter table products add column if not exists hsn_code text;
alter table products add column if not exists gst_rate int default 18;

-- SALES (Bills)
create table if not exists sales (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references auth.users(id) on delete cascade,
  customer_id uuid references customers(id) on delete set null,
  invoice_no text,
  subtotal numeric,
  gst_total numeric default 0,
  cgst numeric default 0,
  sgst numeric default 0,
  igst numeric default 0,
  discount numeric default 0,
  total numeric,
  items jsonb,
  payment_status text default 'pending',
  created_at timestamp with time zone default now()
);
alter table sales add column if not exists invoice_no text;
alter table sales add column if not exists subtotal numeric;
alter table sales add column if not exists gst_total numeric default 0;
alter table sales add column if not exists items jsonb;
alter table sales add column if not exists payment_status text default 'pending';
alter table sales add column if not exists customer_id uuid references customers(id) on delete set null;
alter table sales add column if not exists total numeric;

-- PAYMENTS (UPI Verification)
create table if not exists payments (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references auth.users(id) on delete cascade,
  customer_id uuid references customers(id) on delete set null,
  sale_id uuid references sales(id) on delete set null,
  amount numeric not null,
  method text default 'Cash',
  utr text,
  upi_app text,
  verified boolean default false,
  verified_at timestamp with time zone,
  created_at timestamp with time zone default now()
);

-- RLS OFF for now (single user app) - enable later if needed
alter table customers disable row level security;
alter table products disable row level security;
alter table sales disable row level security;
alter table payments disable row level security;
alter table profiles disable row level security;

-- Indexes
create unique index if not exists idx_sales_invoice on sales(invoice_no) where invoice_no is not null;
create index if not exists idx_customers_user on customers(user_id);
create index if not exists idx_products_user on products(user_id);

-- Reload cache
notify pgrst, 'reload schema';
select 'FULL SCHEMA READY ✅' as status;
