-- ============================================================
-- PicLog — Supabase SQL Schema
-- ============================================================
-- Run this in the Supabase SQL Editor (Dashboard > SQL Editor)
-- ============================================================

-- Enable UUID extension (already enabled by default in Supabase)
-- create extension if not exists "uuid-ossp";

-- ─── Table: posts ────────────────────────────────────────────
create table if not exists public.posts (
  id          uuid primary key default gen_random_uuid(),
  title       text not null check (char_length(title) between 1 and 100),
  body        text not null check (char_length(body) >= 1),
  image_path  text,          -- Storage object path, e.g. "posts/abc123.jpg" (nullable)
  image_url   text,          -- Public URL (denormalized for convenience)
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

-- Automatically update updated_at on row change
create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists posts_set_updated_at on public.posts;
create trigger posts_set_updated_at
  before update on public.posts
  for each row execute function public.set_updated_at();

-- Index for latest-first feed
create index if not exists posts_created_at_idx on public.posts (created_at desc);

-- ─── Row Level Security ───────────────────────────────────────
-- Public read (no auth required — anonymous board)
alter table public.posts enable row level security;

-- Allow anyone to read all posts
create policy "Public read" on public.posts
  for select using (true);

-- Allow anyone to insert posts (no login required)
create policy "Public insert" on public.posts
  for insert with check (true);

-- (Optional) Allow post deletion only by service role or owner
-- Uncomment when you add auth:
-- create policy "Owner delete" on public.posts
--   for delete using (auth.uid() = author_id);


-- ─── Storage bucket: post-images ─────────────────────────────
-- Run this in the Supabase Dashboard > Storage, or via SQL:

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'post-images',
  'post-images',
  true,                                     -- public bucket (no signed URLs needed)
  10485760,                                 -- 10 MB max
  array['image/jpeg','image/png','image/webp','image/gif']
)
on conflict (id) do nothing;

-- Storage policy: anyone can upload
create policy "Public upload" on storage.objects
  for insert to anon
  with check (bucket_id = 'post-images');

-- Storage policy: anyone can read
create policy "Public read" on storage.objects
  for select to anon
  using (bucket_id = 'post-images');


-- ─── Helper view (optional) ───────────────────────────────────
-- Returns posts newest-first with a truncated excerpt
create or replace view public.posts_feed as
  select
    id,
    title,
    left(body, 150) as excerpt,
    image_url,
    created_at
  from public.posts
  order by created_at desc;


-- ============================================================
-- Usage examples (JavaScript / Supabase client)
-- ============================================================
-- 
-- // Fetch feed
-- const { data } = await supabase
--   .from('posts_feed')
--   .select('*')
--   .limit(20);
--
-- // Fetch single post
-- const { data } = await supabase
--   .from('posts')
--   .select('*')
--   .eq('id', postId)
--   .single();
--
-- // Insert text-only post
-- const { data, error } = await supabase
--   .from('posts')
--   .insert({ title, body })
--   .select()
--   .single();
--
-- // Upload image then insert post
-- const { data: upload } = await supabase.storage
--   .from('post-images')
--   .upload(`posts/${Date.now()}_${file.name}`, file);
--
-- const imageUrl = supabase.storage
--   .from('post-images')
--   .getPublicUrl(upload.path).data.publicUrl;
--
-- const { data: post } = await supabase
--   .from('posts')
--   .insert({ title, body, image_path: upload.path, image_url: imageUrl })
--   .select()
--   .single();
-- ============================================================
