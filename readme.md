# SYNOPSIS

This script outputs a datetime object representing the furthest
IDP Metadata Certificate expiration date.

# DESCRIPTION

This script outputs a datetime object representing the furthest
IDP Metadata Certificate expiration date.

This script is useful for importing into monitoring systems
such as Solarwinds Orion(tm) to check when your IDP signing 
and encryption certificates are going to expire if you're
not using key autorotation for some reason.

# PARAMETERS

## encryption

This switch tells the script to evaluate the encryption
certificates. This usage is less common.

## signing

This switch tells the script to evaluate the signing
certificates. This usage is most common.

## MetadataURL

Specifies the IDP Metadata URL

# EXAMPLES

## EXAMPLE 1

C:\PS> .\samlcertchecker.ps1 -encryption -MetadataURL "https://adfs.contoso.com/FederationMetadata/2007-06/FederationMetadata.xml"
Monday, November 4, 2019 11:00:00

## EXAMPLE 2

C:\PS> .\samlcertchecker.ps1 -signing -MetadataURL "https://adfs.contoso.com/FederationMetadata/2007-06/FederationMetadata.xml"
Monday, November 4, 2019 11:10:00

# Input/Output

## INPUTS

None. You cannot pipe objects to samlcertchecker.ps1

## OUTPUTS

System.DateTime. Returns a DateTime Object for use in DateTime math operations.

# REFERENCES

https://www.oasis-open.org/standards#samlv2.0
