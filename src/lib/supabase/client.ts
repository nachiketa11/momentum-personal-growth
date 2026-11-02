import { createClient, type SupabaseClient } from "@supabase/supabase-js";
import type { Database } from "../database.types";

let supabase: SupabaseClient<Database> | null = null;

export function getSupabase() {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const key = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
  if (!url || !key) return null;
  if (!supabase) supabase = createClient<Database>(url, key, { auth: { autoRefreshToken: true, persistSession: true, detectSessionInUrl: true } });
  return supabase;
}
