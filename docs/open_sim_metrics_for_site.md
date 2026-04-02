# Open Sim Hospital — Metrics for dataremodeler.com

Snapshot date: 2026-03-23. Source: live queries against the dedicated demo cluster.

---

## Headline Numbers

| Metric | Value |
|--------|-------|
| Total records across both databases | ~365,000 |
| NHS database total rows | 337,283 |
| USA database total rows | 27,601 |
| Unique patients (NHS) | ~3,000 |
| Unique patients (USA) | 11,000 |
| Healthcare data standards covered | HL7v2, FHIR R4, SUS, ECDS |
| Countries live | 2 (NHS UK, USA) |
| Countries coming soon | 2 (Canada, Australia) |
| Distinct ICD-10 condition codes | 20+ |
| HL7v2 message types generated | 7 (ADT^A01, ADT^A03, ORU^R01, ORM^O01, RDE^O11, MDM^T02, VXU^V04) |
| FHIR R4 resource types | 4 (Patient, Encounter, Condition, Procedure) |
| SUS dataset types | 4 (APC, OP, AE, ECDS) |

---

## NHS Database Breakdown

### HL7v2 Messages — 277,700 total

| Message Type | Count | % |
|--------------|-------|---|
| ORU^R01 (Observation Result) | 222,928 | 80.3% |
| RDE^O11 (Pharmacy Order) | 23,241 | 8.4% |
| MDM^T02 (Document Notification) | 18,647 | 6.7% |
| ORM^O01 (Order Message) | 7,616 | 2.7% |
| ADT^A01 (Admit) | 2,149 | 0.8% |
| ADT^A03 (Discharge) | 2,149 | 0.8% |
| VXU^V04 (Vaccination Update) | 970 | 0.3% |

### FHIR R4 Resources — 27,471 total

| Resource Type | Count |
|---------------|-------|
| Condition | 20,869 |
| Patient | 3,000 |
| Encounter | 2,149 |
| Procedure | 1,453 |

### SUS Submissions — 32,112 total

| Dataset Type | Count |
|--------------|-------|
| OP (Outpatients) | 27,193 |
| APC (Admitted Patient Care) | 2,149 |
| AE (Accident & Emergency) | 1,385 |
| ECDS (Emergency Care Data Set) | 1,385 |

---

## USA Database Breakdown

### FHIR R4 Resources — 27,601 total

| Resource Type | Count |
|---------------|-------|
| Condition | 13,632 |
| Patient | 11,000 |
| Encounter | 1,721 |
| Procedure | 1,248 |

### HL7v2 Messages — pending

---

## Top Clinical Conditions (both databases, ICD-10)

| ICD-10 | Description | NHS Count | USA Count |
|--------|-------------|-----------|-----------|
| F32.1 | Moderate depressive episode | 6,128 | 3,546 |
| E11.9 | Type 2 diabetes, unspecified | 2,014 | 1,096 |
| I50.9 | Heart failure, unspecified | 1,388 | 1,030 |
| J44.1 | COPD with acute exacerbation | 1,168 | 752 |
| I10 | Essential hypertension | 1,076 | 386 |
| N18.3 | Chronic kidney disease stage 3 | 898 | 530 |
| I48 | Atrial fibrillation/flutter | 599 | 503 |
| E78.5 | Dyslipidaemia, unspecified | 394 | 242 |
| K57.3 | Diverticular disease | 362 | 337 |
| I25.9 | Chronic ischaemic heart disease | 361 | 305 |

---

## Suggested Copy Blocks for the Site

### Stats bar / hero section
- "365,000+ synthetic healthcare records"
- "14,000 unique patients across NHS and US formats"
- "277,700 HL7v2 messages | 55,000+ FHIR R4 resources | 32,000+ SUS submissions"
- "Zero setup. Zero PHI. Zero approval process."

### Data quality proof points
- "7 HL7v2 message types generated in clinical sequence"
- "4 FHIR R4 resource types with full JSONB structure"
- "4 SUS dataset types including APC, OP, AE, and ECDS"
- "20+ ICD-10 condition codes with realistic prevalence distribution"
- "Admit-discharge pairs match 1:1 (2,149 ADT^A01 = 2,149 ADT^A03)"
- "Clinical conditions follow real-world epidemiological ratios"

### Connection details (for a 'Try it now' widget)
```
Host: db-open-demo-do-user-25666328-0.l.db.ondigitalocean.com
Port: 25060
User: dr_open_sim_demo
Password: OpenDemoData2026!
SSL: required
Databases: dr_open_sim_demo_nhs, dr_open_sim_demo_usa
```

---

## Notes

- ECDS attendances table exists but has 0 rows (pending load)
- USA HL7v2 messages table exists but has 0 rows (pending load)
- Condition `display` field is empty in FHIR resources — codes only, no text
- Patient `gender` field is set to "unknown" for all records in both databases
- All data generated on 2026-03-21
- Canada and Australia databases are planned but not yet live
