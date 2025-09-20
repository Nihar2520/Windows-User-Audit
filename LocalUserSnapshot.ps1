# LocalUserSnapshot.ps1
# Run normally to take snapshot. When run as Admin it can read group membership fully.
$OutDir = Join-Path $env:USERPROFILE "Documents\UserAudit\snapshots\local"
if (-not (Test-Path -Path $OutDir)) { New-Item -Path $OutDir -ItemType Directory -Force | Out-Null }

$timestamp = (Get-Date).ToUniversalTime().ToString("yyyyMMddTHHmmssZ")
$snapFile = Join-Path $OutDir "local_snapshot_$timestamp.json"

function Get-LocalUsersSafe {
    try { Get-LocalUser -ErrorAction Stop | Select-Object Name,Enabled,Description,LastLogon } 
    catch { 
        # fallback for older systems or insufficient rights: parse 'net user'
        $lines = (net user) -split "`r?`n"
        $start = ($lines | Select-String -Pattern "^-+$" -AllMatches | Select-Object -Last 1).LineNumber
        $users = @()
        if ($start) {
            $raw = $lines[$start..($lines.Length-1)] -join " "
            $raw -split '\s{2,}' | ForEach-Object { if ($_ -and $_ -ne "User accounts") { $users += $_.Trim() } }
            $users | ForEach-Object { [PSCustomObject]@{ Name = $_; Enabled = $null; Description = $null; LastLogon = $null } }
        } else { @() }
    }
}

$users = Get-LocalUsersSafe
$groups = Get-LocalGroup | ForEach-Object {
    $members = @()
    try { $members = (Get-LocalGroupMember -Group $_.Name -ErrorAction Stop | Select-Object -ExpandProperty Name) } catch {}
    [PSCustomObject]@{ Name = $_.Name; Members = $members }
}

$data = [PSCustomObject]@{
    timestamp = (Get-Date).ToUniversalTime().ToString("o")
    users = $users
    groups = $groups
}

$data | ConvertTo-Json -Depth 10 | Out-File -FilePath $snapFile -Encoding utf8
Write-Host "Saved snapshot to: $snapFile"
