#require PS3
function Connect-FTPServer {
  <#
      .SYNOPSIS
      Creates a FTPRequest object driven by HttpWebRequest

      .DESCRIPTION
      To backup up files we need to establish a request to ftp server.

      .PARAMETER Uri
      The fullpath that the script will connect, and put files underneath. 

      .PARAMETER Credential
      The credentials provided to access/modify resources on FTP server.

      .PARAMETER SessionName
      The global ID to refer to the same request. 

      .PARAMETER Timeout
      The timeout period to be limited. By default -1, unlimited.

      .PARAMETER UseBinary
      The flag to indicate whether the files will be in Binary format or in the text format

      .PARAMETER UsePassive
      The flag to indicate whether the connection will be passive during the communication.

      .PARAMETER KeepAlive
      The flag to indicate whether the TCP connection will be kept alive. 

      .PARAMETER EnableSsl
      The flag to indicate whether the Ssl will be used. 

      .PARAMETER CachePolicyLevel
      Describe parameter -CachePolicyLevel.

      .EXAMPLE
      Connect-FTPServer -Uri Value -Credential Value -SessionName Value -Timeout Value -UseBinary Value -UsePassive Value -KeepAlive Value -EnableSsl Value -CachePolicyLevel Value
      Describe what this call does

      .NOTES
      Place additional notes here.

      .LINK
      URLs to related sites
      The first link is opened by Get-Help -Online Connect-FTPServer

      .INPUTS
      List of input types that are accepted by this function.

      .OUTPUTS
      List of output types produced by this function.
  #>


        [CmdletBinding()]
        param (
            [Parameter(Mandatory,HelpMessage='The FTP Server to be connected')]
            [ValidateScript({if (!($_ -match 'ftp*')) {
                    $Uri=Join-Path -Path 'ftp://' -ChildPath $Uri
                  }
                  [Uri]::IsWellFormedUriString($Uri, [System.UriKind]::Absolute)
            })]
            [Uri]$Uri,
            [Parameter(Mandatory,HelpMessage='Credential for the FTP Session')]
            [System.Management.Automation.Credential()][pscredential]$Credential,
            [string]$SessionName='DefaultFTPSession',
            [Int]$Timeout=-1,
            [Switch]$UseBinary=$false,
            [Switch]$UsePassive=$false,
            [Switch]$KeepAlive=$false,
            [Switch]$EnableSsl=$false,
            [Switch]$RequireCertificate=$false,
            [System.Net.Cache.HttpRequestCacheLevel] $CachePolicyLevel=[System.Net.Cache.HttpRequestCacheLevel]::NoCacheNoStore
        )
        
        begin {
        #Clean if there are any previous sessions/requests open
         if(!(Get-Variable -Name $SessionName -Scope Global -ErrorAction SilentlyContinue) -eq $null){
            Remove-Variable -Name $SessionName -Scope Global -Force 
         }
        }
        
        process {
            #Connect to the FTP Server get basic response to see it works: 
            [System.Net.FtpWebRequest]$Request = [System.Net.WebRequest]::Create($Uri)
            $Request.Credentials=$Credential
            $Request.Timeout=$Timeout
            #Implement Certificate addition
            $Request.EnableSsl=$EnableSsl
            $Request.KeepAlive=$KeepAlive
            $Request.UseBinary=$UseBinary
            $Request.CachePolicy=New-Object -TypeName System.Net.Cache.HttpRequestCachePolicy -ArgumentList ($CachePolicyLevel)
            $Request.Method=[System.Net.WebRequestMethods+FTP]::ListDirectoryDetails
            try{
              $Response=$Request.GetResponse()        
              $Response.Close() 
            }
            catch{
              # get a generic error record
                [System.Management.Automation.ErrorRecord]$e = $_

                # retrieve information about runtime error
                $info = [PSCustomObject]@{
                  Exception = $e.Exception.Message
                  Reason    = $e.CategoryInfo.Reason
                  Target    = $e.CategoryInfo.TargetName
                  Script    = $e.InvocationInfo.ScriptName
                  Line      = $e.InvocationInfo.ScriptLineNumber
                  Column    = $e.InvocationInfo.OffsetInLine
                }
                #Write the error object
          
                write-output $info.Exception.ToString()
            }
        }
        end{
          #Set the global variable as Request to be used later on: 
          if ($Response){
            Set-Variable -Name $SessionName -Scope Global -Value $Request -Force
            return $Request
          }
          else {
            throw Exception
          }
        }
    }
# SIG # Begin signature block
# MIID1QYJKoZIhvcNAQcCoIIDxjCCA8ICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU6N60OyNiwCDRAhMCgDprgdLZ
# gRegggH3MIIB8zCCAVygAwIBAgIQKHlG3QO1WqNE9W5SzyMHWTANBgkqhkiG9w0B
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
# FgQUFd3TNxohR4nob384W9VLldPLragwDQYJKoZIhvcNAQEBBQAEgYCbCwfshgwo
# GxXE0YxnDoH0/kb6B2Ne5jafrAoP6zGjEtLJII9fJtD+ULAHeE+S164HGXuMuHw+
# +rbwWbYKylWYsHs+9mKdIjXj43PC3do6aTEyr7RY2bAXlkf0WSBIfAwXaVEm/A1c
# RvvDOduXNBdAgBKqhFNgmvh03PL5vctgYQ==
# SIG # End signature block
