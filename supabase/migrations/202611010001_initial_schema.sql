create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null default '' check (char_length(display_name) <= 80),
  created_at timestamptz not null default now()
);

create function public.handle_new_user() returns trigger
language plpgsql security definer set search_path = '' as $$
begin
  insert into public.profiles (id, display_name)
  values (new.id, coalesce(new.raw_user_meta_data ->> 'display_name', ''))
  on conflict (id) do nothing;
  return new;
end;
$$;

create trigger on_auth_user_created after insert on auth.users
for each row execute procedure public.handle_new_user();

create table public.habits (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  title text not null check (char_length(title) between 1 and 100),
  category text not null default 'Personal' check (char_length(category) <= 40),
  target_per_week smallint not null default 7 check (target_per_week between 1 and 7),
  archived boolean not null default false,
  created_at timestamptz not null default now()
);

create table public.habit_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  habit_id uuid not null references public.habits(id) on delete cascade,
  log_date date not null default current_date,
  completed boolean not null default true,
  created_at timestamptz not null default now(),
  unique (habit_id, log_date),
  check (log_date <= current_date)
);

create table public.goals (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  title text not null check (char_length(title) between 1 and 120),
  description text not null default '' check (char_length(description) <= 2000),
  target_date date,
  status text not null default 'active' check (status in ('active', 'completed', 'paused')),
  created_at timestamptz not null default now()
);

create table public.journal_entries (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  title text not null default '' check (char_length(title) <= 120),
  body text not null check (char_length(body) between 1 and 12000),
  mood smallint check (mood between 1 and 5),
  created_at timestamptz not null default now()
);

create table public.future_self_letters (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  title text not null check (char_length(title) between 1 and 120),
  open_at timestamptz not null,
  created_at timestamptz not null default now(),
  check (open_at > created_at)
);

-- Letter contents are stored separately so RLS can prevent reading them before open_at.
create table public.future_self_letter_contents (
  letter_id uuid primary key references public.future_self_letters(id) on delete cascade,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  body text not null check (char_length(body) between 1 and 12000),
  created_at timestamptz not null default now()
);

revoke all on public.profiles, public.habits, public.habit_logs, public.goals,
  public.journal_entries, public.future_self_letters, public.future_self_letter_contents
from anon, public;

create index habit_logs_user_date_idx on public.habit_logs (user_id, log_date desc);
create index goals_user_status_idx on public.goals (user_id, status);
create index journal_user_created_idx on public.journal_entries (user_id, created_at desc);
create index letters_user_open_idx on public.future_self_letters (user_id, open_at);

alter table public.profiles enable row level security;
alter table public.habits enable row level security;
alter table public.habit_logs enable row level security;
alter table public.goals enable row level security;
alter table public.journal_entries enable row level security;
alter table public.future_self_letters enable row level security;
alter table public.future_self_letter_contents enable row level security;

create policy "Profiles are private to their owner" on public.profiles for select to authenticated using (id = (select auth.uid()));
create policy "Users update their own profile" on public.profiles for update to authenticated using (id = (select auth.uid())) with check (id = (select auth.uid()));
create policy "Users manage their habits" on public.habits for all to authenticated using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));
create policy "Users manage their logs" on public.habit_logs for all to authenticated using (user_id = (select auth.uid()) and exists (select 1 from public.habits h where h.id = habit_id and h.user_id = (select auth.uid()))) with check (user_id = (select auth.uid()) and exists (select 1 from public.habits h where h.id = habit_id and h.user_id = (select auth.uid())));
create policy "Users manage their goals" on public.goals for all to authenticated using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));
create policy "Users manage their journal" on public.journal_entries for all to authenticated using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));
create policy "Users read their future letter metadata" on public.future_self_letters for select to authenticated using (user_id = (select auth.uid()));
create policy "Users create future letters" on public.future_self_letters for insert to authenticated with check (user_id = (select auth.uid()) and open_at > now());
create policy "Users delete their future letters" on public.future_self_letters for delete to authenticated using (user_id = (select auth.uid()));
create policy "Users insert their future letter contents" on public.future_self_letter_contents for insert to authenticated with check (user_id = (select auth.uid()) and exists (select 1 from public.future_self_letters l where l.id = letter_id and l.user_id = (select auth.uid())));
create policy "Users read opened future letter contents" on public.future_self_letter_contents for select to authenticated using (user_id = (select auth.uid()) and exists (select 1 from public.future_self_letters l where l.id = letter_id and l.user_id = (select auth.uid()) and l.open_at <= now()));

grant usage on schema public to authenticated;
grant select, update on public.profiles to authenticated;
grant select, insert, update, delete on public.habits, public.habit_logs, public.goals, public.journal_entries to authenticated;
grant select, insert, delete on public.future_self_letters to authenticated;
grant select, insert on public.future_self_letter_contents to authenticated;
revoke all on function public.handle_new_user() from public, anon, authenticated;
