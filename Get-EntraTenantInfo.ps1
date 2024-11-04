function Invoke-GetTenantInfo {
    <#
    .SYNOPSIS
    Retrieves the OpenID configuration for a specified domain from Microsoft Online services.

    .DESCRIPTION
    The `Get-TenantOpenIDConfig` function constructs a URL to retrieve the OpenID configuration
    for the specified domain, which can be used for enumerating the Tenant ID.
    The function allows the user to either perform an HTTP GET request and display the result,
    or open the URL in a web browser (Brave Browser by default).

    .PARAMETER Domain
    The domain name to query the OpenID configuration for, such as "megabigtech.com".

    .PARAMETER WebRequest
    When specified, performs an HTTP GET request to retrieve the OpenID configuration for
    the given domain and outputs the result to the console.

    .PARAMETER WebBrowser
    When specified, opens the constructed URL in the Brave browser to view the OpenID configuration.

    .EXAMPLE
    Invoke-GetTenantInfo -Domain "megabigtech.com" -WebRequest

    Retrieves and displays the OpenID configuration for "megabigtech.com" via an HTTP GET request.

    .EXAMPLE
    Invoke-GetTenantInfo -Domain "megabigtech.com" -WebBrowser

    Opens the URL in Brave Browser to view the OpenID configuration for "megabigtech.com".

    .EXAMPLE
    Invoke-GetTenantInfo -Domain "megabigtech.com" -WebRequest -WebBrowser

    Retrieves the OpenID configuration for "megabigtech.com" and opens it in Brave Browser simultaneously.

    .NOTES
    Ensure Brave Browser is installed at "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe".
    If Brave is not available, it will default to Microsoft Edge as Browser.
    #>

    param (
        [Parameter(Mandatory=$true)]
        [string]$Domain,
        [switch]$WebRequest,
        [switch]$WebBrowser,
        [switch]$Id
    )

    if ($WebRequest -and $WebBrowser) {
        throw "The -WebRequest and -WebBrowser switches are mutually exclusive. Please use only one at a time."
    }

    if ($Id -and $WebBrowser) {
        throw "The -Id is querying using -WebRequest. Please use only one at a time."
    }

    if ($Id -and $WebRequest) {
        throw "The -Id is a clean output of -WebRequest to filter tenant Id. Please use only one at a time."
    }

    $banner = @"
 _______         __         _______                           __   _______         ___        
|     __|.-----.|  |_ _____|_     _|.-----.-----.---.-.-----.|  |_|_     _|.-----.'  _|.-----.
|    |  ||  -__||   _|______||   |  |  -__|     |  _  |     ||   _|_|   |_ |     |   _||  _  |
|_______||_____||____|       |___|  |_____|__|__|___._|__|__||____|_______||__|__|__|  |_____|
    catx0rr@github.com
"@

    $url = "https://login.microsoftonline.com/$Domain/.well-known/openid-configuration"

    if ($Id) {
       try {
            $response = Invoke-WebRequest -Uri $url -UseBasicParsing

            $jsonContent = $response.Content | ConvertFrom-Json
            $tokenEndpoint = $jsonContent.token_endpoint
            $tenantId = ($tokenEndpoint -split '/')[3]
            Write-Output $banner
            Start-Sleep 2
            Write-Output "`nTenant ID for $Domain`: $tenantId"
       } catch {
            Write-Output "Failed to invoke web request or parse JSON: $_"
       }
    }

    if ($WebRequest) {
        try {
            $response = Invoke-WebRequest -Uri $url -UseBasicParsing
            
            $jsonContent = $response.Content | ConvertFrom-Json | ConvertTo-Json -Depth 10 -Compress:$false
            Write-Output $banner
            Start-Sleep 2
            Write-Output "`n$jsonContent"


        } catch {
            Write-Output "Failed to invoke web request: $_"
        }
    }

    if ($WebBrowser) {
        $bravePath = "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe"
        $edgePath = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"

        if (Test-Path $bravePath) {
            Start-Process $bravePath -ArgumentList $url
        }
        elseif (Test-Path $edgePath) {
            Start-Process $edgePath -ArgumentList $url
        }
        else {
            Write-Output "Neither Brave nor Edge is installed in the default locations."
        }
    }
}
