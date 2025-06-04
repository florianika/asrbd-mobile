# ProcessOutputLogController API Documentation
## Authentication
All requests require a Bearer token in the Authorization header:
``` http
Authorization: Bearer <your-token>
```
## Endpoints
### 1. Resolve Process Output Log
``` http
PATCH /api/qms/outputlogs/resolve/{id}
```
**Parameters:**
- `id` (GUID, required): The ID of the process output log to resolve

**Example Response:**
``` json
{
    "processOutputLog": {
        "id": "550e8400-e29b-41d4-a716-446655440000",
        "message": "Process output log resolved successfully"
    }
}
```
**Error Response:**
``` json
{
    "code": "NOT_FOUND",
    "message": "Process output log not found"
}
```
### 2. Pend Process Output Log
``` http
PATCH /api/qms/outputlogs/pend/{id}
```
**Parameters:**
- `id` (GUID, required): The ID of the process output log to pend

**Example Response:**
``` json
{
    "processOutputLog": {
        "id": "550e8400-e29b-41d4-a716-446655440000",
        "message": "Process output log status updated to pending"
    }
}
```
### 3. Get Output Logs by Building ID
``` http
GET /api/qms/outputlogs/buildings/{id}
```
**Parameters:**
- `id` (GUID, required): The building ID

**Example Response:**
``` json
{
    "processOutputLogs": [
        {
            "id": "550e8400-e29b-41d4-a716-446655440001",
            "ruleId": 1234,
            "reference": "RULE_REF_001",
            "bldId": "550e8400-e29b-41d4-a716-446655440000",
            "entId": "550e8400-e29b-41d4-a716-446655440002",
            "dwlId": "550e8400-e29b-41d4-a716-446655440003",
            "entityType": "Building",
            "variable": "HeightCheck",
            "qualityAction": "Verify",
            "qualityStatus": "Pending",
            "qualityMessageAl": "Kontrolli i lartësisë",
            "qualityMessageEn": "Height check",
            "errorLevel": "Warning",
            "createdUser": "550e8400-e29b-41d4-a716-446655440004",
            "createdTimestamp": "2025-06-04T10:30:00Z"
        }
    ]
}
```
### 4. Get Output Logs by Building ID and Status
``` http
GET /api/qms/outputlogs/buildings/{id}/status/{status}
```
**Parameters:**
- `id` (GUID, required): The building ID
- `status` (QualityStatus enum, required): The quality status to filter by

**Example Response:**
``` json
{
    "processOutputLogs": [
        {
            "id": "550e8400-e29b-41d4-a716-446655440001",
            "ruleId": 1234,
            "reference": "RULE_REF_001",
            "bldId": "550e8400-e29b-41d4-a716-446655440000",
            "entId": null,
            "dwlId": null,
            "entityType": "Building",
            "variable": "HeightCheck",
            "qualityAction": "Verify",
            "qualityStatus": "Pending",
            "qualityMessageAl": "Kontrolli i lartësisë",
            "qualityMessageEn": "Height check",
            "errorLevel": "Warning",
            "createdUser": "550e8400-e29b-41d4-a716-446655440004",
            "createdTimestamp": "2025-06-04T10:30:00Z"
        }
    ]
}
```
The response structure remains similar for the other endpoints (Get Output Logs by Entrance ID and Get Output Logs by Dwelling ID), with the main difference being the filtering criteria.
## Notes
- All timestamps are in ISO 8601 format
- All IDs (except ruleId) are GUIDs represented as strings
- EntityType, QualityAction, QualityStatus, and ErrorLevel are enum values
- EntId and DwlId are nullable GUIDs
- Reference, Variable, QualityMessageAl, and QualityMessageEn are nullable strings
