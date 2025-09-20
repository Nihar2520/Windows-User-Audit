# diff_snapshots.ps1
param(
    [Parameter(Mandatory=$true)][string]$OldFile,
    [Parameter(Mandatory=$true)][string]$NewFile
)

function Read-Snap($f) { Get-Content $f -Raw | ConvertFrom-Json }

$old = Read-Snap $OldFile
$new = Read-Snap $NewFile

$oldUsers = @($old.users | ForEach-Object { $_.Name })
$newUsers = @($new.users | ForEach-Object { $_.Name })

$addedUsers = $newUsers | Where-Object { $_ -notin $oldUsers }
$removedUsers = $oldUsers | Where-Object { $_ -notin $newUsers }

Write-Host "=== Users ==="
if ($addedUsers) { "Added users:"; $addedUsers | ForEach-Object { " - $_" } } else { "Added users: none" }
if ($removedUsers) { "Removed users:"; $removedUsers | ForEach-Object { " - $_" } } else { "Removed users: none" }

# check Administrators group members (change group if you want)
$oldAdmin = @()
$newAdmin = @()
if ($old.groups) { $oldAdmin = @($old.groups | Where-Object { $_.Name -eq 'Administrators' } | Select-Object -ExpandProperty Members) }
if ($new.groups) { $newAdmin = @($new.groups | Where-Object { $_.Name -eq 'Administrators' } | Select-Object -ExpandProperty Members) }

$addedToAdmin = $newAdmin | Where-Object { $_ -notin $oldAdmin }
$removedFromAdmin = $oldAdmin | Where-Object { $_ -notin $newAdmin }

Write-Host "`n=== Administrators group ==="
if ($addedToAdmin) { "Added to Administrators:"; $addedToAdmin | ForEach-Object { " - $_" } } else { "Added to Administrators: none" }
if ($removedFromAdmin) { "Removed from Administrators:"; $removedFromAdmin | ForEach-Object { " - $_" } } else { "Removed from Administrators: none" }
