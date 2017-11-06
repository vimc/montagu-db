UPDATE burden_outcome SET code='hepb_prevalence_hbsag' WHERE code='prev_HBsAg'

ALTER TABLE burden_outcome ADD proportion BOOL DEFAULT 'f'
UPDATE burden_outcome SET proportion='t' WHERE code='da_rate'
UPDATE burden_outcome SET proportion='t' WHERE code='hepb_prevalence_hbsag'
