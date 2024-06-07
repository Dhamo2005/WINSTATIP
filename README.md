# WINSTATIP
Windows Set-StaticIP PowerShell Script

# Set-StaticIP PowerShell Script

## Overview
The `Set-StaticIP.ps1` PowerShell script is designed to automate the process of setting a static IP address, subnet mask, default gateway, and DNS servers for a Wi-Fi adapter on a Windows system. It removes any existing IP address and default gateway configurations before applying the new static IP settings, ensuring a clean configuration without conflicts.

## Features
- Automatically identifies the Wi-Fi adapter by its interface name.
- Removes existing IP address and default gateway configurations to avoid conflicts.
- Configures the specified static IP address, subnet mask, default gateway, and DNS servers.
- Provides a summary of the applied configuration settings for verification.

## Instructions

### Prerequisites
- Windows system with PowerShell.
- Administrative privileges to run the script.

### Steps

1. **Download the Script**:
   - Download the `Set-StaticIP.ps1` script from the repository.

2. **Run PowerShell as Administrator**:
   - Right-click the Start menu and select "Windows PowerShell (Admin)" or "Windows Terminal (Admin)".

3. **Set Execution Policy**:
   - Ensure that PowerShell script execution is allowed by running:
     ```powershell
     Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
     ```

4. **Run the Script**:
   - Navigate to the directory containing the script:
     ```powershell
     cd path\to\your\script
     ```
   - Run the script:
     ```powershell
     .\Set-StaticIP.ps1
     ```

## Author
[DHAMO2005]

## License
This script is released under the [GNU General Public License v3.0](LICENSE).
