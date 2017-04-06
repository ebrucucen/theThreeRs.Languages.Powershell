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
            [ValidateScript({[Uri]::IsWellFormedUriString($_, [System.UriKind]::Absolute)})]
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
      DynamicParam {
        if ($RequireCertificate) {
            #create a new ParameterAttribute Object
            $certificateAttribute = New-Object System.Management.Automation.ParameterAttribute
            $certificateAttribute.Mandatory = $true
            $certificateAttribute.HelpMessage = "Certificate is required"
 
            #create an attributecollection object for the certificate attribute.
            $attributeCollection = new-object System.Collections.ObjectModel.Collection[System.Attribute]
 
            #add the certificate attribute to the collection.
            $attributeCollection.Add($certificateAttribute)
 
            #add the certificate paramater specifying the attribute collection.
            $certificateParam = New-Object System.Management.Automation.RuntimeDefinedParameter('Certificates', [System.Security.Cryptography.X509Certificates.X509CertificateCollection], $attributeCollection)
 
            #add the name of certificate parameter to the dictionary to be added $psboundparameter list.
            $paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
            $paramDictionary.Add('Certificates', $certificateParam)
            return $paramDictionary
       }
   }  
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
            if($RequireCertificate) {
              $Request.ClientCertificates=$PSBoundParameters.Certificates
            }
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
                throw $info
            }
        }
        end{
          #Set the global variable as Request to be used later on: 
          if ($Response){
            if((Get-Variable -Name $SessionName -Scope Global -ErrorAction SilentlyContinue) -eq $null) {
              New-Variable -Name $SessionName -Scope Global -Value $Request -Force
            }
            else { 
              if(!(Get-Variable -Name $SessionName).Value -eq $Request){
                Set-Variable -Name $SessionName -Scope Global -Value $Request -Force
              }
              else{
                Write-Output "already set the request"
              }
            }
            return $Request
          }
          else {
            throw "Could not Get Response"
          }
        }
    }
# SIG # Begin signature block
# MIID1QYJKoZIhvcNAQcCoIIDxjCCA8ICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUc1UpbuDM4jkpIK/0TR0WxtNo
# rAqgggH3MIIB8zCCAVygAwIBAgIQKHlG3QO1WqNE9W5SzyMHWTANBgkqhkiG9w0B
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
# FgQUpvH0d+P03biJyHu5CU4Aa6LrfpkwDQYJKoZIhvcNAQEBBQAEgYBfcQHVfFPA
# BHRY5ik/YeO9V72vspz1Utzp2w5T43v1urDgWJxSCt7+eVNithgujbx5/+zGh1BM
# T3eg+v0cEdL3bMieVNL4hw+ayBC052xIJXspfKmF1o2xXt9Usggszj5NzbZMte0P
# WkKmgkGcq7k8SmrUehmfJaQe7UEmWsimAg==
# SIG # End signature block
