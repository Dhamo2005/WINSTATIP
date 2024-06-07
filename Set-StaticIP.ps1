# Define the interface name for the Wi-Fi adapter
$interfaceName = "WiFi"  # Update this to "WiFi" as per your output

# Function to convert subnet prefix length to subnet mask
function Convert-SubnetPrefixToMask {
    param (
        [int]$prefixLength
    )
    $binaryMask = ('1' * $prefixLength).PadRight(32, '0')
    $mask = [System.Net.IPAddress]::Parse(
        [Convert]::ToInt32($binaryMask.Substring(0, 8), 2).ToString() + '.' +
        [Convert]::ToInt32($binaryMask.Substring(8, 8), 2).ToString() + '.' +
        [Convert]::ToInt32($binaryMask.Substring(16, 8), 2).ToString() + '.' +
        [Convert]::ToInt32($binaryMask.Substring(24, 8), 2).ToString()
    )
    return $mask.ToString()
}

# Get the current network configuration
$networkConfig = Get-NetIPConfiguration -InterfaceAlias $interfaceName

if ($networkConfig -eq $null) {
    Write-Error "No network configuration found for interface '$interfaceName'. Please ensure the interface name is correct and the device is connected to the network."
    exit
}

# Remove existing IP address configurations
$existingIPAddresses = $networkConfig | Select-Object -ExpandProperty IPv4Address
foreach ($ip in $existingIPAddresses) {
    try {
        Remove-NetIPAddress -InterfaceAlias $interfaceName -IPAddress $ip.IPAddress -Confirm:$false -ErrorAction Stop
        Write-Output "Removed existing IP address: $($ip.IPAddress)"
    } catch {
        Write-Error "Failed to remove existing IP address: $_"
    }
}

# Remove existing default gateway configurations
$existingGateways = $networkConfig | Select-Object -ExpandProperty IPv4DefaultGateway
foreach ($gw in $existingGateways) {
    try {
        Remove-NetRoute -InterfaceAlias $interfaceName -NextHop $gw.NextHop -Confirm:$false -ErrorAction Stop
        Write-Output "Removed existing default gateway: $($gw.NextHop)"
    } catch {
        Write-Error "Failed to remove existing default gateway: $_"
    }
}

# Extract the current subnet prefix length and gateway
$currentSubnetMask = $networkConfig.IPv4Address.PrefixLength
$currentGateway = $networkConfig.IPv4DefaultGateway.NextHop

# Set the desired static IP address
$staticIP = "192.168.241.100"  # Adjust this as needed

# Set the desired DNS servers (you can use Google's public DNS servers)
$dnsServers = "8.8.8.8", "8.8.4.4"

# Convert the subnet prefix length to subnet mask
$subnetMask = Convert-SubnetPrefixToMask -prefixLength $currentSubnetMask

# Set the new static IP configuration
try {
    New-NetIPAddress -InterfaceAlias $interfaceName -IPAddress $staticIP -PrefixLength $currentSubnetMask -DefaultGateway $currentGateway -ErrorAction Stop
    Write-Output "Static IP address configuration applied successfully."
} catch {
    Write-Error "Failed to set static IP address: $_"
}

# Set the DNS servers
try {
    Set-DnsClientServerAddress -InterfaceAlias $interfaceName -ServerAddresses $dnsServers -ErrorAction Stop
    Write-Output "DNS server configuration applied successfully."
} catch {
    Write-Error "Failed to set DNS servers: $_"
}

Write-Output "Configuration Summary:"
Write-Output "IP Address: $staticIP"
Write-Output "Subnet Mask: $subnetMask"
Write-Output "Default Gateway: $currentGateway"
Write-Output "DNS Servers: $($dnsServers -join ', ')"
