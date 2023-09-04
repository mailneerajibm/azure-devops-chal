# Infrastructure.Tests.ps1

param (
    [string]$resourceGroupName,
    [string]$storageAccountName,
    [string]$cdnProfileName
)

Describe "Storage Account Tests" {

    It "Should have a blue deployment" {
        $blueStorageAccount = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name "${storageAccountName}blue"
        $blueStorageAccount | Should -Not -Be $null
    }

    It "Should have a green deployment" {
        $greenStorageAccount = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name "${storageAccountName}green"
        $greenStorageAccount | Should -Not -Be $null
    }
}

Describe "CDN Tests" {
    It "Should have a blue CDN endpoint" {
        $blueCdnEndpoint = Get-AzCdnEndpoint -ProfileName $cdnProfileName -ResourceGroupName $resourceGroupName -EndpointName "blueEndpoint"
        $blueCdnEndpoint | Should -Not -Be $null
    }

    It "Should have a green CDN endpoint" {
        $greenCdnEndpoint = Get-AzCdnEndpoint -ProfileName $cdnProfileName -ResourceGroupName $resourceGroupName -EndpointName "greenEndpoint"
        $greenCdnEndpoint | Should -Not -Be $null
    }

    It "Should have correct blue origin" {
        $blueCdnEndpoint = Get-AzCdnEndpoint -ProfileName $cdnProfileName -ResourceGroupName $resourceGroupName -EndpointName "blueEndpoint"
        $originHostName = $blueCdnEndpoint.Origin[0].hostName
        $originHostName | Should -Be "${storageAccountName}blue.blob.core.windows.net"
    }

    It "Should have correct green origin" {
        $greenCdnEndpoint = Get-AzCdnEndpoint -ProfileName $cdnProfileName -ResourceGroupName $resourceGroupName -EndpointName "greenEndpoint"
        $originHostName = $greenCdnEndpoint.Origin[0].hostName
        $originHostName | Should -Be "${storageAccountName}green.blob.core.windows.net"
    }
}

