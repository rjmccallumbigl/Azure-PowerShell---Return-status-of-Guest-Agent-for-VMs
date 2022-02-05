# Get all VMs
Connect-AzAccount
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
