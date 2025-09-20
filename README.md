# Windows-User-Audit

A simple PowerShell-based tool for monitoring **local user accounts** and **privileged group membership** changes on Windows systems.  
The tool can:

- Take a snapshot of all local users and group memberships  
- Compare two snapshots to highlight changes  
- Run a test harness that creates and deletes a dummy user to verify detection  

---

## 📂 Scripts

- **LocalUserSnapshot.ps1**  
  Takes a snapshot of current local users and groups.
  <img width="1015" height="695" alt="image" src="https://github.com/user-attachments/assets/45cd4eb2-f6c3-424d-a50b-77890e83dd1d" />
  
  Output is saved as JSON under:
  C:\Users<User>\Documents\UserAudit\snapshots\local\
  <img width="847" height="353" alt="image" src="https://github.com/user-attachments/assets/3f1d0e12-63ff-46e5-9475-3151dacf445f" />





- **`diff_snapshots.ps1`**  
Compares two snapshot JSON files and shows:
- Added/removed users  
- Changes to the **Administrators** group  

- **`test_harness_local.ps1`**  
End-to-end test. Creates a temporary user, adds it to Administrators, captures before/after snapshots, shows the diff, then cleans up.  

---

## ⚙️ Requirements

- Windows 10/11 (or Windows Server with PowerShell 5+)  
- PowerShell 5.1+ (comes preinstalled on modern Windows)  
- **Administrator rights** required for:
- Creating/removing test users (harness script)  
- Capturing complete group memberships  

---

## 🚀 Usage

### 1. Clone or download


2. Unblock the scripts (only once per file)

Windows may block downloaded scripts. Unblock them before running:

Unblock-File -Path .\LocalUserSnapshot.ps1
Unblock-File -Path .\diff_snapshots.ps1
Unblock-File -Path .\test_harness_local.ps1

3. Take a snapshot
.\LocalUserSnapshot.ps1


This saves a JSON snapshot under your Documents folder.

4. Compare snapshots

Take two snapshots (before/after a change) and compare:
```powershell
.\diff_snapshots.ps1 -OldFile "snapshots\local\local_snapshot_20250920T120000Z.json" `
                     -NewFile "snapshots\local\local_snapshot_20250920T121000Z.json"
```

Example output:
```powershell
=== Users ===
Added users:
 - audit_test_user
Removed users: none

=== Administrators group ===
Added to Administrators:
 - YOURPC\audit_test_user
Removed from Administrators: none

5. Run test harness (Admin only)
# Open PowerShell as Administrator
.\test_harness_local.ps1

```
This will automatically:

Save a “before” snapshot

Create a dummy user audit_test_user

Add it to Administrators

Save an “after” snapshot

Run diff to show the change

Clean up the test user

🔒 Security Notes

Inspect scripts before running. Only use on systems you control.

Run LocalUserSnapshot.ps1 without admin if you don’t need elevated privileges.

Prefer Unblock-File over Set-ExecutionPolicy Bypass to avoid enabling unknown scripts globally.

Test harness is for lab/testing only (creates/deletes accounts).

For safety, try in a VM or disposable test environment.

📜 License
MIT License

Copyright (c) 2025 <Your Name>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


---

Do you also want me to add a **“Demo” section with screenshots of the script output** so your README looks more professional on GitHub?
