alter table public.fitment_presets
  add column if not exists factory_front text,
  add column if not exists factory_rear text,
  add column if not exists factory_tire text;

comment on column public.fitment_presets.factory_front is
  'True factory front wheel spec for this make/model/trim, used for baseline comparisons.';

comment on column public.fitment_presets.factory_rear is
  'True factory rear wheel spec for this make/model/trim, used for baseline comparisons.';

comment on column public.fitment_presets.factory_tire is
  'True factory tire spec for this make/model/trim, used for baseline comparisons.';
