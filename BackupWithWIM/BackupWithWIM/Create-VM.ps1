Param([string]$username, [string]$password, [string]$hostName, [string]$Name, $MemoryStartupBytes, [string]$VHDPath, [string]$Switchname, [int]$vCPUCount, [int]$vNICCount)


$secpasswd = ConvertTo-SecureString $password -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential ($username, $secpasswd)

$session = New-PSSession -ComputerName $hostName -Credential $creds -Name VMCreate -AllowRedirection $true 

Enter-PSSession -Session $session

Import-Module Hyper-V

New-VM –Name $Name –MemoryStartupBytes $MemoryStartupBytes –VHDPath $VHDPath

for($i = 0; $i -le $vNICCount; $i++){
    Add-VMNetworkAdapter –VMName $Name –Switchname $Switchname
}

Set-VMProcessor -VMName $Name -Count $vCPUCount        

Exit-PSSession $session

Get-PSSession | Remove-PSSession

Exit 