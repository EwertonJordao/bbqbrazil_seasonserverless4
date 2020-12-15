# bbqbrazil_seasonserverless4

Sample Data

```powershell

$body =((@{Name = "Jordao"; QtdPeople = 5 }, @{Name = "Sanchez"; QtdPeople = 6 }) | ConvertTo-Json)

Invoke-RestMethod -Uri  http://localhost:7071/api/bbqBrazil `
    -Body  $body `
    -ContentType "application/json" `
    -headers @{budget = 1500 } `
    -Method Get

```
