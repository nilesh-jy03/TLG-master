<#  Deploy-TLG.ps1
    Kelley Vice 7/11/2018

    This script deploys the TLG (Test Lab Guide) 3 VM Base Configuration to your Azure RM subscription.
    You must have the AzureRM PowerShell module installed on your computer to run this script.
    To install the AzureRM module, execute the following command from an elevated PowerShell prompt:

    Install-Module AzureRM

#>

# Provide parameter values
$subscription = "53a9aadf-91b7-4603-ab86-68f16106f638"
$resourceGroup = "Hybrid-"
$location = "East US"

$configName = "TlgBaseConfig-01" # The name of the deployment, i.e. BaseConfig01. Do not use spaces or special characters other than _ or -. Used to concatenate resource names for the deployment.
$domainName = "corp.contoso.com" # The FQDN of the new AD domain.
$serverOS = "2016-Datacenter" # The OS of application servers in your deployment, i.e. 2016-Datacenter or 2012-R2-Datacenter.
$adminUserName = "demouser" # The name of the domain administrator account to create, i.e. globaladmin.
$adminPassword = "Shriram@9151" # The administrator account password.
$deployClientVm = "No" # Yes or No
$clientVhdUri = "" # The URI of the storage account containing the client VHD. Leave blank if you are not deploying a client VM.
$vmSize = "Standard_DS2_v2" # Select a VM size for all server VMs in your deployment.
$dnsLabelPrefix = "" # DNS label prefix for public IPs. Must be lowercase and match the regular expression: ^[a-z][a-z0-9-]{1,61}[a-z0-9]$.
$_artifactsLocation = "https://raw.githubusercontent.com/nilesh-jy03/TLG-master/master/TLG-master/tlg-base-config_3-vm" # Location of template artifacts.
$_artifactsLocationSasToken = "" # Enter SAS token here if needed.
$templateUri = "$_artifactsLocation/azuredeploy.json"

# Add parameters to array
$parameters = @{}
$parameters.Add("configName",$configName)
$parameters.Add("domainName",$domainName)
$parameters.Add("serverOS",$serverOS)
$parameters.Add("adminUserName",$adminUserName)
$parameters.Add("adminPassword",$adminPassword)
$parameters.Add("deployClientVm",$deployClientVm)
$parameters.Add("clientVhdUri",$clientVhdUri)
$parameters.Add("vmSize",$vmSize)
$parameters.Add("dnsLabelPrefix",$dnsLabelPrefix)
$parameters.Add("_artifactsLocation",$_artifactsLocation)
$parameters.Add("_artifactsLocationSasToken",$_artifactsLocationSasToken)

# Log in to Azure subscription
Connect-AzureRmAccount
Select-AzureRmSubscription -SubscriptionName $subscription

# Deploy resource group
New-AzureRmResourceGroup -Name $resourceGroup -Location $location

# Deploy template
New-AzureRmResourceGroupDeployment -Name $configName -ResourceGroupName $resourceGroup `
  -TemplateUri $templateUri -TemplateParameterObject $parameters -DeploymentDebugLogLevel All