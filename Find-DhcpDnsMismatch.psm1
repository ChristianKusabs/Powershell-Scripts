<#
.SYNOPSIS
  Finds mismatched records between the given DHCP server and DNS Server
.DESCRIPTION
  TODO add description
.PARAMETER dnsServer
  IP or Hostname of DNS Server
.PARAMETER dhcpServer
  IP or Hostname of DHCP Server
.PARAMETER dnsZone
  IP of DNS Zone
.PARAMETER dhcpScope
  The DHCP Scope you would like to search
.INPUTS
  None
.OUTPUTS
  Mismatched DNS and DHCP records
.NOTES
  Version:        1.0
  Author:         Christian Kusabs
  Creation Date:  31-07-2020
  Purpose/Change: Initial script
  
.EXAMPLE
  Find-DhcpDnsMismatch -dnsServer 192.168.0.2 -dhcpServer 192.168.0.3 -dnsZone 192.168.0.0 -dhcpScope "test.local"
#>

function Find-DhcpDnsMismatch {

    param(
        [string[]] $dnsServer,
        [string[]] $dhcpServer,
        [string[]] $dnsZone,
        [string[]] $dhcpScope
    )

    Get-DhcpServerv4Lease -ComputerName $dhcpServer -ScopeId $dhcpScope | ForEach-Object {

        $leaseName = ($_.HostName -replace "\..*", "")
        $leaseIP = $_.IPAddress

        Get-DnsServerResourceRecord -ComputerName $dnsServer -ZoneName $dnsZone -RRType "A" | ForEach-Object {

            if ($leaseName -eq $_.HostName) {
                if ($leaseIP -ne $_.RecordData.ipv4address.IPAddressToString) {
                    Write-Output "Mismatch found"
                    Write-Output "DNS Record: $($_.HostName), address: $($_.RecordData.ipv4address.IPAddressToString)"
                    Write-Output "DHCP Record: $leaseName, address: $leaseIP"
                }
            }
            
        }
    }
}

Export-ModuleMember -Function Find-DhcpDnsMismatch