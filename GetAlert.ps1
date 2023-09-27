<#
.Method 1
#>

Invoke-RestMethod -Uri 'http://localhost:1234/Api/Alerts' -UseDefaultCredentials


<#
.Method 2
#>

# Set the Header and the Body
$SCOMHeaders = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$SCOMHeaders.Add('Content-Type', 'application/json; charset=utf-8')
$BodyRaw = "Windows"
$Bytes = [System.Text.Encoding]::UTF8.GetBytes($BodyRaw)
$EncodedText = [Convert]::ToBase64String($Bytes)
$JSONBody = $EncodedText | ConvertTo-Json

# The SCOM REST API authentication URL
$URIBase = 'http://localhost/OperationsManager/authenticate'

# Initiate the Cross-Site Request Forgery (CSRF) token, this is to prevent CSRF attacks
$CSRFtoken = $WebSession.Cookies.GetCookies($UriBase) | ? { $_.Name -eq 'SCOM-CSRF-TOKEN' }
$SCOMHeaders.Add('SCOM-CSRF-TOKEN', [System.Web.HttpUtility]::UrlDecode($CSRFtoken.Value))

# Authentication
$Authentication = Invoke-RestMethod -Method Post -Uri $uriBase -Headers $SCOMHeaders -body $JSONBody -UseDefaultCredentials -SessionVariable WebSession

# The query which contains the criteria for our alerts
$Query = @(@{ "classId" = ""

# Get all alerts with severity '2' (critical) and resolutionstate '0' (new)
"criteria" = "((Severity = '2') AND (ResolutionState = '0'))"

"displayColumns" =
"id",
    "severity",
    "monitoringobjectdisplayname",
    "monitoringobjectpath",
    "name",
    "age",
    "description",
    "owner",
    "timeadded" })

# Convert our query to JSON format

$JSONQuery = $Query | ConvertTo-Json

$Response = Invoke-RestMethod -Uri 'http://localhost/OperationsManager/data/alert' -Method POST -Body $JSONQuery -WebSession $WebSession

# Print out the alert results

$Alerts = $Response.Rows
$Alerts | Select name,Id,severity,monitoringobjectdisplayname,monitoringobjectpath,age,description,owner, timeadded
