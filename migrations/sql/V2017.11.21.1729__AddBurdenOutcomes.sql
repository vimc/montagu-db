insert into burden_outcome (code, name)
values ('hepb_cases_fulminant', 'Cases of Hep B fulminant acute infection'), ('hepb_prevalence_hbsag', 'Prevalence of HepB surface antigen')
ON CONFLICT (code)
DO NOTHING;