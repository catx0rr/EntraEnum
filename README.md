Usage:

via git clone:

```
git clone https://github.com.com/catx0rr/EntraEnum
cd EntraEnum
. .\Get-UserRealm.ps1
. .\Get-EntraTenantInfo.ps1
```

via Web-Request
```
Invoke-WebRequest -Uri https://raw.githubusercontent.com/catx0rr/EntraEnum/refs/heads/master/Get-UserRealm.ps1 -OutFile .\Get-UserRealm.ps1
```

```
Invoke-WebRequest -Uri https://raw.githubusercontent.com/catx0rr/EntraEnum/refs/heads/master/Get-EntraTenantInfo.ps1 -OutFile .\Get-EntraTenantInfo.ps1
```
```
Import-Module Get-UserRealm.ps1
Import-Module Get-EntraTenantInfo.ps1
```

Examples:
```
Get-Help Invoke-GetUserRealm
Invoke-GetUserRealm -Domain megabigtech.com
Invoke-GetUserRealm -Domain megabigtech.com -WebRequest
Invoke-GetUserRealm -Domain megabigtech.com -WebRequest -IsFederated
Invoke-GetUserRealm -Domain megabigtech.com -WebRequest -URLs
```
```
Get-Help Invoke-GetEntraTenantInfo
Invoke-GetTenantInfo -Domain megabigtech.com
Invoke-GetTenantInfo -Domain megabigtech.com -WebRequest
Invoke-GetTenantInfo -Domain megabigtech.com -WebRequest -Id
```
