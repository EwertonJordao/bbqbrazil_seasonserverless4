using namespace System.Net
param($Request, $TriggerMetadata)

$contentBody = $Request.RawBody | ConvertFrom-Json
$nameNotePropertie = ($contentBody | get-member -Name Name -MemberType NoteProperty).Name
$qtdPeopleNotePropertie =  ($contentBody | get-member -Name QtdPeople -MemberType NoteProperty).Name

if (($null -ne $Request.headers.bugget) -and ($null -ne $Request.RawBody) -and ($nameNotePropertie -match "Name") -and  ($qtdPeopleNotePropertie -match "QtdPeople") ) {
    Write-Host "Init Process"
    $event = New-Object Event
    $event.Familys = $contentBody
    $event.bugget = $Request.headers.bugget
    [int]$totalPeople = ($event.Familys.QtdPeople | Measure-Object -Sum | select Sum).Sum
    $perPeople = [math]::Round($event.CostPerPeople($totalPeople), 2)
    $WholeFamily = $event.WholeFamily($perPeople)
    Write-Host "PowerShell HTTP trigger function processed a request."
    $body = ([PSCustomObject]@{
            ListFamilyName = $event.Familys.Name
            QtdPeople      = $totalPeople
            CostPerFamily  = $WholeFamily
            CostPerPeople  = $perPeople
            AVG            = [Math]::Round($($WholeFamily | Measure-Object -Average).Average)
        } | ConvertTo-Json -Depth 6 -EscapeHandling Default )
    Write-Host "Create Response"
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
            StatusCode     = [HttpStatusCode]::OK
            Body           = $body
        })
    Write-Host "Response send"
}
else {
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
            StatusCode = [HttpStatusCode]::BadRequest
            Body       = $body
        })
}

