# Momentum architecture

## Application

Momentum is a responsive Next.js App Router application. Users authenticate with Supabase Auth and use their session plus the public anon key to read and write records through Postgres Row Level Security. Empty states are shown until a user creates records; the app does not seed sample activity.

## Production shape

- **Web:** Next.js 16 and TypeScript, intended for Vercel.
- **Identity and data:** Supabase Auth and Postgres. Browser code uses only the project URL and anon/publishable key. RLS is the authorization boundary; no service-role key is present in application code.
- **Core data:** private habits and check-ins, goals, journal entries, and future-self letters.
- **Time Machine:** six weeks of check-ins plus saved reflections and goal counts, all derived from the authenticated user's records without interpolating missing history.
- **Future Self:** letter metadata and letter body are separate tables. RLS allows reading the body only after the stored opening time. The schedule cannot be edited after creation.
- **COA:** a pure seven-bit progress module implements AND, OR, XOR, masked NOT, and left shift with range checks and unit tests.

## Milestones

1. Foundation: scaffold, design system, responsive application shell, and setup documentation.
2. Backend/authentication: Supabase client, migrations, RLS, email/password sign-in, and session handling.
3. Core modules: persisted habits/check-ins, goals, journal, and future-self letters.
4. Analytics/COA engine: derived progress views, bitwise engine, tests, and visible operation walkthrough.
5. QA: unit tests, syntax checks, configured lint/type/build CI, and documented manual verification requirements.
6. GitHub/deployment: inspect changes for secrets, push to the existing public repository, configure Vercel, deploy, and verify live URLs.

## Data and privacy

Every user-owned row carries an `auth.uid()` owner key and has RLS policies for allowed operations. The habit-log policy also verifies ownership of the referenced habit. Future-letter body access is enforced in RLS rather than only in the UI. `.env*` files are ignored except `.env.example`; only public configuration belongs in that example.
