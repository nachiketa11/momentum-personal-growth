# Supabase setup

## Create the project

1. Create a Supabase project and copy its **Project URL** and **anon/publishable key** from the API settings.
2. Copy `.env.example` to `.env.local` and set `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY`.
3. In the Supabase SQL Editor, run `supabase/migrations/202611010001_initial_schema.sql` once. Confirm all tables have Row Level Security enabled.
4. In Authentication → URL Configuration, set the site URL to the local app during development and add the production Vercel URL after deployment. Email/password authentication is used; configure email confirmation and SMTP to suit the project.

The app uses the public anon key with authenticated user sessions. The service-role key is not needed by this application and must never be placed in a `NEXT_PUBLIC_*` variable, frontend code, or Git.

## Tables and ownership

- `profiles`: one row per Auth user, created by a database trigger.
- `habits` and `habit_logs`: habit definitions and one completion record per habit per date.
- `goals`: user-owned goals with active/completed/paused state.
- `journal_entries`: private reflection text and optional 1–5 mood.
- `future_self_letters`: owner-visible title/schedule metadata.
- `future_self_letter_contents`: body stored separately; SELECT is allowed only for the owner after `open_at <= now()`.

Every user-owned table has RLS enabled and policies tied to `auth.uid()`. The habit-log policy also checks that its referenced habit belongs to the signed-in user. Future-letter dates cannot be edited after creation, and the contents table does not grant UPDATE or DELETE. Deleting the parent letter cascades its contents. The browser never receives a service-role credential.

## Local development

```powershell
Copy-Item .env.example .env.local
npm install
npm run dev
```

Email confirmations may need to be disabled in a development-only Supabase project or correctly configured through Supabase Auth. Do not use real personal journal entries for screenshots or test fixtures.
