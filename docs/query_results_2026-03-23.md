# Query Results — 2026-03-23

Live results from the Open Sim Hospital demo databases on the dedicated cluster.

**Host:** `db-open-demo-do-user-25666328-0.l.db.ondigitalocean.com:25060`

---

## NHS Database — `dr_open_sim_demo_nhs`

### Row Counts

| Schema | Table | Rows |
|--------|-------|------|
| `hl7v2` | `messages` | 277,700 |
| `fhir_r4` | `resources` | 27,471 |
| `sus` | `submissions` | 32,112 |
| `ecds` | `attendances` | 0 (pending) |

### Unique Patients

| Source | Unique Patients |
|--------|----------------|
| HL7v2 messages | 2,643 |
| SUS submissions | 2,640 |
| FHIR R4 resources (Patient type) | 3,000 |

### HL7v2 Message Type Distribution

| Message Type | Count | % of Total |
|--------------|-------|------------|
| ORU^R01 (Observation Result) | 222,928 | 80.28% |
| RDE^O11 (Pharmacy Order) | 23,241 | 8.37% |
| MDM^T02 (Document Notification) | 18,647 | 6.71% |
| ORM^O01 (Order Message) | 7,616 | 2.74% |
| ADT^A01 (Admit) | 2,149 | 0.77% |
| ADT^A03 (Discharge) | 2,149 | 0.77% |
| VXU^V04 (Vaccination Update) | 970 | 0.35% |

### FHIR R4 Resource Type Counts

| Resource Type | Count |
|---------------|-------|
| Condition | 20,869 |
| Patient | 3,000 |
| Encounter | 2,149 |
| Procedure | 1,453 |

### SUS Submissions by Dataset Type

| Dataset Type | Count |
|--------------|-------|
| OP (Outpatients) | 27,193 |
| APC (Admitted Patient Care) | 2,149 |
| AE (Accident & Emergency) | 1,385 |
| ECDS (Emergency Care Data Set) | 1,385 |

### APC Summary

- Total APC submissions: 2,149
- Unique patients with APC records: 1,616

### Top 20 Conditions (FHIR, by ICD-10 code)

| ICD-10 Code | Occurrences |
|-------------|-------------|
| F32.1 (Moderate depressive episode) | 6,128 |
| E11.9 (Type 2 diabetes, unspecified) | 2,014 |
| I50.9 (Heart failure, unspecified) | 1,388 |
| J44.1 (COPD with acute exacerbation) | 1,168 |
| I10 (Essential hypertension) | 1,076 |
| N18.3 (CKD stage 3) | 898 |
| I48 (Atrial fibrillation/flutter) | 599 |
| E78.5 (Dyslipidaemia, unspecified) | 394 |
| R54 (Senility) | 377 |
| K57.3 (Diverticular disease) | 362 |
| I25.9 (Chronic ischaemic heart disease) | 361 |
| E66.9 (Obesity, unspecified) | 341 |
| K21.0 (GORD with oesophagitis) | 338 |
| G40.9 (Epilepsy, unspecified) | 335 |
| O80 (Single spontaneous delivery) | 281 |
| J45.9 (Asthma, unspecified) | 278 |
| G43.9 (Migraine, unspecified) | 269 |
| E05.9 (Thyrotoxicosis, unspecified) | 260 |
| M15.0 (Primary generalised osteoarthritis) | 213 |
| M05.9 (Rheumatoid arthritis, unspecified) | 208 |

### Top Patients by Encounter Count (NHS)

| Name | Gender | Encounters | Conditions |
|------|--------|------------|------------|
| Gail Taylor | unknown | 5 | 24 |
| Kayleigh Garner | unknown | 4 | 10 |
| Kenneth Thompson | unknown | 4 | 11 |
| Shannon Adams | unknown | 4 | 31 |
| Natalie Davies | unknown | 4 | 9 |
| Peter White | unknown | 4 | 23 |

### Data Date Range

- Earliest: 2026-03-21 22:01:04 UTC
- Latest: 2026-03-21 22:01:14 UTC

---

## USA Database — `dr_open_sim_demo_usa`

### Row Counts

| Schema | Table | Rows |
|--------|-------|------|
| `fhir_r4` | `resources` | 27,601 |
| `hl7v2` | `messages` | 0 (pending) |

### Unique Patients

| Source | Unique Patients |
|--------|----------------|
| FHIR R4 resources | 11,000 |

### FHIR R4 Resource Type Counts

| Resource Type | Count |
|---------------|-------|
| Condition | 13,632 |
| Patient | 11,000 |
| Encounter | 1,721 |
| Procedure | 1,248 |

### Top 20 Conditions (FHIR, by ICD-10 code)

| ICD-10 Code | Occurrences |
|-------------|-------------|
| F32.1 (Moderate depressive episode) | 3,546 |
| E11.9 (Type 2 diabetes, unspecified) | 1,096 |
| I50.9 (Heart failure, unspecified) | 1,030 |
| J44.1 (COPD with acute exacerbation) | 752 |
| N18.3 (CKD stage 3) | 530 |
| I48 (Atrial fibrillation/flutter) | 503 |
| I10 (Essential hypertension) | 386 |
| K21.0 (GORD with oesophagitis) | 343 |
| K57.3 (Diverticular disease) | 337 |
| I25.9 (Chronic ischaemic heart disease) | 305 |
| E05.9 (Thyrotoxicosis, unspecified) | 296 |
| G43.9 (Migraine, unspecified) | 269 |
| G40.9 (Epilepsy, unspecified) | 261 |
| E78.5 (Dyslipidaemia, unspecified) | 242 |
| J45.9 (Asthma, unspecified) | 213 |
| M15.0 (Primary generalised osteoarthritis) | 211 |
| O80 (Single spontaneous delivery) | 210 |
| M05.9 (Rheumatoid arthritis, unspecified) | 170 |
| E66.9 (Obesity, unspecified) | 159 |
| K80.1 (Gallstones with cholecystitis) | 158 |

### Top Patients by Encounter Count (USA)

| Name | Gender | Encounters | Conditions |
|------|--------|------------|------------|
| Erica Todd | unknown | 4 | 6 |
| Kimberly Howell | unknown | 4 | 9 |
| Rebecca Edwards | unknown | 4 | 5 |
| Anita Durham | unknown | 4 | 6 |
| Patrick Payne | unknown | 4 | 8 |
| Julia Page | unknown | 4 | 20 |
| Lisa Sanchez | unknown | 4 | 6 |
| Melissa Elliott | unknown | 4 | 18 |
| Melissa Meadows | unknown | 4 | 6 |

### Data Date Range (FHIR)

- Earliest: 2026-03-21 00:03:08 UTC
- Latest: 2026-03-21 00:33:31 UTC

---

## Cross-Database Summary

| Metric | NHS | USA |
|--------|-----|-----|
| Total records (all tables) | 337,283 | 27,601 |
| Unique patients | ~3,000 | 11,000 |
| HL7v2 messages | 277,700 | 0 (pending) |
| FHIR R4 resources | 27,471 | 27,601 |
| SUS submissions | 32,112 | N/A |
| ECDS attendances | 0 (pending) | N/A |
| Data generated | 2026-03-21 | 2026-03-21 |
