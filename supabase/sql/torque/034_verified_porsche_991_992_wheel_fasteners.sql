-- Offset Lab Torque Hub
-- Pack 034: resolve Porsche 991/992 wheel-fastener conflicts.
--
-- Plain SQL only. Safe to re-run.
-- Separates conventional five-lug wheel bolts from GT center locks:
-- - 991/992 conventional wheel bolts: 118 ft-lb / 160 Nm
-- - 991/992 GT center lock: 443 ft-lb / 600 Nm
--
-- The broad 997 GT rows are intentionally not changed here because that
-- generation spans both five-lug and center-lock applications by model year.

with obsolete(spec_id) as (
  values
    ('ce1a9fa8-9b86-4681-bd26-e5bbd00394b4'::uuid),
    ('2a9b27a8-1f4a-47ea-96b5-3414a18c8778'::uuid),
    ('27bf0aa9-d71b-4418-bd68-a0a65e4ba8f2'::uuid),
    ('8698421e-5e16-420f-9cff-166e3324d5cf'::uuid)
)
delete from public.torque_specs spec
using obsolete
where spec.id = obsolete.spec_id
  and spec.source_status = 'community';

with conventional(spec_id) as (
  values
    ('923df62f-238f-44ff-a8b1-0e919e0c6fdf'::uuid),
    ('e565f53d-e79c-4dab-8215-7769995e874f'::uuid)
)
update public.torque_specs spec
set
  component = 'Wheels',
  fastener = 'Conventional wheel bolts (five-lug)',
  torque_ft_lb = 118,
  torque_nm = 160,
  angle_degrees = null,
  notes = 'Porsche owner-manual wheel-change guidance specifies 118 ft-lb / 160 Nm for conventional wheel bolts. Tighten evenly in a diagonal sequence with clean seating surfaces and a calibrated torque wrench.',
  warning = 'This value is only for conventional five-lug wheel bolts. Do not use it for Porsche center-lock wheels, which require a different procedure and substantially higher torque.',
  source_status = 'verified',
  source_name = 'Porsche 911 owner manual wheel-change guidance',
  source_url = 'https://www.manualslib.com/manual/1007087/Porsche-911-Carrera.html',
  source_note = 'Verified from Porsche 991-era owner-manual guidance: conventional wheel bolt tightening torque is 118 ft-lb / 160 Nm.',
  source_checked_at = now()
from conventional
where spec.id = conventional.spec_id;

with center_lock(spec_id, source_name, source_url, source_note) as (
  values
    (
      'b9394758-ded7-4002-840e-2ef9189b1213'::uuid,
      'Porsche 991 GT3 Driver''s Manual',
      'https://files.porsche.com/filestore/download/china/en/911gt3driversmanual04-14/default/bafa1477-2648-11e6-9225-0019999cd470/911-GT3-Driver%27s-Manual-%2804-14%29.pdf',
      'Verified from Porsche 991 GT3 wheel-change guidance: center-lock tightening torque is 443 ft-lb / 600 Nm.'
    ),
    (
      'a1b2bc56-9ac1-43bf-87cc-7c04ab7ab673'::uuid,
      'Porsche 991 GT3 / GT3 RS owner-manual guidance',
      'https://files.porsche.com/filestore/download/china/en/911gt3driversmanual04-14/default/bafa1477-2648-11e6-9225-0019999cd470/911-GT3-Driver%27s-Manual-%2804-14%29.pdf',
      'Verified from Porsche 991 GT center-lock wheel-change guidance: prescribed tightening torque is 443 ft-lb / 600 Nm.'
    ),
    (
      'a941bd54-ab86-4230-b902-46e54c8d6ea7'::uuid,
      'Porsche 992 GT3 owner-manual race-circuit guidance',
      'https://www.manualslib.com/manual/3214613/Porsche-911-Gt3-2021.html?page=5',
      'Verified from Porsche 992 GT3 guidance: always fasten center-lock wheels to the prescribed tightening torque of 443 ft-lb / 600 Nm.'
    ),
    (
      '6bfd655c-1fa5-4709-ba58-fe59022d98f5'::uuid,
      'Porsche 992 GT3 RS owner-manual and AfterSales guidance',
      'https://static.oemdtc.com/NHTSA-PDFs/MC-10188270-0001.pdf',
      'Verified from Porsche technical information for 911 GT3 RS wheels with central lock: wheel mounting tightening torque is 600 Nm / 444 ft-lb; Offset Lab displays Porsche owner-manual convention of 443 ft-lb / 600 Nm.'
    )
)
update public.torque_specs spec
set
  component = 'Wheels',
  fastener = 'Center-lock wheel nut',
  torque_ft_lb = 443,
  torque_nm = 600,
  angle_degrees = null,
  notes = 'Porsche GT center-lock wheel guidance specifies 443 ft-lb / 600 Nm. The complete Porsche center-lock removal, lubrication, inspection, locking, and verification procedure must be followed.',
  warning = 'Center-lock wheels are safety-critical and require Porsche-specific tools and procedures. Do not apply this value to conventional five-lug wheel bolts. Have the work performed or checked by a qualified Porsche technician if the required procedure is not fully understood.',
  source_status = 'verified',
  source_name = center_lock.source_name,
  source_url = center_lock.source_url,
  source_note = center_lock.source_note,
  source_checked_at = now()
from center_lock
where spec.id = center_lock.spec_id;

select
  count(*) filter (where source_status = 'verified') as verified_porsche_991_992_wheel_rows,
  count(*) filter (where source_status <> 'verified') as remaining_unverified_porsche_991_992_wheel_rows
from public.torque_specs
where id in (
  '923df62f-238f-44ff-a8b1-0e919e0c6fdf'::uuid,
  'e565f53d-e79c-4dab-8215-7769995e874f'::uuid,
  'b9394758-ded7-4002-840e-2ef9189b1213'::uuid,
  'a1b2bc56-9ac1-43bf-87cc-7c04ab7ab673'::uuid,
  'a941bd54-ab86-4230-b902-46e54c8d6ea7'::uuid,
  '6bfd655c-1fa5-4709-ba58-fe59022d98f5'::uuid
);
