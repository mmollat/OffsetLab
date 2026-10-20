-- REVIEW DECISION: recommend active + verified only. Do not publish needs_review
-- or community recommendations without a separate product decision.
BEGIN;
ALTER TABLE public.fitment_preset_variants ENABLE ROW LEVEL SECURITY;

-- Policies combine with OR. Refuse unknown existing policies rather than quietly
-- creating an apparently narrow policy alongside a permissive one.
DO $guard$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_policy
    WHERE polrelid = 'public.fitment_preset_variants'::regclass
      AND polname <> 'fitment_variants_read_verified') THEN
    RAISE EXCEPTION 'Unexpected variant policies; review before applying';
  END IF;
END;
$guard$;

REVOKE ALL ON public.fitment_preset_variants FROM PUBLIC, anon, authenticated;
DO $columns$
DECLARE col name;
BEGIN
  FOR col IN SELECT attname FROM pg_attribute
    WHERE attrelid = 'public.fitment_preset_variants'::regclass AND attnum > 0 AND NOT attisdropped
  LOOP
    EXECUTE format('REVOKE ALL (%I) ON public.fitment_preset_variants FROM PUBLIC, anon, authenticated', col);
  END LOOP;
END;
$columns$;
DROP POLICY IF EXISTS fitment_variants_read_verified ON public.fitment_preset_variants;
CREATE POLICY fitment_variants_read_verified
  ON public.fitment_preset_variants FOR SELECT TO anon, authenticated
  USING (active = true AND source_status = 'verified');
GRANT SELECT (make, model, trim, style, goal, configuration,
  front, rear, front_tire, rear_tire, note, active)
  ON public.fitment_preset_variants TO anon, authenticated;
-- UUID IDs need no sequence. No service-role or write grants are introduced.
COMMIT;
