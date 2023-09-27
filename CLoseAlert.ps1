$uriBase = 'http://localhost/OperationsManager'
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
# specific REST API call starts here
$request = @{
comment = "test comment";
resolutionState = 255;
alertIds = @(
"873a4947-8fb3-4ba5-a873-d494693a70a4"
)
}
$jsonbody = $request | ConvertTo-Json
$response = Invoke-WebRequest -Uri "$uriBase/data/alertResolutionStates" -Headers $scomHeaders -Method Post -Body $jsonbody -ContentType "application/json" -UseDefaultCredentials -WebSession $websession
$response = ConvertFrom-Json -InputObject $response.Content
$response 
