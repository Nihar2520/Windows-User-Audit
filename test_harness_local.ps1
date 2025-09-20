# test_harness_local.ps1
$OutDir = Join-Path $env:USERPROFILE "Documents\UserAudit\snapshots\local"
if (-not (Test-Path -Path $OutDir)) { New-Item -Path $OutDir -ItemType Directory -Force | Out-Null }

$pre = Join-Path $OutDir "snap_pre.json"
$post = Join-Path $OutDir "snap_post.json"

# reuse snapshot function (lightweight)
function Save-SnapshotTo($file) {
    $users = try { Get-LocalUser | Select-Object Name,Enabled,Description,LastLogon } catch { @() }
    $groups = Get-LocalGroup | ForEach-Object {
        $members = @()
        try { $members = (Get-LocalGroupMember -Group $_.Name -ErrorAction Stop | Select-Object -ExpandProperty Name) } catch {}
        [PSCustomObject]@{ Name = $_.Name; Members = $members }
    }
    $data = [PSCustomObject]@{ timestamp = (Get-Date).ToUniversalTime().ToString("o"); users = $users; groups = $groups }
    $data | ConvertTo-Json -Depth 10 | Out-File -FilePath $file -Encoding utf8
    Write-Host "Saved $file"
}

Save-SnapshotTo $pre

$testName = "audit_test_user"
$testPass = ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force

try {
    if (-not (Get-LocalUser -Name $testName -ErrorAction SilentlyContinue)) {
        New-LocalUser -Name $testName -Password $testPass -FullName "Audit Test" -Description "Test account for audit"
        Write-Host "Created local user: $testName"
    } else { Write-Host "User already exists: $testName" }
    Add-LocalGroupMember -Group "Administrators" -Member $testName -ErrorAction SilentlyContinue
    Write-Host "Added $testName to Administrators"
} catch { Write-Warning "Create/Add failed: $_" }

Start-Sleep -Seconds 3
Save-SnapshotTo $post

# run diff
$diffScript = Join-Path (Split-Path -Parent $PSCommandPath) "diff_snapshots.ps1"
if (-not (Test-Path $diffScript)) {
    Write-Host "Diff script not found; running internal diff..."
    . (Join-Path (Split-Path -Parent $PSCommandPath) "diff_snapshots.ps1")
}
# using internal simple diff call:
& powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path (Split-Path -Parent $PSCommandPath) "diff_snapshots.ps1") -OldFile $pre -NewFile $post

# cleanup
try {
    Remove-LocalGroupMember -Group "Administrators" -Member $testName -ErrorAction SilentlyContinue
    Remove-LocalUser -Name $testName -ErrorAction SilentlyContinue
    Write-Host "Cleaned up test user"
} catch { Write-Warning "Cleanup failed: $_" }
