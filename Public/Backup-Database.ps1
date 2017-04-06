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
    [Microsoft.SqlServer.Management.Smo.BackupActionType]$BackupActionType='Full',
    [System.IO.Packaging.CompressionOption]$BackupCompressionOption='Default',
    [Switch]$BackupToCustomDirectory=$false,
    [ValidateScript({if($BackupToCustomDirectory){Test-Path -Path $_}})]
    [string]$BackupPath,
    [switch]$CheckSum
    
  )
  begin{
    #Todo: customise backuppath if the switch is selected...
    $datestamp=Get-Date -Format ddMMyy_hhmm
     
  }
  process{
    #Todo: Add the backup path:
    #Todo: Implement the switch properly
    $DatabaseList |
    Get-SqlDatabase  -ServerInstance $ServerInstance -Credential $Credential -ConnectionTimeout $ConnectionTimeout -Name $_ |
    Backup-SqlDatabase  -CompressionOption $BackupCompressionOption -BackupAction $BackupActionType -ServerInstance $ServerInstance -Checksum $CheckSum
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
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQURiNEVvOImAmRvS8yc8OMcIPq
# SV2gggH3MIIB8zCCAVygAwIBAgIQKHlG3QO1WqNE9W5SzyMHWTANBgkqhkiG9w0B
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
# FgQU3ri784fmNyvBftZyteJIFMCQyckwDQYJKoZIhvcNAQEBBQAEgYAo3JdulOfK
# nbIDFiWQSalvERKDGr0WlxO5tZqUQErIrm6HmnZrzRxNyfTCQf03bLpLVTz1ps7W
# wjXXalMDzKkPuj6g0uLOfW5rJ4VGFAMc1+Dm367OjSkpPPJH//or5eBc0z/aL7i0
# 9ImDHk2rdT2v9hGivGfjMAKTRazudFL+og==
# SIG # End signature block
