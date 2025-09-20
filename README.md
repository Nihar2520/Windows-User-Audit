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
  <img width="847" height="353" alt="image" src="https://github.com/user-attachments/assets/3f1d0e12-63ff-46e5-9475-3151dacf445f" />


