# Vercel deployment

The repository is configured as a standard Next.js application, so no custom Vercel build command is required.

1. In Vercel, import `nachiketa11/momentum-personal-growth` from GitHub and select the `main` production branch.
2. In Project Settings → Environment Variables, set `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY` for Production, Preview, and Development environments as appropriate. Use the public anon/publishable key only.
3. Deploy after GitHub Actions reports passing tests, lint, typecheck, and build.
4. Add the resulting deployment domain to Supabase Authentication → URL Configuration as the Site URL and an allowed redirect URL. Test email confirmation and password sign-in against that domain.
5. Verify the homepage, account creation/sign-in, RLS isolation, habit check-ins, goal changes, journal persistence, future-letter lock before/after opening, mobile layout, and COA operations before calling the deployment production-ready.

Do not add `SUPABASE_SERVICE_ROLE_KEY` to Vercel. It is not required by the app.
