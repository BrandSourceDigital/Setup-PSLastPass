# This script will install and configure PSLastPass to use for authentication
# to the M365/AzureAD tenant for administration

Set-ExecutionPolicy RemoteSigned

$modules = @('Microsoft.PowerShell.SecretManagement','Microsoft.Powershell.Secretstore','PSLastPass')
$LastPassStore = "$env:APPDATA/PSLastPass.xml"

foreach ($m in $modules) {
    if (Get-Module | Where-Object {$_.Name -eq $m}) {
        Write-Host "$m is already installed and imported."
    }
    Else {
        if (Get-Module -ListAvailable | Where-Object {$_.Name -eq $m}) {
            Write-Host "$m has not been imported. Importing..."
            Import-Module $m
            Write-Host "$m has been imported"
        } 
        else {
            if (Find-Module -Name $m | Where-Object {$_.Name -eq $m}) {
                Install-Module -Name $m -Force -Verbose -Scope CurrentUser
                Import-Module $m
                Write-Host "$m has been installed and imported"
            }
        }
    }
}
if (-not(Test-Path $LastPassStore -PathType Leaf)) {
    Write-Host "Saving LastPass vault to local encrypted file..."
    Save-LPData -SaveVault
    Write-Host "Save has completed. To sync any future changes, use 'Sync-LPData'"
}
else {
    Write-Host "LastPass vault already saved. To update, please run 'Sync-LPData'"
}