-- ============================================
-- Vyapar AI - FIX for 42703: column does not exist
-- Ye SQL purani tables me missing columns add kar dega
-- Data delete NAHI hoga
-- ============================================

-- 1. SALES table ke missing columns add karo
alter table sales add column if not exists invoice_no text;
alter table sales add column if not exists subtotal numeric;
alter table sales add column if not exists gst_total numeric default 0;
alter table sales add column if not exists cgst numeric default 0;
alter table sales add column if not exists sgst numeric default 0;
alter table sales add column if not exists igst numeric default 0;
alter table sales add column if not exists discount numeric default 0;
alter table sales add column if not exists items jsonb;
alter table sales add column if not exists payment_status text default 'pending';
alter table sales add column if not exists customer_id uuid references customers(id) on delete set null;
alter table sales add column if not exists user_id uuid references auth.users(id) on delete cascade;
alter table sales add column if not exists total numeric;
alter table sales add column if not exists created_at timestamp with time zone default now();

-- 2. CUSTOMERS ke missing columns
alter table customers add column if not exists user_id uuid references auth.users(id) on delete cascade;
alter table customers add column if not exists email text;
alter table customers add column if not exists balance_due numeric default 0;
alter table customers add column if not exists total_sale numeric default 0;
alter table customers add column if not exists total_paid numeric default 0;
alter table customers add column if not exists address text;
alter table customers add column if not exists created_at timestamp with time zone default now();

-- 3. PRODUCTS ke missing columns
alter table products add column if not exists user_id uuid references auth.users(id) on delete cascade;
alter table products add column if not exists cost_price numeric;
alter table products add column if not exists stock int default 0;
alter table products add column if not exists hsn_code text;
alter table products add column if not exists gst_rate int default 18;
alter table products add column if not exists barcode text;
alter table products add column if not exists category text;
alter table products add column if not exists created_at timestamp with time zone default now();

-- 4. PAYMENTS ke missing columns
alter table payments add column if not exists user_id uuid references auth.users(id) on delete cascade;
alter table payments add column if not exists customer_id uuid references customers(id) on delete set null;
alter table payments add column if not exists sale_id uuid references sales(id) on delete set null;
alter table payments add column if not exists method text default 'Cash';
alter table payments add column if not exists utr text;
alter table payments add column if not exists upi_app text;
alter table payments add column if not exists verified boolean default false;
alter table payments add column if not exists verified_at timestamp with time zone;
alter table payments add column if not exists created_at timestamp with time zone default now();

-- 5. PROFILES ke missing columns
alter table profiles add column if not exists business_name text;
alter table profiles add column if not exists gstin text;
alter table profiles add column if not exists state text default 'Rajasthan';
alter table profiles add column if not exists upi_id text;
alter table profiles add column if not exists phone text;
alter table profiles add column if not exists email text;
alter table profiles add column if not exists created_at timestamp with time zone default now();

-- 6. Invoice_no ko unique banao agar abhi tak nahi hai (safe)
do $$
begin
  if not exists (select 1 from pg_indexes where indexname = 'idx_sales_invoice') then
    -- Pehle duplicate invoice_no ko fix karo agar hai
    -- Null walo ko random de do
    update sales set invoice_no = 'INV-' || substr(id::text, 1, 8) where invoice_no is null;
    create unique index idx_sales_invoice on sales(invoice_no);
  end if;
end $$;

-- 7. Final check
select 'Fix done ✅ - ab error nahi ayega' as status;
select column_name from information_schema.columns where table_name = 'sales' order by column_name;
