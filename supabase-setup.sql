-- ============================================================
--  Voyages Uribe Labreche — configuration Supabase
--  À coller dans Supabase → SQL Editor → New query → Run
-- ============================================================

-- 1) Tables ---------------------------------------------------
create table if not exists public.spaces (
  id uuid primary key default gen_random_uuid(),
  name text not null default 'Notre espace',
  invite_code text unique not null,
  created_by uuid references auth.users(id) default auth.uid(),
  created_at timestamptz default now()
);

create table if not exists public.space_members (
  space_id uuid references public.spaces(id) on delete cascade,
  user_id  uuid references auth.users(id)   on delete cascade,
  role text default 'member',
  joined_at timestamptz default now(),
  primary key (space_id, user_id)
);

create table if not exists public.trips (
  id text primary key,
  space_id uuid references public.spaces(id) on delete cascade,
  data jsonb not null,
  updated_by uuid,
  updated_at timestamptz default now()
);
create index if not exists trips_space_idx on public.trips(space_id);

-- 2) Fonction d'appartenance (évite la récursion RLS) ---------
create or replace function public.is_member(p_space uuid)
returns boolean language sql security definer stable set search_path=public as $$
  select exists(
    select 1 from public.space_members m
    where m.space_id = p_space and m.user_id = auth.uid()
  );
$$;

-- 3) Sécurité au niveau des lignes (RLS) ----------------------
alter table public.spaces        enable row level security;
alter table public.space_members enable row level security;
alter table public.trips         enable row level security;

drop policy if exists spaces_select  on public.spaces;
drop policy if exists members_select on public.space_members;
drop policy if exists trips_all      on public.trips;

create policy spaces_select  on public.spaces
  for select using (public.is_member(id));

create policy members_select on public.space_members
  for select using (public.is_member(space_id));

-- Membres de l'espace = lecture + écriture des voyages de l'espace
create policy trips_all on public.trips
  for all
  using (public.is_member(space_id))
  with check (public.is_member(space_id));

-- 4) RPC : créer un espace (+ y ajouter le créateur) ----------
create or replace function public.create_space(p_name text)
returns public.spaces language plpgsql security definer set search_path=public as $$
declare s public.spaces; code text;
begin
  code := upper(substr(md5(random()::text), 1, 6));
  insert into public.spaces(name, invite_code, created_by)
    values (coalesce(nullif(p_name,''),'Notre espace'), code, auth.uid())
    returning * into s;
  insert into public.space_members(space_id, user_id, role)
    values (s.id, auth.uid(), 'owner');
  return s;
end $$;

-- 5) RPC : rejoindre un espace via son code -------------------
create or replace function public.join_space(p_code text)
returns public.spaces language plpgsql security definer set search_path=public as $$
declare s public.spaces;
begin
  select * into s from public.spaces where invite_code = upper(p_code);
  if s.id is null then
    raise exception 'code introuvable';
  end if;
  insert into public.space_members(space_id, user_id, role)
    values (s.id, auth.uid(), 'member')
    on conflict do nothing;
  return s;
end $$;

grant execute on function public.create_space(text) to authenticated;
grant execute on function public.join_space(text)  to authenticated;

-- 6) Temps réel (voir les changements de l'autre en direct) ---
alter table public.trips replica identity full;
do $$ begin
  begin
    alter publication supabase_realtime add table public.trips;
  exception when duplicate_object then null;
  end;
end $$;
