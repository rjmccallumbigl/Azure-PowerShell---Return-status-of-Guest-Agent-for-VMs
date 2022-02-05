<##########################################################################################################

	.SYNOPSIS
		Return verbose status of Guest Agent for Azure VMs.
 
##########################################################################################################>
# https://github.com/microsoft/MSLab/tree/master/Scenarios/Running%20WSLab%20in%20Azure#creating-vm-with-powershell
# Set-execution policy to remote signed for current process
if ((Get-ExecutionPolicy) -ne "RemoteSigned"){Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process -Force}

# Download Azure module
if (!(Import-Module -Name Az -ErrorAction Ignore)){
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
    Install-Module -Name AZ -Force
}

Login-AzAccount -UseDeviceAuthentication

#select context if more available
$context=Get-AzContext -ListAvailable
if (($context).count -gt 1){
    $context | Out-GridView -OutputMode Single | Set-AzContext
}

# Get all VMs
$vms = Get-AzVM

# For each returned VM, display Resource URI and Guest Agent status
foreach ($vm in $vms) {
	Write-Output $vm.Id
	$vmStatus = Get-AzVM -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName -Status	
	foreach ($status in $vmStatus.Statuses) {
		if ($status.DisplayStatus -like "*deallocat*") {
			# 
			Write-Output "VM is deallocated, Start VM to successfully grab state of Guest Agent"
			break
		}	
	}
 $vmStatus.VMAgent.Statuses
}
