-- Offset Lab Torque Hub
-- Pack 029: verified wheel torque coverage for Monday scout gaps.
--
-- Plain SQL only. Safe to re-run.
--
-- Scope:
-- - Updates exactly six existing live torque_specs rows by UUID.
-- - Does not insert rows.
-- - Does not alter schema.
-- - Promotes only wheel lug nut/bolt rows from needs_review to verified.
--
-- Platforms:
-- - Ford S650 Mustang
-- - Chevrolet C8 Corvette
-- - Honda FL5 Civic Type R
-- - Toyota A90/A91 Supra
-- - Toyota E210 GR Corolla
-- - BMW G87 M2

with seed(spec_id, fastener, torque_ft_lb, torque_nm, source_name, source_url, source_note, notes, warning) as (
  values
    (
      'd3a3c159-beb0-4ad8-9c76-c4767543d274'::uuid,
      'Wheel lug nuts',
      150,
      204,
      'Ford 2024 Mustang Owner Manual',
      'https://carmanuals2.com/ford/mustang-2024-owner-s-manual-124049/page-365/',
      'Verified from 2024 Ford Mustang owner manual Wheel Nuts section: M14 x 1.5 wheel nuts list 150 lb.ft / 204 Nm, with retightening after wheel disturbance.',
      'Ford owner manual specifies 150 lb-ft / 204 Nm for M14 x 1.5 wheel nuts. Tighten in a star pattern with clean, dry threads and a calibrated torque wrench.',
      'Use only Ford-recommended replacement wheel fasteners. Retighten after wheel disturbance per the owner manual.'
    ),
    (
      '01e076e7-c8b1-41b0-85f3-1b8ea8ee9138'::uuid,
      'Wheel lug nuts',
      140,
      190,
      'Chevrolet 2024 Corvette Owner Manual',
      'https://www.carmanualsonline.info/chevrolet-corvette-2024-owners-manual/?srch=wheel+torque',
      'Verified from 2024 Chevrolet Corvette owner manual Capacities and Specifications table: Wheel Nut Torque lists 190 N-m / 140 lb-ft.',
      'Chevrolet owner manual specifies 140 lb-ft / 190 Nm for C8 Corvette wheel nuts. Tighten evenly in a criss-cross/star pattern with a calibrated torque wrench.',
      'Use the correct GM wheel nuts/studs for the wheel type. Carbon fiber wheels require the correct stud length per GM warning text.'
    ),
    (
      '3256eaee-4db6-41f9-98cb-869fb7a2aebb'::uuid,
      'Wheel lug nuts',
      94,
      127,
      'Honda 2025 Civic Hatchback Owner Manual',
      'https://techinfo.honda.com/rjanisis/pubs/OM/AH/AT402525IOM/enu/details/131271047-14882.html',
      'Verified from Honda 2025 Civic Hatchback owner manual Tire Rotation page: manual transmission models list wheel nut torque as 94 lbf-ft / 127 N-m. FL5 Civic Type R is manual transmission; earlier 2023 flat-tire text has conflicting 80 lbf-ft language, so this row is tied to current Honda manual guidance.',
      'Honda current owner-manual tire rotation guidance lists 94 lb-ft / 127 Nm for manual-transmission Civic models. Tighten in the indicated criss-cross/star order with a calibrated torque wrench.',
      'Use the correct Honda wheel nuts and wheel-seat type. Do not lubricate threads or seats unless Honda service information explicitly instructs it.'
    ),
    (
      '2f1dcc4e-312b-45a8-874e-10b751facf93'::uuid,
      'Wheel lug bolts',
      103,
      140,
      'Toyota GR Supra Owner Manual',
      'https://www.carmanualsonline.info/toyota-gr-supra-2022-owners-manual/?srch=wheel+bolt+torque',
      'Verified from Toyota GR Supra owner manual wheel lug lock installation guidance: tightening torque is 101 lb-ft / 140 Nm. Offset Lab keeps the existing 103 lb-ft convention for 140 Nm Toyota/BMW-platform wheel bolts.',
      'Toyota GR Supra owner manual guidance specifies 140 Nm for wheel lug bolts. Tighten in a star pattern with clean, dry threads and a calibrated torque wrench.',
      'Use the correct Toyota/BMW-platform lug bolts and wheel lock adapter where equipped. Do not lubricate threads unless service information explicitly instructs it.'
    ),
    (
      '18aaf465-527a-4c7c-a93a-41da9856e7d3'::uuid,
      'Wheel lug nuts',
      76,
      103,
      'Toyota GR Corolla Owner Manual',
      'https://manual.toyota.jp/gr_corolla/2503/cv/ja_JP/contents/vhch06se030405.php',
      'Verified from Toyota GR Corolla owner manual tire installation guidance: tightening torque is 103 N-m / 1050 kgf-cm, equivalent to 76 lb-ft.',
      'Toyota owner manual specifies 76 lb-ft / 103 Nm for GR Corolla wheel lug nuts. Tighten in the indicated criss-cross/star order with a calibrated torque wrench.',
      'Use the correct Toyota wheel nuts and do not apply oil or grease to threads or nuts unless Toyota service information explicitly instructs it.'
    ),
    (
      '471a60de-691a-421e-956f-f30f02d6b98d'::uuid,
      'Wheel lug bolts',
      101,
      140,
      'BMW M2 owner manual wheel-change guidance',
      'https://carmanuals2.com/bmw/m2-2024-owner-s-manual-127623',
      'Verified from BMW M2 owner manual wheel-change guidance family: wheel lug bolt tightening torque is 101 lb-ft / 140 N-m.',
      'BMW owner manual wheel-change guidance specifies 101 lb-ft / 140 Nm for wheel lug bolts. Tighten in a diagonal/star pattern with clean, dry threads and a calibrated torque wrench.',
      'Use the correct BMW M14 x 1.25 lug bolts for the wheel. Never use oil, grease, or anti-seize on wheel bolts, hub threads, or mounting surfaces unless BMW service information explicitly instructs it.'
    )
)
update public.torque_specs spec
set
  component = 'Wheels',
  fastener = seed.fastener,
  torque_ft_lb = seed.torque_ft_lb::numeric,
  torque_nm = seed.torque_nm::numeric,
  angle_degrees = null,
  notes = seed.notes,
  warning = seed.warning,
  source_status = 'verified',
  source_name = seed.source_name,
  source_url = seed.source_url,
  source_note = seed.source_note,
  source_checked_at = now()
from seed
where spec.id = seed.spec_id
returning
  spec.id,
  spec.fastener,
  spec.torque_ft_lb,
  spec.torque_nm,
  spec.source_status,
  spec.source_name;
