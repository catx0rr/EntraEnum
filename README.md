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
Invoke-WebRequest -Uri https://raw.githubusercontent.com/catx0rr/EntraEnum/refs/heads/master/Get-UserRealm.ps1 -OutFile 
.\Get-UserRealm.ps1
Invoke-WebRequest -Uri https://raw.githubusercontent.com/catx0rr/EntraEnum/refs/heads/master/Get-EntraTenantInfo.ps1 -OutFile .\Get-EntraTenantInfo.ps1
Import-Module Get-UserRealm.ps1
Import-Module Get-EntraTenantInfo.ps1
```

Examples:
```
Get-Help Invoke-GetUserRealm
Invoke-GetUserRealm -Domain domain.com
Invoke-GetUserRealm -Domain domain.com -WebRequest
Invoke-GetUserRealm -Domain domain.com -WebRequest -URLs
```
```
Get-Help Invoke-GetEntraTenantInfo
Invoke-GetTenantInfo -Domain domain.com
Invoke-GetTenantInfo -Domain domain.com -WebRequest
Invoke-GetTenantInfo -Domain -WebRequest -Id
```
