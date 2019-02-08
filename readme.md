# SAMLCERTCHECKER


## Overview

This script outputs a datetime object representing the furthest
IDP Metadata Certificate expiration date.

This script is useful for importing into monitoring systems
such as Solarwinds Orion(tm) to check when your IDP signing 
and encryption certificates are going to expire if you're
not using key autorotation for some reason.

## Parameters

### encryption

This switch tells the script to evaluate the encryption
certificates. This usage is less common.

### signing

This switch tells the script to evaluate the signing
certificates. This usage is most common.

### MetadataURL

Specifies the IDP Metadata URL

## Examples

### Example 1

C:\PS> .\samlcertchecker.ps1 -encryption -MetadataURL "https://adfs.contoso.com/FederationMetadata/2007-06/FederationMetadata.xml"
Monday, November 4, 2019 11:00:00

### Example 2

C:\PS> .\samlcertchecker.ps1 -signing -MetadataURL "https://adfs.contoso.com/FederationMetadata/2007-06/FederationMetadata.xml"
Monday, November 4, 2019 11:10:00

## Input/Output

### Inputs

None. You cannot pipe objects to samlcertchecker.ps1

### Outputs

System.DateTime. Returns a DateTime Object for use in DateTime math operations.

## References

<https://www.oasis-open.org/standards#samlv2.0>
