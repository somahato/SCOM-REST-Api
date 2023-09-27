# getting class information
$uriBase = 'http://localhost/OperationsManager'
$classId = "ea99500d-8d52-fc52-b5a5-10dcd1e9d2bd"
$scomHeaders = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$scomHeaders.Add('Content-Type','application/json; charset=utf-8')
$bodyraw = "Windows"
$Bytes = [System.Text.Encoding]::UTF8.GetBytes($bodyraw)
$EncodedText = [Convert]::ToBase64String($Bytes)
$jsonbody = $EncodedText | ConvertTo-Json
$auth = Invoke-RestMethod -Method POST -Uri "$uriBase/authenticate" -Headers $scomHeaders -body $jsonbody -UseDefaultCredentials -SessionVariable websession
$csrfTocken = $websession.Cookies.GetCookies($uriBase) | ? { $_.Name -eq 'SCOM-CSRF-TOKEN' }
$scomHeaders.Add('SCOM-CSRF-TOKEN', [System.Web.HttpUtility]::UrlDecode($csrfTocken.Value))
$response = Invoke-WebRequest -Uri "$uriBase/data/classInformation/$classId" -Headers $scomHeaders -Method Get -ContentType "application/json" -UseDefaultCredentials -WebSession $websession
$WindowsComputersClass = ConvertFrom-Json -InputObject $response.Content
$WindowsComputersClass.rows
