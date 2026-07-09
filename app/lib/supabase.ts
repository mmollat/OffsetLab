import { createClient } from "@supabase/supabase-js";
import type { SupabaseClient } from "@supabase/supabase-js";

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

export const isSupabaseConfigured = Boolean(supabaseUrl && supabaseAnonKey);

function createMissingEnvQuery() {
  const error = new Error("Supabase env vars are not configured.");
  const query = {
    select: () => query,
    eq: () => query,
    not: () => query,
    order: () => query,
    range: () => query,
    insert: () => Promise.resolve({ data: null, error }),
    then: (resolve: (value: { data: null; error: Error }) => unknown) =>
      Promise.resolve({ data: null, error }).then(resolve),
  };

  return query;
}

const missingEnvSupabase = {
  from: () => createMissingEnvQuery(),
  storage: {
    from: () => ({
      upload: () =>
        Promise.resolve({
          data: null,
          error: new Error("Supabase env vars are not configured."),
        }),
      getPublicUrl: () => ({ data: { publicUrl: "" } }),
    }),
  },
} as unknown as SupabaseClient;

export const supabase =
  supabaseUrl && supabaseAnonKey
    ? createClient(supabaseUrl, supabaseAnonKey)
    : missingEnvSupabase;
