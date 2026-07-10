-- Offset Lab Torque Hub
-- Pack 002: initial wheel lug torque coverage for common Japanese sport platforms.
--
-- Plain SQL only. Safe to re-run.
-- Existing matching torque_specs rows are retained and not overwritten.
--
-- Source status:
-- - needs_review: commonly published owner-manual / service-reference value,
--   but source URL still needs to be attached before promoting to verified.

with seed(make_name, model_name, generation_name, start_year, end_year, component, fastener, torque_ft_lb, torque_nm, notes, warning, source_status, source_name, source_url, source_note) as (
  values
    ('Toyota', 'GR86', 'ZN8 GR86', 2022, null, 'Wheels', 'Wheel lug nuts', 89, 120, 'Tighten in a criss-cross/star pattern with a calibrated torque wrench. Re-check after wheel service.', null, 'needs_review', 'Toyota GR86 owner manual / service reference', null, 'Initial seed value. Attach model-year manual URL before marking verified.'),
    ('Subaru', 'BRZ', 'ZD8 BRZ', 2022, null, 'Wheels', 'Wheel lug nuts', 89, 120, 'Tighten in a criss-cross/star pattern with a calibrated torque wrench. Re-check after wheel service.', null, 'needs_review', 'Subaru BRZ owner manual / service reference', null, 'Initial seed value. Attach model-year manual URL before marking verified.'),
    ('Toyota', 'GR Corolla', 'E210 GR Corolla', 2023, null, 'Wheels', 'Wheel lug nuts', 76, 103, 'Tighten in a criss-cross/star pattern with a calibrated torque wrench. Re-check after wheel service.', null, 'needs_review', 'Toyota Corolla / GR Corolla owner manual reference', null, 'Initial seed value. Verify against exact GR Corolla model-year manual before marking verified.'),
    ('Toyota', 'Supra', 'A90/A91 GR Supra', 2020, null, 'Wheels', 'Wheel lug bolts', 103, 140, 'BMW-platform wheel bolt torque reference. Tighten in a criss-cross/star pattern with a calibrated torque wrench.', null, 'needs_review', 'Toyota GR Supra / BMW platform service reference', null, 'Initial seed value. Attach exact Supra manual or repair manual source before marking verified.'),
    ('Honda', 'Civic Type R', 'FK8 - Civic Type R', 2017, 2021, 'Wheels', 'Wheel lug nuts', 93, 126, 'Tighten in a criss-cross/star pattern with a calibrated torque wrench. Re-check after wheel service.', null, 'needs_review', 'Honda Civic Type R owner manual / service reference', null, 'Initial seed value. Existing Torque Hub values are retained if already present.'),
    ('Honda', 'Civic Type R', 'FL5 - Civic Type R', 2023, null, 'Wheels', 'Wheel lug nuts', 93, 126, 'Tighten in a criss-cross/star pattern with a calibrated torque wrench. Re-check after wheel service.', null, 'needs_review', 'Honda Civic Type R owner manual / service reference', null, 'Initial seed value. Existing Torque Hub values are retained if already present.'),
    ('Honda', 'Civic', 'FC/FK - 10th Gen Civic', 2016, 2021, 'Wheels', 'Wheel lug nuts', 80, 108, 'Tighten in a criss-cross/star pattern with a calibrated torque wrench. Re-check after wheel service.', null, 'needs_review', 'Honda Civic owner manual / service reference', null, 'Initial seed value. Existing Torque Hub values are retained if already present.'),
    ('Honda', 'Civic', 'FE/FL - 11th Gen Civic', 2022, null, 'Wheels', 'Wheel lug nuts', 80, 108, 'Tighten in a criss-cross/star pattern with a calibrated torque wrench. Re-check after wheel service.', null, 'needs_review', 'Honda Civic owner manual / service reference', null, 'Initial seed value. Existing Torque Hub values are retained if already present.'),
    ('Honda', 'S2000', 'AP1 - S2000', 2000, 2003, 'Wheels', 'Wheel lug nuts', 80, 108, 'Tighten in a criss-cross/star pattern with a calibrated torque wrench. Re-check after wheel service.', null, 'needs_review', 'Honda S2000 owner manual / service reference', null, 'Initial seed value. Existing Torque Hub values are retained if already present.'),
    ('Honda', 'S2000', 'AP2 - S2000', 2004, 2009, 'Wheels', 'Wheel lug nuts', 80, 108, 'Tighten in a criss-cross/star pattern with a calibrated torque wrench. Re-check after wheel service.', null, 'needs_review', 'Honda S2000 owner manual / service reference', null, 'Initial seed value. Existing Torque Hub values are retained if already present.'),
    ('Acura', 'RSX', 'DC5 - RSX', 2002, 2006, 'Wheels', 'Wheel lug nuts', 80, 108, 'Tighten in a criss-cross/star pattern with a calibrated torque wrench. Re-check after wheel service.', null, 'needs_review', 'Acura RSX owner manual / Honda service reference', null, 'Initial seed value. Attach exact Acura source before marking verified.'),
    ('Acura', 'Integra', 'DE4 - Integra', 2023, null, 'Wheels', 'Wheel lug nuts', 80, 108, 'Tighten in a criss-cross/star pattern with a calibrated torque wrench. Re-check after wheel service.', null, 'needs_review', 'Acura Integra owner manual / Honda service reference', null, 'Initial seed value. Attach exact Acura source before marking verified.'),
    ('Mazda', 'MX-5 Miata', 'ND - MX-5 Miata', 2016, null, 'Wheels', 'Wheel lug nuts', 80, 108, 'Tighten in a criss-cross/star pattern with a calibrated torque wrench. Re-check after wheel service.', null, 'needs_review', 'Mazda MX-5 Miata owner manual / service reference', null, 'Initial seed value. Attach exact Mazda source before marking verified.'),
    ('Subaru', 'WRX/STI', 'VA - WRX/STI', 2015, 2021, 'Wheels', 'Wheel lug nuts', 89, 120, 'Tighten in a criss-cross/star pattern with a calibrated torque wrench. Re-check after wheel service.', null, 'needs_review', 'Subaru WRX/STI owner manual / service reference', null, 'Initial seed value. Verify exact model-year manual before marking verified.'),
    ('Nissan', 'Z', 'RZ34 - Z', 2023, null, 'Wheels', 'Wheel lug nuts', 80, 108, 'Tighten in a criss-cross/star pattern with a calibrated torque wrench. Re-check after wheel service.', null, 'needs_review', 'Nissan Z owner manual / service reference', null, 'Initial seed value. Attach exact Nissan source before marking verified.'),
    ('Nissan', '370Z', 'Z34 - 370Z', 2009, 2020, 'Wheels', 'Wheel lug nuts', 80, 108, 'Tighten in a criss-cross/star pattern with a calibrated torque wrench. Re-check after wheel service.', null, 'needs_review', 'Nissan 370Z owner manual / service reference', null, 'Initial seed value. Attach exact Nissan source before marking verified.'),
    ('Nissan', '350Z', 'Z33 - 350Z', 2003, 2008, 'Wheels', 'Wheel lug nuts', 80, 108, 'Tighten in a criss-cross/star pattern with a calibrated torque wrench. Re-check after wheel service.', null, 'needs_review', 'Nissan 350Z owner manual / service reference', null, 'Initial seed value. Attach exact Nissan source before marking verified.')
)
insert into public.torque_vehicle_makes (name, slug)
select distinct make_name, trim(both '-' from regexp_replace(lower(make_name), '[^a-z0-9]+', '-', 'g'))
from seed
where not exists (
  select 1
  from public.torque_vehicle_makes existing
  where existing.slug = trim(both '-' from regexp_replace(lower(seed.make_name), '[^a-z0-9]+', '-', 'g'))
);

with seed(make_name, model_name) as (
  values
    ('Toyota', 'GR86'),
    ('Subaru', 'BRZ'),
    ('Toyota', 'GR Corolla'),
    ('Toyota', 'Supra'),
    ('Honda', 'Civic Type R'),
    ('Honda', 'Civic'),
    ('Honda', 'S2000'),
    ('Acura', 'RSX'),
    ('Acura', 'Integra'),
    ('Mazda', 'MX-5 Miata'),
    ('Subaru', 'WRX/STI'),
    ('Nissan', 'Z'),
    ('Nissan', '370Z'),
    ('Nissan', '350Z')
)
insert into public.torque_vehicle_models (make_id, name, slug)
select distinct
  make_row.id,
  seed.model_name,
  trim(both '-' from regexp_replace(lower(seed.model_name), '[^a-z0-9]+', '-', 'g'))
from seed
join public.torque_vehicle_makes make_row
  on make_row.slug = trim(both '-' from regexp_replace(lower(seed.make_name), '[^a-z0-9]+', '-', 'g'))
where not exists (
  select 1
  from public.torque_vehicle_models existing
  where existing.make_id = make_row.id
    and existing.slug = trim(both '-' from regexp_replace(lower(seed.model_name), '[^a-z0-9]+', '-', 'g'))
);

with seed(make_name, model_name, generation_name, start_year, end_year) as (
  values
    ('Toyota', 'GR86', 'ZN8 GR86', 2022, null),
    ('Subaru', 'BRZ', 'ZD8 BRZ', 2022, null),
    ('Toyota', 'GR Corolla', 'E210 GR Corolla', 2023, null),
    ('Toyota', 'Supra', 'A90/A91 GR Supra', 2020, null),
    ('Honda', 'Civic Type R', 'FK8 - Civic Type R', 2017, 2021),
    ('Honda', 'Civic Type R', 'FL5 - Civic Type R', 2023, null),
    ('Honda', 'Civic', 'FC/FK - 10th Gen Civic', 2016, 2021),
    ('Honda', 'Civic', 'FE/FL - 11th Gen Civic', 2022, null),
    ('Honda', 'S2000', 'AP1 - S2000', 2000, 2003),
    ('Honda', 'S2000', 'AP2 - S2000', 2004, 2009),
    ('Acura', 'RSX', 'DC5 - RSX', 2002, 2006),
    ('Acura', 'Integra', 'DE4 - Integra', 2023, null),
    ('Mazda', 'MX-5 Miata', 'ND - MX-5 Miata', 2016, null),
    ('Subaru', 'WRX/STI', 'VA - WRX/STI', 2015, 2021),
    ('Nissan', 'Z', 'RZ34 - Z', 2023, null),
    ('Nissan', '370Z', 'Z34 - 370Z', 2009, 2020),
    ('Nissan', '350Z', 'Z33 - 350Z', 2003, 2008)
)
insert into public.torque_vehicle_generations (model_id, name, slug, start_year, end_year)
select distinct
  model_row.id,
  seed.generation_name,
  trim(both '-' from regexp_replace(lower(seed.generation_name), '[^a-z0-9]+', '-', 'g')),
  seed.start_year,
  seed.end_year
from seed
join public.torque_vehicle_makes make_row
  on make_row.slug = trim(both '-' from regexp_replace(lower(seed.make_name), '[^a-z0-9]+', '-', 'g'))
join public.torque_vehicle_models model_row
  on model_row.make_id = make_row.id
 and model_row.slug = trim(both '-' from regexp_replace(lower(seed.model_name), '[^a-z0-9]+', '-', 'g'))
where not exists (
  select 1
  from public.torque_vehicle_generations existing
  where existing.model_id = model_row.id
    and existing.slug = trim(both '-' from regexp_replace(lower(seed.generation_name), '[^a-z0-9]+', '-', 'g'))
);

with seed(make_name, model_name, generation_name, component, fastener, torque_ft_lb, torque_nm, angle_degrees, notes, warning, source_status, source_name, source_url, source_note) as (
  values
    ('Toyota', 'GR86', 'ZN8 GR86', 'Wheels', 'Wheel lug nuts', 89, 120, null, 'Tighten in a criss-cross/star pattern with a calibrated torque wrench. Re-check after wheel service.', null, 'needs_review', 'Toyota GR86 owner manual / service reference', null, 'Initial seed value. Attach model-year manual URL before marking verified.'),
    ('Subaru', 'BRZ', 'ZD8 BRZ', 'Wheels', 'Wheel lug nuts', 89, 120, null, 'Tighten in a criss-cross/star pattern with a calibrated torque wrench. Re-check after wheel service.', null, 'needs_review', 'Subaru BRZ owner manual / service reference', null, 'Initial seed value. Attach model-year manual URL before marking verified.'),
    ('Toyota', 'GR Corolla', 'E210 GR Corolla', 'Wheels', 'Wheel lug nuts', 76, 103, null, 'Tighten in a criss-cross/star pattern with a calibrated torque wrench. Re-check after wheel service.', null, 'needs_review', 'Toyota Corolla / GR Corolla owner manual reference', null, 'Initial seed value. Verify against exact GR Corolla model-year manual before marking verified.'),
    ('Toyota', 'Supra', 'A90/A91 GR Supra', 'Wheels', 'Wheel lug bolts', 103, 140, null, 'BMW-platform wheel bolt torque reference. Tighten in a criss-cross/star pattern with a calibrated torque wrench.', null, 'needs_review', 'Toyota GR Supra / BMW platform service reference', null, 'Initial seed value. Attach exact Supra manual or repair manual source before marking verified.'),
    ('Honda', 'Civic Type R', 'FK8 - Civic Type R', 'Wheels', 'Wheel lug nuts', 93, 126, null, 'Tighten in a criss-cross/star pattern with a calibrated torque wrench. Re-check after wheel service.', null, 'needs_review', 'Honda Civic Type R owner manual / service reference', null, 'Initial seed value. Existing Torque Hub values are retained if already present.'),
    ('Honda', 'Civic Type R', 'FL5 - Civic Type R', 'Wheels', 'Wheel lug nuts', 93, 126, null, 'Tighten in a criss-cross/star pattern with a calibrated torque wrench. Re-check after wheel service.', null, 'needs_review', 'Honda Civic Type R owner manual / service reference', null, 'Initial seed value. Existing Torque Hub values are retained if already present.'),
    ('Honda', 'Civic', 'FC/FK - 10th Gen Civic', 'Wheels', 'Wheel lug nuts', 80, 108, null, 'Tighten in a criss-cross/star pattern with a calibrated torque wrench. Re-check after wheel service.', null, 'needs_review', 'Honda Civic owner manual / service reference', null, 'Initial seed value. Existing Torque Hub values are retained if already present.'),
    ('Honda', 'Civic', 'FE/FL - 11th Gen Civic', 'Wheels', 'Wheel lug nuts', 80, 108, null, 'Tighten in a criss-cross/star pattern with a calibrated torque wrench. Re-check after wheel service.', null, 'needs_review', 'Honda Civic owner manual / service reference', null, 'Initial seed value. Existing Torque Hub values are retained if already present.'),
    ('Honda', 'S2000', 'AP1 - S2000', 'Wheels', 'Wheel lug nuts', 80, 108, null, 'Tighten in a criss-cross/star pattern with a calibrated torque wrench. Re-check after wheel service.', null, 'needs_review', 'Honda S2000 owner manual / service reference', null, 'Initial seed value. Existing Torque Hub values are retained if already present.'),
    ('Honda', 'S2000', 'AP2 - S2000', 'Wheels', 'Wheel lug nuts', 80, 108, null, 'Tighten in a criss-cross/star pattern with a calibrated torque wrench. Re-check after wheel service.', null, 'needs_review', 'Honda S2000 owner manual / service reference', null, 'Initial seed value. Existing Torque Hub values are retained if already present.'),
    ('Acura', 'RSX', 'DC5 - RSX', 'Wheels', 'Wheel lug nuts', 80, 108, null, 'Tighten in a criss-cross/star pattern with a calibrated torque wrench. Re-check after wheel service.', null, 'needs_review', 'Acura RSX owner manual / Honda service reference', null, 'Initial seed value. Attach exact Acura source before marking verified.'),
    ('Acura', 'Integra', 'DE4 - Integra', 'Wheels', 'Wheel lug nuts', 80, 108, null, 'Tighten in a criss-cross/star pattern with a calibrated torque wrench. Re-check after wheel service.', null, 'needs_review', 'Acura Integra owner manual / Honda service reference', null, 'Initial seed value. Attach exact Acura source before marking verified.'),
    ('Mazda', 'MX-5 Miata', 'ND - MX-5 Miata', 'Wheels', 'Wheel lug nuts', 80, 108, null, 'Tighten in a criss-cross/star pattern with a calibrated torque wrench. Re-check after wheel service.', null, 'needs_review', 'Mazda MX-5 Miata owner manual / service reference', null, 'Initial seed value. Attach exact Mazda source before marking verified.'),
    ('Subaru', 'WRX/STI', 'VA - WRX/STI', 'Wheels', 'Wheel lug nuts', 89, 120, null, 'Tighten in a criss-cross/star pattern with a calibrated torque wrench. Re-check after wheel service.', null, 'needs_review', 'Subaru WRX/STI owner manual / service reference', null, 'Initial seed value. Verify exact model-year manual before marking verified.'),
    ('Nissan', 'Z', 'RZ34 - Z', 'Wheels', 'Wheel lug nuts', 80, 108, null, 'Tighten in a criss-cross/star pattern with a calibrated torque wrench. Re-check after wheel service.', null, 'needs_review', 'Nissan Z owner manual / service reference', null, 'Initial seed value. Attach exact Nissan source before marking verified.'),
    ('Nissan', '370Z', 'Z34 - 370Z', 'Wheels', 'Wheel lug nuts', 80, 108, null, 'Tighten in a criss-cross/star pattern with a calibrated torque wrench. Re-check after wheel service.', null, 'needs_review', 'Nissan 370Z owner manual / service reference', null, 'Initial seed value. Attach exact Nissan source before marking verified.'),
    ('Nissan', '350Z', 'Z33 - 350Z', 'Wheels', 'Wheel lug nuts', 80, 108, null, 'Tighten in a criss-cross/star pattern with a calibrated torque wrench. Re-check after wheel service.', null, 'needs_review', 'Nissan 350Z owner manual / service reference', null, 'Initial seed value. Attach exact Nissan source before marking verified.')
)
insert into public.torque_specs (
  generation_id,
  category_id,
  component,
  fastener,
  torque_ft_lb,
  torque_nm,
  angle_degrees,
  notes,
  warning,
  source_status,
  source_name,
  source_url,
  source_note,
  source_checked_at
)
select
  generation_row.id,
  category_row.id,
  seed.component,
  seed.fastener,
  seed.torque_ft_lb::numeric,
  seed.torque_nm::numeric,
  seed.angle_degrees::numeric,
  seed.notes,
  seed.warning,
  seed.source_status,
  seed.source_name,
  seed.source_url,
  seed.source_note,
  now()
from seed
join public.torque_vehicle_makes make_row
  on make_row.slug = trim(both '-' from regexp_replace(lower(seed.make_name), '[^a-z0-9]+', '-', 'g'))
join public.torque_vehicle_models model_row
  on model_row.make_id = make_row.id
 and model_row.slug = trim(both '-' from regexp_replace(lower(seed.model_name), '[^a-z0-9]+', '-', 'g'))
join public.torque_vehicle_generations generation_row
  on generation_row.model_id = model_row.id
 and generation_row.slug = trim(both '-' from regexp_replace(lower(seed.generation_name), '[^a-z0-9]+', '-', 'g'))
join public.torque_categories category_row
  on category_row.slug = trim(both '-' from regexp_replace(lower(seed.component), '[^a-z0-9]+', '-', 'g'))
where not exists (
  select 1
  from public.torque_specs existing
  where existing.generation_id = generation_row.id
    and existing.category_id = category_row.id
    and lower(existing.component) = lower(seed.component)
    and lower(existing.fastener) = lower(seed.fastener)
);
