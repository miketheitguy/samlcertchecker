<#
.SYNOPSIS

This script outputs a datetime object representing the furthest
IDP Metadata Certificate expiration date.

.DESCRIPTION

This script outputs a datetime object representing the furthest
IDP Metadata Certificate expiration date.

This script is useful for importing into monitoring systems
such as Solarwinds Orion(tm) to check when your IDP signing 
and encryption certificates are going to expire if you're
not using key autorotation for some reason.

.PARAMETER encryption

This switch tells the script to evaluate the encryption
certificates. This usage is less common.

.PARAMETER signing

This switch tells the script to evaluate the signing
certificates. This usage is most common.

.PARAMETER MetadataURL

Specifies the IDP Metadata URL

.EXAMPLE

C:\PS> .\samlcertchecker.ps1 -encryption -MetadataURL "https://adfs.contoso.com/FederationMetadata/2007-06/FederationMetadata.xml"
Monday, November 4, 2019 11:00:00

.EXAMPLE

C:\PS> .\samlcertchecker.ps1 -signing -MetadataURL "https://adfs.contoso.com/FederationMetadata/2007-06/FederationMetadata.xml"
Monday, November 4, 2019 11:10:00

.INPUTS

None. You cannot pipe objects to samlcertchecker.ps1

.OUTPUTS

System.DateTime. Returns a DateTime Object for use in DateTime math operations.

.LINK

https://www.oasis-open.org/standards#samlv2.0

#>


#Requires -Version 3
#Requires -Modules Microsoft.PowerShell.Utility


[CmdletBinding()]
param(
    [Parameter(Mandatory=$true,ParameterSetName = "encryption")]
    [switch]$encryption,
    [Parameter(Mandatory=$true,ParameterSetName = "signing")]
    [switch]$signing,
    [string]$metadataURL
)


Try {
    $MetaDataRequest = Invoke-WebRequest -UseBasicParsing -Uri $metadataURL -UserAgent "SAML Certificate Checker/1.0 PowerShell" -ErrorAction Stop
}
Catch {
    Write-Error $Error[0]
    break
}


if ($MetaDataRequest.StatusCode -eq 200) {
    [xml]$MetaDataXML = $MetaDataRequest.Content
}
else {
    write-error "Received HTTP Status Code: $($MetadataRequest.StatusCode)"
    break
}


# It is entirely possible to have multiple keys of the same type, even.
# This is why we build an array for each known type.
$encryptionCertArray = @()
$signingCertArray = @()

foreach ($keyDescriptor in $MetaDataXML.EntityDescriptor.IDPSSODescriptor.KeyDescriptor) {
    Switch ($keyDescriptor.Use) {
        "encryption" {
            if ($encryption) {
                $certificateBytes = [System.Convert]::FromBase64String($keyDescriptor.KeyInfo.X509Data.X509Certificate)
                $certificate = [System.Security.Cryptography.X509Certificates.X509Certificate2]($certificateBytes)
                $encryptionCertArray += $certificate
            }
        }
        "signing" {
            if ($signing) {
                $certificateBytes = [System.Convert]::FromBase64String($keyDescriptor.KeyInfo.X509Data.X509Certificate)
                $certificate = [System.Security.Cryptography.X509Certificates.X509Certificate2]($certificateBytes)
                $signingCertArray += $certificate
            }
        }
    }
}

# We only care about the newest certificate here, as the others will age out automatically.
# So we'll sort by descending and just grab the first certificate.
if ($encryption) {
    $encryptionCertArray = $encryptionCertArray | Sort-Object -Property NotAfter -Descending 
    $newestEncryptionCert = $encryptionCertArray[0]
    $newestEncryptionCert.NotAfter
}
elseif ($signing) {
    $signingCertArray = $signingCertArray | Sort-Object -Property NotAfter -Descending
    $newestSigningCert = $signingCertArray[0]
    $newestSigningCert.NotAfter
}
