create table if not exists public.fitment_preset_variants (
  id uuid primary key default gen_random_uuid(),
  make text not null,
  model text not null,
  trim text not null,
  style text not null check (style in ('oemplus', 'flush', 'aggressive')),
  goal text not null check (goal in ('street', 'track')),
  configuration text not null check (configuration in ('staggered', 'square')),
  front text not null,
  rear text not null,
  front_tire text not null,
  rear_tire text not null,
  note text,
  source_status text not null default 'needs_review' check (source_status in ('verified', 'community', 'needs_review')),
  source_note text,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (make, model, trim, style, goal, configuration)
);

create index if not exists fitment_preset_variants_lookup_idx
  on public.fitment_preset_variants (make, model, trim, style, goal, configuration)
  where active = true;

comment on table public.fitment_preset_variants is
  'Goal/configuration-specific fitment variants, such as street square and track square recommendations.';

with variants(make, model, style, goal, configuration, front, rear, front_tire, rear_tire, note) as (
  values
    ('Tesla', 'Model 3', 'oemplus', 'street', 'square', '20x8.5 +35', '20x8.5 +35', '235/35R20', '235/35R20', 'Factory-style square Tesla Model 3 setup.'),
    ('Tesla', 'Model 3', 'flush', 'street', 'square', '19x9.5 +30', '19x9.5 +30', '275/35R19', '275/35R19', 'Square flush alternative for better rotation and balanced handling.'),
    ('Tesla', 'Model 3', 'aggressive', 'street', 'square', '19x9.5 +22', '19x9.5 +22', '265/35R19', '265/35R19', 'Aggressive square Tesla setup with improved balance, rotation capability, and cleaner real-world street fitment.'),
    ('Tesla', 'Model Y', 'oemplus', 'street', 'square', '21x9.5 +40', '21x9.5 +40', '255/35R21', '255/35R21', 'Factory-style square Tesla Model Y setup.'),
    ('Tesla', 'Model Y', 'flush', 'street', 'square', '20x9.5 +35', '20x9.5 +35', '265/40R20', '265/40R20', 'Square flush alternative for better rotation and balanced handling.'),
    ('Tesla', 'Model Y', 'aggressive', 'street', 'square', '21x9.5 +30', '21x9.5 +30', '275/35R21', '275/35R21', 'Square aggressive Tesla setup prioritizing balance and rotation over rear stagger.'),
    ('Tesla', 'Model S', 'flush', 'street', 'square', '21x9.5 +35', '21x9.5 +35', '265/35R21', '265/35R21', 'Square alternative for owners prioritizing rotation and balance over rear stagger.'),
    ('Tesla', 'Model S', 'aggressive', 'street', 'square', '21x10 +30', '21x10 +30', '275/35R21', '275/35R21', 'Square aggressive alternative for more balanced handling and tire rotation.'),
    ('Tesla', 'Model X', 'flush', 'street', 'square', '22x10 +30', '22x10 +30', '275/35R22', '275/35R22', 'Square alternative for owners prioritizing rotation and balanced fitment.'),
    ('Tesla', 'Model X', 'aggressive', 'street', 'square', '22x10.5 +28', '22x10.5 +28', '285/35R22', '285/35R22', 'Square aggressive alternative for more balanced handling and tire rotation.'),
    ('BMW', 'M3', 'oemplus', 'street', 'square', '19x9.5 ET20', '19x9.5 ET20', '275/35R19', '275/35R19', 'BMW M3 OEM+ square setup with factory-like balance and easy rotation.'),
    ('BMW', 'M3', 'flush', 'street', 'square', '20x10 ET15', '20x10 ET15', '285/30R20', '285/30R20', 'BMW M3 square street setup. Popular for track-minded owners who still want a strong visual stance.'),
    ('BMW', 'M3', 'aggressive', 'street', 'square', '20x10 ET12', '20x10 ET12', '285/30R20', '285/30R20', 'BMW M3 aggressive square setup prioritizing front-end bite, rotation, and balance.'),
    ('BMW', 'M4', 'oemplus', 'street', 'square', '19x9.5 ET20', '19x9.5 ET20', '275/35R19', '275/35R19', 'BMW M4 OEM+ square setup with factory-like balance and easy rotation.'),
    ('BMW', 'M4', 'flush', 'street', 'square', '20x10 ET15', '20x10 ET15', '285/30R20', '285/30R20', 'BMW M4 square street setup. Popular for track-minded owners who still want a strong visual stance.'),
    ('BMW', 'M4', 'aggressive', 'street', 'square', '20x10 ET12', '20x10 ET12', '285/30R20', '285/30R20', 'BMW M4 aggressive square setup prioritizing front-end bite, rotation, and balance.'),
    ('Tesla', 'Model 3', 'oemplus', 'track', 'square', '19x9.5 +30', '19x9.5 +30', '275/35R19', '275/35R19', 'Most track-focused Model 3 drivers run square setups for balance and tire rotation.'),
    ('Tesla', 'Model 3', 'flush', 'track', 'square', '19x9.5 +25', '19x9.5 +25', '275/35R19', '275/35R19', 'Track-biased square Model 3 setup with strong balance and repeatability.'),
    ('Tesla', 'Model 3', 'aggressive', 'track', 'square', '18x10 +25', '18x10 +25', '295/35R18', '295/35R18', 'Aggressive track-focused Model 3 square setup prioritizing grip, rotation, and consistency.'),
    ('Tesla', 'Model Y', 'oemplus', 'track', 'square', '19x9.5 +35', '19x9.5 +35', '275/40R19', '275/40R19', 'Most track-focused Model Y setups stay square for consistency and tire rotation.'),
    ('Tesla', 'Model Y', 'flush', 'track', 'square', '19x9.5 +35', '19x9.5 +35', '275/40R19', '275/40R19', 'Track-biased Model Y square setup focused on consistency and balance.'),
    ('Tesla', 'Model Y', 'aggressive', 'track', 'square', '20x10 +30', '20x10 +30', '285/35R20', '285/35R20', 'Aggressive square Model Y track setup emphasizing front-end support and repeatability.'),
    ('BMW', 'M3', 'oemplus', 'track', 'square', '19x9.5 ET20', '19x9.5 ET20', '275/35R19', '275/35R19', 'BMW track setups prioritize rotation and consistency over staggered grip.'),
    ('BMW', 'M3', 'flush', 'track', 'square', '19x10 ET25', '19x10 ET25', '275/35R19', '275/35R19', 'Track-biased BMW M3 square setup with neutral handling and rotation flexibility.'),
    ('BMW', 'M3', 'aggressive', 'track', 'square', '18x10.5 ET20', '18x10.5 ET20', '295/35R18', '295/35R18', 'Aggressive BMW M3 square track setup for maximum front-end bite and consistency.'),
    ('BMW', 'M4', 'oemplus', 'track', 'square', '19x9.5 ET20', '19x9.5 ET20', '275/35R19', '275/35R19', 'BMW track setups prioritize rotation and consistency over staggered grip.'),
    ('BMW', 'M4', 'flush', 'track', 'square', '19x10 ET25', '19x10 ET25', '275/35R19', '275/35R19', 'Track-biased BMW M4 square setup with neutral handling and rotation flexibility.'),
    ('BMW', 'M4', 'aggressive', 'track', 'square', '18x10.5 ET20', '18x10.5 ET20', '295/35R18', '295/35R18', 'Aggressive BMW M4 square track setup for maximum front-end bite and consistency.')
)
insert into public.fitment_preset_variants (
  make,
  model,
  trim,
  style,
  goal,
  configuration,
  front,
  rear,
  front_tire,
  rear_tire,
  note,
  source_status,
  source_note
)
select distinct
  fp.make,
  fp.model,
  fp.trim,
  fp.style,
  v.goal,
  v.configuration,
  v.front,
  v.rear,
  v.front_tire,
  v.rear_tire,
  v.note,
  'needs_review',
  'Migrated from Offset Lab code fallback. Verify against OEM, tire/wheel manufacturer, or platform-specific fitment sources before marking verified.'
from public.fitment_presets fp
join variants v
  on fp.make = v.make
  and fp.model = v.model
  and fp.style = v.style
where fp.active = true
on conflict (make, model, trim, style, goal, configuration) do update set
  front = excluded.front,
  rear = excluded.rear,
  front_tire = excluded.front_tire,
  rear_tire = excluded.rear_tire,
  note = excluded.note,
  updated_at = now();
