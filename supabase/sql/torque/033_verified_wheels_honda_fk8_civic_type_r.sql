-- Offset Lab Torque Hub
-- Pack 033: verified Honda FK8 Civic Type R wheel lug nut torque.
--
-- Plain SQL only. Safe to re-run.
-- Honda's 2020 Civic/Civic Type R owner manual specifies wheel lug nut
-- tightening torque as 94 lb-ft / 127 Nm.
--
-- Two FK8 generation rows currently exist in the live hierarchy. This pack
-- updates the primary wheel row attached to each one so both public routes and
-- lookup paths return the same verified value.

with seed(spec_id) as (
  values
    ('e10b4a0c-c3f2-4bb3-bcdf-4ccdcf46e03f'::uuid),
    ('48379b23-91fb-42a7-b1e3-5814585caf57'::uuid)
),
updated_primary as (
  update public.torque_specs spec
  set
    component = 'Wheels',
    fastener = 'Wheel lug nuts',
    torque_ft_lb = 94,
    torque_nm = 127,
    angle_degrees = null,
    notes = 'Honda Civic Type R owner-manual guidance specifies this wheel lug nut torque. Tighten in the indicated criss-cross pattern, going around two to three times, with clean mounting surfaces and a calibrated torque wrench.',
    warning = 'Use the correct Honda wheel nuts and wheel-seat type. Do not overtighten or apply extra leverage with a pipe or by standing on the wrench.',
    source_status = 'verified',
    source_name = 'Honda 2020 Civic/Civic Type R Owner Manual',
    source_url = 'https://techinfo.honda.com/rjanisis/pubs/OM/AH/ATGG2020OM/enu/ATGG2020OM.PDF',
    source_note = 'Verified from Honda 2020 Civic/Civic Type R owner manual flat-tire guidance: wheel nut torque is 94 lbf-ft / 127 N-m / 13.0 kgf-m.',
    source_checked_at = now()
  from seed
  where spec.id = seed.spec_id
  returning spec.id
)
select count(*) as updated_verified_honda_fk8_wheel_rows
from updated_primary;
