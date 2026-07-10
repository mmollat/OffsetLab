-- Offset Lab Torque Hub
-- Pack 001: seed pack format note.
--
-- Supabase SQL Editor was injecting RLS snippets into PL/pgSQL helper function
-- bodies, so we are intentionally NOT using helper functions for torque packs.
--
-- Going forward, each data pack will be plain SQL only:
-- - no create function
-- - no do $$ blocks
-- - no dollar-quoted function bodies
--
-- You can run this file safely. It makes no database changes.

select 'Offset Lab torque packs will use plain SQL seed statements.' as message;

