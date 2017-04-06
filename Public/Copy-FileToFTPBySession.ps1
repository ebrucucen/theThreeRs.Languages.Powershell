function Copy-FileToFTPBySession{
  <#
      .SYNOPSIS
      Puts the backup files to ftp location

      .DESCRIPTION
      For each given file, the function copies the file to the destination folder, overwrites if it is chosen.

      .PARAMETER LocalAbsolutePath
      The local location of the file to copied to FTP server destination.

      .PARAMETER TargetRelativePath
      The relative path/directory on the FTP server, located under the FTP URI.

      .PARAMETER Overwrite
      Overwrites the target file if exists

      .EXAMPLE
      Backup-DatabaseToFTP -LocalAbsolutePath Value -TargetRelativePath Value
      Describe what this call does

      .NOTES
      Place additional notes here.

      .LINK
      URLs to related sites
      The first link is opened by Get-Help -Online Backup-DatabaseToFTP

      .INPUTS
      List of input types that are accepted by this function.

      .OUTPUTS
      List of output types produced by this function.
  #>


  param([Parameter(Mandatory,HelpMessage='Add help message for user')]
    [ValidateScript({Test-Path -Path $_})]
    [String]$LocalAbsolutePath,
    [ValidateScript({[Uri]::IsWellFormedUriString($_, [System.UriKind]::Relative)})]
    [String]$TargetRelativePath='Backups',
    [String]$SessionName='DefaultFTPSession',
    [Int]$BytesPerUpload=1024,
    [Bool]$Overwrite=$false        
  )
  begin{
    #Check the Session, if can't find it, we should throw exception, else get the Request object on this variable.
    if((Get-Variable -Name $SessionName -Scope Global -ErrorAction SilentlyContinue) -eq $null){
      Throw Exception
    }else{
        $Request= Get-Variable -Name $SessionName -Scope Global -ErrorAction SilentlyContinue -ValueOnly
        
    }
  }
  process{
    #Todo: Implement the upload:
    #Put the file on the localAbsolutePath to RequestUri+TargetRelativePath
    $FileToCopy=(Get-Item $LocalAbsolutePath).Name
    $Request.Method =[System.Net.WebRequestMethods+Ftp]::UploadFile
    try{
        $RequestStream=$Request.GetRequestStream()
        write-output "$($FileToCopy.Length) to be copied to FTP"
        $Stream=[System.IO.File]::OpenRead($FileToCopy)
        $requestStream.
        [Byte[]] $Buffer=New-Object Byte[] $BytesPerUpload
        do {
        $Read=$Stream.Read($Buffer,0, $Buffer.Length)
        $TotalRead+=$Read
        $RequestStream.Write($Buffer,0,$Read)
        }while ($TotalRead -ge $($FileToCopy.Length)  
        $Request.GetResponse()
        $Request= Set-Variable -Name $SessionName -Scope Global -ErrorAction SilentlyContinue -ValueOnly
    }
    catch{
    }
  }
  end{
  }
            
}
# SIG # Begin signature block
# MIID1QYJKoZIhvcNAQcCoIIDxjCCA8ICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU+BagYEcgIwEJZvO7MR8eG1/L
# Jq+gggH3MIIB8zCCAVygAwIBAgIQKHlG3QO1WqNE9W5SzyMHWTANBgkqhkiG9w0B
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
# FgQUhXfWFUIz3rRVFq8iMtVBXeqw4uUwDQYJKoZIhvcNAQEBBQAEgYBwRHNhsUUv
# PLbm5YLW7IK+miQlXS16HYi6FCqZ/XCtTRmY+RQRJxEnwLXoAhmJQjS0PQWFmzWR
# 7+G2Zaw85cNCmKEcGz6ORiD7k6czW/1gsM59iEWlTrtsV+17rs0x0PaTtT1LIFca
# g2HCCHJrtZrOnaHqvpBFxYEAz6n1zkXntg==
# SIG # End signature block
