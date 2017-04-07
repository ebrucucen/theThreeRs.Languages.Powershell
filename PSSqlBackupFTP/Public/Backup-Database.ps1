function Backup-Database{
  <#
      .SYNOPSIS
      Backs the database up on the specified instace to a custom location if specified.
      Call the Backup-SqlDatabase cmdlet [https://docs.microsoft.com/en-us/powershell/sqlserver/sqlserver-module/vlatest/Backup-SqlDatabase]

      .DESCRIPTION
      Creates a backup file with the provided options.

      .PARAMETER ServerInstance
      Name of the sql server instance where the databases are located 

      .PARAMETER DatabaseList
      Name list of the databases on the ServerInstance specified

      .PARAMETER Credential
      Credential of the account to do the backup [ideally with Backup permissions]

      .PARAMETER ConnectionTimeout
      Connection Timeout.

      .PARAMETER BackupActionType
      Type of the backup to be taken : Database, Files, Log. If Files specified requires location of files.

      .PARAMETER BackupCompressionOption
      Backup compression to be Default, Off and On.

      .PARAMETER BackupToCustomDirectory
      The file to be created as output

      .PARAMETER BackupPath
      Describe parameter -BackupPath.

      .EXAMPLE
      Backup-Database -ServerInstance 'localhost/instance' -DatabaseList @('db1','db2') -Credential Value -ConnectionTimeout Value -BackupActionType Value -BackupCompressionOption Value -BackupToCustomDirectory -BackupPath Value
      Describe what this call does

      .NOTES
      Place additional notes here.

      .LINK
      URLs to related sites
      The first link is opened by Get-Help -Online Backup-Database

      .INPUTS
      List of input types that are accepted by this function.

      .OUTPUTS
      List of output types produced by this function.
  #>
  param(
    [Parameter(Mandatory,HelpMessage='Name of the Sql Server Instance', Position=0,ValueFromPipelineByPropertyName=$true,ValueFromPipeline=$true) ]
    [string]$ServerInstance,
    [Parameter(Mandatory,HelpMessage='List of database names to be backed up',Position=1)] 
    [array]$DatabaseList,
    [System.Management.Automation.Credential()][pscredential]$Credential,
    [int]$ConnectionTimeout=0,
    [ValidateSet('Database','Log','Files')]
    [string]$BackupActionType='Database',
    [System.IO.Packaging.CompressionOption]$BackupCompressionOption='Normal',
    [switch]$BackupToCustomDirectory=$false,
    [switch]$CheckSum=$false,
    [switch]$Overwrite=$false
    
  )
  DynamicParam {
    if ($BackupToCustomDirectory) {
      #create a new ParameterAttribute Object
      $BackupPathAttribute = New-Object System.Management.Automation.ParameterAttribute
      $BackupPathAttribute.Mandatory = $true
      $BackupPathAttribute.HelpMessage = "Backup Path is required"
 
      #create an attributecollection object for the backup path attribute.
      $BackupPathAttributeCollection = new-object System.Collections.ObjectModel.Collection[System.Attribute]
 
      #add the certificate attribute to the collection.
      $BackupPathAttributeCollection.Add($BackupPathAttribute)
 
      #add the backup path paramater specifying the attribute collection.
      $BackupPathParam = New-Object System.Management.Automation.RuntimeDefinedParameter('BackupPath', [string], $BackupPathAttributeCollection)
 
      #add the name of backup path parameter to the dictionary to be added $psboundparameter list.
      $BackupPathParamDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
      $BackupPathParamDictionary.Add('BackupPath', $BackupPathParam)
      return $BackupPathParamDictionary
    }
    if($BackupActionType -eq 'Files'){
      #create a new ParameterAttribute Object
      $BackupFileAttribute = New-Object System.Management.Automation.ParameterAttribute
      $BackupFileAttribute.Mandatory = $true
      $BackupFileAttribute.HelpMessage = "Backup File is required"
 
      #create an attributecollection object for the backup path attribute.
      $BackupFileAttributeCollection = new-object System.Collections.ObjectModel.Collection[System.Attribute]
 
      #add the certificate attribute to the collection.
      $BackupFileAttributeCollection.Add($BackupFileAttribute)
 
      #add the backup path paramater specifying the attribute collection.
      $BackupFileParam = New-Object System.Management.Automation.RuntimeDefinedParameter('BackupFile', [string], $BackupFileAttributeCollection)
 
      #add the name of backup path parameter to the dictionary to be added $psboundparameter list.
      $BackupFileParamDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
      $BackupFileParamDictionary.Add('BackupFile', $BackupFileParam)
      return $BackupFileParamDictionary
    }
  }  
  begin{
    $getDatabaseParams=@{
      ServerInstance=$ServerInstance
      Credential=$Credential
      ConnectionTimeout=$ConnectionTimeout
    }
    
    $backupParams=@{
      ServerInstance=$ServerInstance
      Credential=$Credential
      CheckSum=$CheckSum
      CompressionOption=$BackupCompressionOption
      BackupAction=$BackupActionType
     }
    #Todo: Files actiontype is not implemented...
    $extension=switch ($BackupActionType){
      [Microsoft.SqlServer.Management.Smo.BackupActionType]::Database {".bak"}
      [Microsoft.SqlServer.Management.Smo.BackupActionType]::Log {".trn"}
    }
  
    $GenericFileConstant='GenericFile'
    $TimeStamp=Get-Date -Format ddMMyy_hhmm
    $GenericFileName="$($GenericFileConstant)_$($TimeStamp)_.$extension" 
 
    
    $GenericBackupFile= Join-Path -Path $PSBoundParameters.BackupPath -ChildPath $GenericFileName
         
  }
  process{
    #Todo: Add the backup path:
    #Todo: Implement the switch properly
    $DatabaseList |
    % { Get-SqlDatabase @getDatabaseParams -Name $_ }|
    % { Backup-SqlDatabase -Database $_.name -BackupFile ($GenericBackupFile.replace($GenericFileConstant, $_.name)) @backupParams }
  }
  end{
    #Todo: verify the backup are correctly in the path...
    if(Test-Path $BackupToCustomDirectory){
      return $true
    }
    else
    {
      return $false
    }
  }
}
# SIG # Begin signature block
  # MIID1QYJKoZIhvcNAQcCoIIDxjCCA8ICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
  # gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
  # AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU/m6onRfrPL2FTd4hbf+elCBz
  # r8ugggH3MIIB8zCCAVygAwIBAgIQKHlG3QO1WqNE9W5SzyMHWTANBgkqhkiG9w0B
  # AQUFADAUMRIwEAYDVQQDDAlFYnJ1Q3VjZW4wHhcNMTcwNDA0MTcyOTE4WhcNMjEw
  # NDA0MDAwMDAwWjAUMRIwEAYDVQQDDAlFYnJ1Q3VjZW4wgZ8wDQYJKoZIhvcNAQEB
  # BQADgY0AMIGJAoGBALaiqPAw5V7MDzIYTFZ7UJIqhGj6oSGBmbQ2uhTLS5XUtBcM
  # dttoGZAkN81Znl+ZFDHI48cv+bw3a/fdbw13f7SrGPHA+yrX24UBnyYZT7VM5qsb
  # HhYXu5LbPgApFZiJ6SRjskmo3uGjGaRiFumK256Fu0uCZWJHZ54/olUbHGjvAgMB
  # AAGjRjBEMBMGA1UdJQQMMAoGCCsGAQUFBwMDMB0GA1UdDgQWBBTYxN6gr9REEkE8
  # nWTi9GLCx2STITAOBgNVHQ8BAf8EBAMCB4AwDQYJKoZIhvcNAQEFBQADgYEAFXGf
  # 5l4Oma+RW1c2UBsH0Sszasvqe3QNlHlORA/5Qk/0CzZFVapp3LZaXbKM32zLBFBi
  # 4OXGbSM3vcEyjB9XSS9Su+JeNlRP934hVjDZeknaobYKFyyOHm3N7bf8lBMnQs1h
  # nVEY/jeuN/7Dn0NSDShBGxrAPZjzc5zbKKuYTQYxggFIMIIBRAIBATAoMBQxEjAQ
  # BgNVBAMMCUVicnVDdWNlbgIQKHlG3QO1WqNE9W5SzyMHWTAJBgUrDgMCGgUAoHgw
  # GAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGC
  # NwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQx
  # FgQUH0gBF7X3R/U6xwrCHCu6To6EXIAwDQYJKoZIhvcNAQEBBQAEgYArnKCb/fTr
  # qwk6CTIQ/MRmMYLfGq1YRNPVwZn4YFZRUiwVgebhOKCaaCF7UoyL5KHfPmxShw1i
  # ISGZnbDSyBfYRoF80ndFo94+QEaNSbWG6ZGqzDDizRuNN9skO9/RYnVph3wzhmG5
  # V+d6F8EVwtSwpvxOQHvbShdrt/RDt1W4TQ==
# SIG # End signature block
