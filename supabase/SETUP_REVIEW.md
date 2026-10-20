# Fitment variant read proposal

Pack 017 is a review candidate for the existing table created by pack 002. Apply
only together with the explicit field projection in `getFitmentData.ts`. It keeps
RLS, grants only the fields consumed by the public query, and permits only active
`verified` rows. It does not expose source_note, timestamps, or UUID IDs. Existing
browser table/column grants are cleared on this table; no write or sequence grants
are added. Unknown policies cause a transactional failure requiring review.

**Product decision pending:** confirm active verified-only recommendations are the
intended public dataset. Pack 002 seeds needs_review variants, so this proposal may
return zero rows and retain the current fallback. Community/needs_review rows stay
hidden. This does not certify or filter older fallback recommendations: review
their visibility and user-facing status separately before treating the page as a
verified-only product. Do not mark seeded rows verified to make the test pass.

The current client treats table-name-bearing permission errors like unavailable
tables and falls back. This patch changes that log to an error with the database
code, while retaining the established fallback behavior. An empty RLS-filtered
result is successful SQL, so the fallback still cannot prove variant access.

There is no complete initial schema, config.toml, or migration directory. The
first packs assume fitment_presets and torque_specs already exist. Do not invent
or replay a complete baseline from these packs. Obtain a reviewed schema-only
baseline and migration history before provisioning a new environment. Preserve
pack 009's active factory-baseline policy; this proposal does not change it.

Before application, inspect column definitions, existing ACLs (including inherited
roles), and all policies using schema metadata only. Run isolated tests with
active/inactive verified, community, and needs_review synthetic rows, for both
anon and authenticated. Assert only the active verified row is visible, source
metadata cannot be selected, and insert/update/delete remain denied. Test the exact
app projection and the resolver fallback in a disposable Supabase instance too.

Rollback: revert the client projection/log change and revoke the new column SELECT
grants, drop only fitment_variants_read_verified, and retain RLS. Restore prior ACLs
only from an approved snapshot; do not disable RLS or grant blanket public reads.
