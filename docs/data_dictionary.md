# Data Dictionary

Column-by-column descriptions of every table in the Open Sim Hospital demo databases.

---

## NHS Database — `dr_open_sim_demo_nhs`

### `hl7v2.messages`

| Column | Type | Description |
|--------|------|-------------|
| `message_id` | UUID | Unique identifier for the message |
| `message_type` | VARCHAR | HL7v2 message type code (see [Message Types](#hl7v2-message-types) below) |
| `patient_id` | UUID | Reference to the patient this message relates to |
| `content` | TEXT | Full HL7v2 message content, pipe-delimited segments (MSH, PID, PV1, etc.) |
| `created_at` | TIMESTAMP | When the message was generated |

### `fhir_r4.resources`

| Column | Type | Description |
|--------|------|-------------|
| `resource_id` | UUID | Unique identifier for this row |
| `resource_type` | VARCHAR | FHIR resource type (see [FHIR Resource Types](#fhir-r4-resource-types) below) |
| `fhir_id` | VARCHAR | The FHIR resource's logical ID (as it would appear in a FHIR server) |
| `patient_id` | UUID | Reference to the patient this resource relates to |
| `content` | JSONB | Full FHIR R4 resource as JSON — query with PostgreSQL JSONB operators |
| `created_at` | TIMESTAMP | When the resource was generated |

### `sus.submissions`

| Column | Type | Description |
|--------|------|-------------|
| `submission_id` | UUID | Unique identifier for the submission record |
| `dataset_type` | VARCHAR | SUS dataset type (see [SUS Dataset Types](#sus-dataset-types) below) |
| `patient_id` | UUID | Reference to the patient |
| `content` | TEXT | Full SUS submission content in the relevant CDS format |
| `created_at` | TIMESTAMP | When the submission was generated |

### `ecds.attendances`

| Column | Type | Description |
|--------|------|-------------|
| `attendance_id` | UUID | Unique identifier for the attendance record |
| `patient_id` | UUID | Reference to the patient |
| `content` | TEXT | Full ECDS attendance record |
| `created_at` | TIMESTAMP | When the attendance was generated |

---

## USA Database — `dr_open_sim_demo_usa`

### `fhir_r4.resources`

Same structure as the NHS `fhir_r4.resources` table (see above). Resources follow US coding conventions (ICD-10-CM, CPT, LOINC).

### `hl7v2.messages`

Same structure as the NHS `hl7v2.messages` table (see above). Messages follow US HL7v2 conventions and coding systems.

### `tuva_core` *(coming soon)*

Relational tables following the [Tuva Health](https://thetuvaproject.com/) core data model. This schema will contain analytics-ready tables including patient, encounter, condition, procedure, medication, and observation tables in a normalised relational format.

---

## HL7v2 Message Types

HL7v2 (Health Level Seven version 2) is a pipe-delimited messaging standard used for exchanging clinical data between hospital systems.

| Message Type | Name | Description |
|--------------|------|-------------|
| `ADT^A01` | Admit/Visit Notification | Patient has been admitted to the hospital |
| `ADT^A02` | Transfer | Patient transferred between departments |
| `ADT^A03` | Discharge | Patient discharged from the hospital |
| `ADT^A04` | Register | Patient registered (outpatient or emergency) |
| `ADT^A08` | Update Patient Information | Demographics or visit details updated |
| `ORU^R01` | Observation Result | Lab results, vital signs, or other observations |
| `ORM^O01` | Order Message | New order placed (lab, radiology, medication) |
| `RDE^O11` | Pharmacy/Treatment Encoded Order | Medication prescription or administration |
| `SIU^S12` | Schedule Information | Appointment scheduling notification |
| `MDM^T02` | Document Notification | Clinical document (note, report) created or updated |

Each message is composed of segments separated by carriage returns. Key segments include:

- **MSH** — Message header (message type, sending/receiving systems, timestamp)
- **PID** — Patient identification (name, DOB, identifiers)
- **PV1** — Patient visit (admission type, location, attending physician)
- **OBX** — Observation/result (individual test results, vital signs)
- **OBR** — Observation request (order details)
- **DG1** — Diagnosis (ICD-10 codes)

---

## FHIR R4 Resource Types

FHIR (Fast Healthcare Interoperability Resources) R4 is a JSON-based standard for healthcare data exchange. Resources are stored as JSONB in the `content` column.

| Resource Type | Description | Key Fields in `content` |
|---------------|-------------|------------------------|
| `Patient` | Patient demographics | `name`, `birthDate`, `gender`, `identifier`, `address`, `telecom` |
| `Encounter` | A visit or admission | `status`, `class`, `type`, `period`, `participant`, `reasonCode` |
| `Condition` | Diagnosis or problem | `code` (ICD-10/SNOMED), `clinicalStatus`, `onsetDateTime`, `category` |
| `Observation` | Lab result or vital sign | `code` (LOINC), `valueQuantity`, `effectiveDateTime`, `status` |
| `Procedure` | Clinical procedure performed | `code` (CPT/SNOMED), `performedDateTime`, `status`, `category` |
| `MedicationRequest` | Medication prescription | `medicationCodeableConcept`, `dosageInstruction`, `status`, `authoredOn` |
| `DiagnosticReport` | Grouped lab results | `code`, `result` (references to Observations), `effectiveDateTime` |
| `AllergyIntolerance` | Allergy or adverse reaction | `code`, `clinicalStatus`, `type`, `category`, `criticality` |
| `Immunization` | Vaccination record | `vaccineCode`, `occurrenceDateTime`, `status`, `doseQuantity` |

### Querying FHIR JSONB

PostgreSQL JSONB operators for navigating FHIR resources:

```sql
-- Access a top-level field
content->>'birthDate'

-- Access nested objects
content->'name'->0->>'family'

-- Access arrays
content->'name'->0->'given'->>0

-- Extract coding from CodeableConcept
content->'code'->'coding'->0->>'code'

-- Iterate over array elements
jsonb_array_elements(content->'code'->'coding')

-- Pretty-print for inspection
jsonb_pretty(content)
```

---

## SUS Dataset Types

The Secondary Uses Service (SUS) is the NHS England mechanism for collecting hospital activity data for commissioning, planning, and research.

| Dataset Type | Name | Description |
|--------------|------|-------------|
| `APC` | Admitted Patient Care | Inpatient and day case hospital admissions. Includes HRG (Healthcare Resource Group) codes, diagnosis codes (ICD-10), procedure codes (OPCS-4), length of stay, and admission/discharge details. |
| `OP` | Outpatients | Outpatient clinic attendances. Includes appointment details, specialty, referral source, and attendance outcome. |
| `AE` | Accident & Emergency | Legacy A&E attendance records. Includes arrival mode, chief complaint, investigations, treatments, and disposal method. Being replaced by ECDS. |
| `ECDS` | Emergency Care Data Set | Modern replacement for AE data. Richer clinical detail including SNOMED CT coded diagnoses, acuity scores, and investigations. |

### Key NHS Coding Systems

| System | Used In | Description |
|--------|---------|-------------|
| ICD-10 | APC, ECDS | International Classification of Diseases — diagnosis codes |
| OPCS-4 | APC | Classification of Interventions and Procedures — surgical/procedure codes |
| HRG | APC | Healthcare Resource Groups — casemix classification for payment |
| SNOMED CT | ECDS | Systematized Nomenclature of Medicine — detailed clinical terminology |
| NHS Number | All | 10-digit unique patient identifier used across NHS England |

---

## ECDS Attendances

The `ecds.attendances` table contains Emergency Care Data Set records — the modern standard for recording emergency department activity in NHS England.

Each attendance record captures:
- Patient arrival and departure details
- Acuity and initial assessment
- SNOMED CT coded diagnoses and investigations
- Treatment and discharge information
- Safeguarding indicators

The `content` field contains the full attendance record. Key data elements within the content include injury date, chief complaint (SNOMED CT), diagnosis codes (SNOMED CT), investigations performed, treatments given, and discharge status/destination.
