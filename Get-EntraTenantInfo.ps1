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
    Invoke-GetTenantInfo -Domain "megabigtech.com" -Id

    Retrieves and displays the TenantID for "megabigtech.com" via an HTTP GET request.

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

    if ($Id -and -not $WebRequest) {
        throw "The -Id switch must be used with the -WebRequest switch."
    }

    if ($WebRequest -and $WebBrowser) {
        throw "The -WebRequest and -WebBrowser switches are mutually exclusive. Please use only one at a time."
    }

    $banner = @"
 _______         __         _______                           __   _______         ___        
|     __|.-----.|  |_ _____|_     _|.-----.-----.---.-.-----.|  |_|_     _|.-----.'  _|.-----.
|    |  ||  -__||   _|______||   |  |  -__|     |  _  |     ||   _|_|   |_ |     |   _||  _  |
|_______||_____||____|       |___|  |_____|__|__|___._|__|__||____|_______||__|__|__|  |_____|
    catx0rr@github.com
"@

    $url = "https://login.microsoftonline.com/$Domain/.well-known/openid-configuration"
    $bravePath = "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe"
    $edgePath = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"

    if ($WebRequest) {
        try {
            $response = Invoke-WebRequest -Uri $url -UseBasicParsing

            if ($Id) {
                $jsonContent = $response.Content | ConvertFrom-Json
                $tokenEndpoint = $jsonContent.token_endpoint
                $tenantId = ($tokenEndpoint -split '/')[3]
                Write-Output $banner
                Start-Sleep 2
                Write-Output "`nTenant ID for $Domain`: $tenantId"
            } else {

                $jsonContent = $response.Content | ConvertFrom-Json | ConvertTo-Json -Depth 10 -Compress:$false
                Write-Output $banner
                Start-Sleep 2
                Write-Output "`n$jsonContent"
            }


        } catch {
            Write-Output "Failed to invoke web request: $_"
        }
    }
    # If -WebBrowser is specified, open the URL in Brave or Edge 
    elseif ($WebBrowser) {
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
    # Default to browser if none selected
    else {
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
