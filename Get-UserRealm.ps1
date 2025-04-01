function Invoke-GetUserRealm {
<#
    .SYNOPSIS
    Retrieves user realm information for a specified domain from Microsoft Online services.

    .DESCRIPTION
    The `Get-UserRealm` function constructs a URL for Microsoft Online services to retrieve
    user realm information in XML format for the specified domain.
    The function provides options to either invoke a web request and display the result,
    or to open the URL in a web browser (Brave Browser by default).

    .PARAMETER Domain
    The domain name to query user realm information for, such as "megabigtech.com".

    .PARAMETER WebRequest
    When specified, performs an HTTP GET request to retrieve the user realm information for
    the given domain and outputs the result to the console.

    .PARAMETER WebBrowser
    When specified, opens the constructed URL in the Brave browser to view the user realm information.

    .EXAMPLE
    Invoke-GetUserRealm -Domain "megabigtech.com" -WebRequest

    Retrieves and displays user realm information for "megabigtech.com" via an HTTP GET request.

    .EXAMPLE
    Invoke-GetUserRealm -Domain "megabigtech.com" -WebBrowser

    Opens the URL in Brave Browser to view user realm information for "megabigtech.com".

    .EXAMPLE
    Invoke-GetUserRealm -Domain "megabigtech.com" -WebRequest -WebBrowser

    Retrieves the user realm information for "megabigtech.com" and opens it in Brave Browser simultaneously.

    .NOTES
    Ensure Brave Browser is installed at "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe".
    If Brave is not available, it will default to Microsoft Edge as Browser.

    .LINK
    https://docs.microsoft.com/en-us/powershell/
    #>

    param (
        [Parameter(Mandatory=$true)]
        [string]$Domain,
        [switch]$WebRequest,
        [switch]$WebBrowser,
        [switch]$URLs,
        [switch]$IsFederated
    )

    if ($URLs -and -not $WebRequest) {
        throw "The -URLs switch must be used with the -WebRequest switch."
    }

    if ($IsFederated -and -not $WebRequest) {
        throw "The -IsFederated switch must be used with the -WebRequest switch."
    }

    if ($WebRequest -and $WebBrowser) {
        throw "The -WebRequest and -WebBrowser switches are mutually exclusive. Please use only one at a time."
    }

    $banner = @"
 _______         __          _______                    ______               __           
|     __|.-----.|  |_ ______|   |   |.-----.-----.----.|   __ \.-----.---.-.|  |.--------.
|    |  ||  -__||   _|______|   |   ||__ --|  -__|   _||      <|  -__|  _  ||  ||        |
|_______||_____||____|      |_______||_____|_____|__|  |___|__||_____|___._||__||__|__|__|
    catx0rr@github.com
"@

    $url = "https://login.microsoftonline.com/getuserrealm.srf?login=$Domain&xml=1"
    $bravePath = "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe"
    $edgePath = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"

     $userAgents = @(
	    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36"
    	"Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"
    )

    $randomUserAgent = Get-Random -InputObject $userAgents

    $headers = @{
	    "User-Agent" = $randomUserAgent
    }

    if ($WebRequest) {
        try {
            $response = Invoke-WebRequest -Headers $headers -Uri $url -UseBasicParsing
            
            # Prettify the Response
            $xml = [xml]$response.Content

            $stringWriter = New-Object System.IO.StringWriter
            $xmlWriterSettings = New-Object System.Xml.XmlWriterSettings
            $xmlWriterSettings.Indent = $true
            $xmlWriterSettings.IndentChars = "  "
            $xmlWriter = [System.Xml.XmlWriter]::Create($stringWriter, $xmlWriterSettings)

            $xml.WriteTo($xmlWriter)
            $xmlWriter.Flush()
            $xmlWriter.Close()
            Write-Output $banner
            Start-Sleep 2

            if ($IsFederated -and $URLs) {
                 $isFederatedNode = $xml.SelectSingleNode("//IsFederatedNS")
              
                if ($isFederatedNode -ne $null) {
                    Write-Output $isFederatedNode.InnerText
                } else {
                    Write-Output "The IsFederatedNS tag was not found in the XML response."
                }

                $xml.SelectNodes("//*") | ForEach-Object {
                    if ($_.InnerText -match "https?://") {
                        Write-Output $_.InnerText | Select-String '^(https|http)' -CaseSensitive:$false
                    }
                }
            }

            elseif ($URLs) {
                $xml.SelectNodes("//*") | ForEach-Object {
                    if ($_.InnerText -match "https?://") {
                        Write-Output $_.InnerText | Select-String '^(https|http)' -CaseSensitive:$false
                    }
                }
            }
            
            elseif ($IsFederated) {
                $isFederatedNode = $xml.SelectSingleNode("//IsFederatedNS")
              
                if ($isFederatedNode -ne $null) {
                    Write-Output $isFederatedNode.InnerText
                } else {
                    Write-Output "The IsFederatedNS tag was not found in the XML response."
                }
            } 

            else {
                Write-Output $stringWriter.ToString()
            }

        } catch {
            Write-Output "Failed to Invoke web request on URI: $_"
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
    # Default to browser if none of selected
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
