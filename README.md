# Momentum

Momentum is a personal growth workspace for habits, goals, journaling, and weekly reflection. It is being built as an individual B.Tech CSE COA project at SRMIST for academic year 2026–27.

## Development

Requirements: Node.js 20.9+ and npm (Node 24 is selected in `.nvmrc`).

```bash
npm install
cp .env.example .env.local
npm run dev
```

The app requires a Supabase project URL and anon key to sign in and load the private workspace. See the database setup instructions before starting it.

## Checks

```bash
npm test
npm run lint
npm run typecheck
npm run build
```

## Database setup

Apply the migration in `supabase/migrations/202611010001_initial_schema.sql` and follow [Supabase setup](docs/DATABASE.md). The application uses the public anon key with authenticated sessions and database RLS. Never configure a service-role key in the browser or commit any `.env` file.

## Project documentation

- [Architecture](docs/ARCHITECTURE.md)
- [COA report draft](docs/COA-REPORT.md)
- [Supabase setup and schema](docs/DATABASE.md)
- [Vercel deployment](docs/DEPLOYMENT.md)

All dashboard analytics are derived from the signed-in user's database records. Empty states are shown until the user creates records; the app does not seed invented activity.
