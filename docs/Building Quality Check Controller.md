# Building Quality Check Controller Documentation
## Overview
The Building Quality Check controller manages quality control operations for buildings through a REST API interface. Base route: `api/qms/check`.
## Authentication
All endpoints require authentication via Bearer token in the Authorization header.
## Endpoints
### Execute Building Quality Check
Triggers quality validation rules for specified buildings.
**POST** `/api/qms/check/buildings`
#### Request Body
``` json
{
  "buildingIds": ["guid1", "guid2", "..."],
  "executionUser": "guid"  // Auto-populated from token
}
```
#### Responses
- **Success**
``` json
{
  "message": "Rules were executed"
}
```
- **Error**
``` json
{
  "message": "There was an error",
  "code": "ErrorTypeName"  // Optional
}
```
### Execute Automatic Rules
Runs automated quality validation rules for specified buildings.
**POST** `/api/qms/check/automatic`
#### Request Body
``` json
{
  "buildingIds": ["guid1", "guid2", "..."],
  "executionUser": "guid"  // Auto-populated from token
}
```
#### Response
Returns an `AutomaticRulesResponse` object
## Technical Details
- Requires authentication via `[Authorize]` attribute
- Extends `QmsControllerBase` for common functionality
- Dependencies:
    - `IAuthTokenService`
    - `BuildingQualityCheck`
    - `AutomaticRules`

- User identification is automatically handled via bearer token extraction

The key difference between the two endpoints is that:
- `/buildings` executes standard quality validation rules
- `/automatic` executes automated quality validation rules Both require a list of building IDs to process.
