# vin-validator

This [VIN](https://en.wikipedia.org/wiki/Vehicle_identification_number) Validator accepts a VIN as a parameter and attempts to check if the calculated check digit matches the input. If it does, it says 'This looks like a VALID vin!', and if it doesn't, it returns some possible valid VINs.

## Usage

To validate a VIN using this script, you must run:

`ruby main.rb <VIN>`

For example:

`ruby main.rb 3HSDJAPRSFN657165`

### Successful Response

```
Provided VIN: <VIN>
Check Digit: VALID
This looks like a VALID vin!
```

### Error Response

```
Provided VIN: <VIN>
Check Digit: VALID || INVALID
Suggested VIN(s):
  - NEW_VIN
  - NEW_VIN
```

## Bonus

> Are you able to provide any suggested attributes based upon the decoding of the VIN given your newfound knowledge of this identifier?

Yes, we could provide the vehicle's World manufacturer identifier by the three first chacacters, like `General Motors South Africa` when the first three characters are `ADM`. We could also provide the model year of the vehicle.

There is some informations about the vehicle on the VIN, the problem is that there are many standards for calculate the VIN.

> If we wanted to replicate or enhance behavior in our GET /vins/:vin endpoint in Global Assets how might this script help us? Do you see
any opportunities in the API contract to allow this when a consumer receives an HTTP 400 - Bad Request response.

This script could help by returning the possible VINs on the request. The API could return an array of possible valid VINs based on the received VIN.

We could add a `data` field on the response in order to add this information, and we wouldn't violate the API contract because the behaviour would still be the same and the client wouldn't need a change if it doesn't want to use this information.


HTTP 400 - Bad Request response:
```
{
  "title": "Invalid format",
  ...,
  "data": {
    "suggested_vins": ["<vin_1>", "<vin_2>", ..., "<vin_n>"]
  }
  ...
}
```
