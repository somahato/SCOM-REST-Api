<#
.Method 1
#>

$Objss = Invoke-RestMethod -Uri 'http://localhost:1234/API/Computer/windows' -UseDefaultCredentials
#$Objss | gm

$objs = $Objss.displayname
Foreach ($obj in $objs)
{

# getting object information
Write-Host "Working on $obj" -ForegroundColor Yellow
$uriBase = 'http://localhost/OperationsManager'
$criteria = "DisplayName LIKE '%$obj%'"
$scomHeaders = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$scomHeaders.Add('Content-Type','application/json; charset=utf-8')
$bodyraw = "Windows"
$Bytes = [System.Text.Encoding]::UTF8.GetBytes($bodyraw)
$EncodedText = [Convert]::ToBase64String($Bytes)
$jsonbody = $EncodedText | ConvertTo-Json
$auth = Invoke-RestMethod -Method POST -Uri "$uriBase/authenticate" -Headers $scomHeaders -body $jsonbody -UseDefaultCredentials -SessionVariable websession
$jsonbody = $criteria | ConvertTo-Json
$csrfToken = $websession.Cookies.GetCookies($uriBase) | ? { $_.Name -eq 'SCOM-CSRF-TOKEN' }
$scomHeaders.Add('SCOM-CSRF-TOKEN', [System.Web.HttpUtility]::UrlDecode($csrfToken.Value))
$response = Invoke-WebRequest -Uri "$uriBase/data/scomObjects" -Headers $scomHeaders -Method Post -Body $jsonbody -ContentType "application/json" -UseDefaultCredentials -WebSession $websession
$Object = ConvertFrom-Json -InputObject $response.Content
$Classes = $Object.scopeDatas.Classname
$Classes

}

<#
.Method 2
#>

$uriBase = 'http://localhost/OperationsManager'
$criteria = "DisplayName LIKE '%Sql%'"
$scomHeaders = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$scomHeaders.Add('Content-Type','application/json; charset=utf-8')
$bodyraw = "Windows"
$Bytes = [System.Text.Encoding]::UTF8.GetBytes($bodyraw)
$EncodedText = [Convert]::ToBase64String($Bytes)
$jsonbody = $EncodedText | ConvertTo-Json
$auth = Invoke-RestMethod -Method POST -Uri "$uriBase/authenticate" -Headers $scomHeaders -body $jsonbody -UseDefaultCredentials -SessionVariable websession
$jsonbody = $criteria | ConvertTo-Json
$csrfTocken = $websession.Cookies.GetCookies($uriBase) | ? { $_.Name -eq 'SCOM-CSRF-TOKEN' }
$scomHeaders.Add('SCOM-CSRF-TOKEN', [System.Web.HttpUtility]::UrlDecode($csrfTocken.Value))
$Response = Invoke-WebRequest -Uri "$uriBase/data/scomObjects" -Headers $scomHeaders -Method Post -Body $jsonbody -ContentType "application/json" -UseDefaultCredentials -WebSession $websession
$Object = ConvertFrom-Json -InputObject $Response.Content
$Object.scopeDatas | % { $_ } 
