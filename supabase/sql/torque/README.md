# Torque SQL Packs

Run packs in numeric order in Supabase SQL Editor.

1. `000_add_torque_source_metadata.sql`
2. `001_seed_pack_format.sql`
3. `002a_wheels_toyota_gr86_canary.sql`
4. `002_wheels_lug_torque_jdm_sport_initial.sql`
5. `003_brakes_bleeder_jdm_sport_initial.sql`
6. `004_suspension_zn8_zd8_initial.sql`
7. `005_sync_torque_vehicle_hierarchy_from_fitment.sql`
8. `006_wheels_missing_generations_backfill.sql`
9. `007_infiniti_v36_g37_wheels.sql`
10. `008_brakes_bleeder_fitment_backfill.sql`
11. Researched data packs, continuing with model-specific Brakes/Suspension/Engine/Drivetrain/Fluids specs.

Data packs are plain SQL only. They should be additive: create missing
make/model/generation rows when needed, insert missing specs, and keep existing
Torque Hub specs intact. Values from official service manuals or owner manuals
should use `verified`. Values from forum posts, wheel-brand charts, or secondary
references should use `community` or `needs_review`.
