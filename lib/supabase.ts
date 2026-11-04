import { createClient, SupabaseClient } from '@supabase/supabase-js';
let client: SupabaseClient | null = null;
export const isConfigured = () => !!(process.env.NEXT_PUBLIC_SUPABASE_URL && process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY);
export function supabase(): SupabaseClient | null {
  if (!isConfigured()) return null;
  if (!client) client = createClient(process.env.NEXT_PUBLIC_SUPABASE_URL!, process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!, {auth:{persistSession:true,autoRefreshToken:true}});
  return client;
}
