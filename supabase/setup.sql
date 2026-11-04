-- Run once in Supabase SQL Editor. Read README before execution.
create extension if not exists pgcrypto;
create table if not exists public.admins (
 user_id uuid primary key references auth.users(id) on delete cascade
);
create table if not exists public.categories (
 id uuid primary key default gen_random_uuid(), name text unique not null, kind text not null check (kind in ('shoes','clothing'))
);
create table if not exists public.products (
 id uuid primary key default gen_random_uuid(),
 name text not null,
 description text not null default '',
 category text not null,
 kind text not null check(kind in ('shoes','clothing')),
 price numeric(10,2) not null check(price>=0),
 old_price numeric(10,2) check(old_price is null or old_price>=0),
 images jsonb not null default '[]'::jsonb,
 color_images jsonb not null default '{}'::jsonb,
 variants jsonb not null default '[]'::jsonb,
 featured boolean not null default false,
 is_new boolean not null default false,
 published boolean not null default false,
 created_at timestamptz not null default now()
);
create index if not exists idx_products_public on public.products(published,created_at desc);
create or replace function public.is_admin() returns boolean language sql stable security definer set search_path = '' as $$
 select exists(select 1 from public.admins a where a.user_id = (select auth.uid()));
$$;
revoke all on function public.is_admin() from public;
grant execute on function public.is_admin() to authenticated,anon;
alter table public.admins enable row level security;
alter table public.categories enable row level security;
alter table public.products enable row level security;
-- Admin membership cannot be edited by browser users. Grant admin manually from SQL editor.
drop policy if exists "admins select own" on public.admins;
create policy "admins select own" on public.admins for select to authenticated using (user_id=(select auth.uid()));
drop policy if exists "public categories" on public.categories;
create policy "public categories" on public.categories for select to anon,authenticated using(true);
drop policy if exists "admin categories" on public.categories;
create policy "admin categories" on public.categories for all to authenticated using((select public.is_admin())) with check((select public.is_admin()));
drop policy if exists "published public products" on public.products;
create policy "published public products" on public.products for select to anon,authenticated using(published=true or (select public.is_admin()));
drop policy if exists "admin create products" on public.products;
create policy "admin create products" on public.products for insert to authenticated with check((select public.is_admin()));
drop policy if exists "admin update products" on public.products;
create policy "admin update products" on public.products for update to authenticated using((select public.is_admin())) with check((select public.is_admin()));
drop policy if exists "admin delete products" on public.products;
create policy "admin delete products" on public.products for delete to authenticated using((select public.is_admin()));
insert into public.categories(name,kind) values
 ('جينز','clothing'),('تيشورتات','clothing'),('هوديز','clothing'),('أطقم','clothing'),('سويتشرتات','clothing'),
 ('سبادريات','shoes'),('صباط كاجوال','shoes'),('صباط كلاسيك','shoes') on conflict(name) do nothing;
insert into storage.buckets (id,name,public,file_size_limit,allowed_mime_types)
values ('product-images','product-images',true,10485760,array['image/jpeg','image/png','image/webp','image/avif'])
on conflict(id) do update set public=true;
drop policy if exists "public read product images" on storage.objects;
create policy "public read product images" on storage.objects for select to anon,authenticated using(bucket_id='product-images');
drop policy if exists "admin upload product images" on storage.objects;
create policy "admin upload product images" on storage.objects for insert to authenticated with check(bucket_id='product-images' and (select public.is_admin()));
drop policy if exists "admin update product images" on storage.objects;
create policy "admin update product images" on storage.objects for update to authenticated using(bucket_id='product-images' and (select public.is_admin())) with check(bucket_id='product-images' and (select public.is_admin()));
drop policy if exists "admin delete product images" on storage.objects;
create policy "admin delete product images" on storage.objects for delete to authenticated using(bucket_id='product-images' and (select public.is_admin()));
-- Create your owner user in Supabase Authentication -> Users, then grant:
-- insert into public.admins(user_id) select id from auth.users where email='YOUR_EMAIL@example.com' on conflict do nothing;
-- Demo examples: NOT automatically inserted. Add products via /admin with actual verified sizes/stock.
