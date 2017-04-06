# this is a Pester test file

#region source all functions into memory
. ($PSCommandPath -replace '\.tests\.ps1$', '.ps1')
#endregion

# describes the function Connect-FTP
Describe  -Name 'Connect-FTPServer Function Basic Tests' -Tags 'Basic,Connect-FTPServer' -Fixture {
      BeforeAll  {
        #Create a valid parameter set.
        $ValidParamHash=@{
            Uri=[System.Uri]'ftp://localhost/'
            PSCredential=New-Object -TypeName pscredential -ArgumentList ('abc',(ConvertTo-SecureString -String '123' -AsPlainText -Force))
          
        }
        #Create a dummy parameter set.
        $InvalidParamHash=@{
            Uri='abcServer'
            PSCredential=New-Object -TypeName pscredential -ArgumentList ('bbb',(ConvertTo-SecureString -String 'aaa' -AsPlainText -Force))     
        }
      }
}
Describe -Name 'Connect-FTPServer' -Fixture {

  #scenario 1: call the function with invalid/valid basic arguments
  Context -Name 'Running with InValid Uri/Login arguments'   -Fixture {
    #Test1: it does not throw an exception:
    It -name 'Test1: Without Correct Uri/Login should Throw Exception' -test {
      { Connect-FTPServer -Uri $InValidParamHash.Uri.AbsoluteUri -Credential $InvalidParamHash.PSCredential} | Should -LegacyArg1 Throw
    }
  }
  Context -Name 'Running with Valid Parametersets' -Fixture {
    #Test2: it returns nothing ($null):
    It -name 'Test2: With Valid Uri/Login Should Not Throw Exception' -test {
    
       {Connect-FTPServer -Uri $($ValidParamHash.Uri.AbsoluteUri) -Credential $ValidParamHash.PSCredential} | Should -LegacyArg1 Not -LegacyArg2 Throw
    }
    #Test3: with Certificate requirement: 
    It -name 'Test3: With RequiredCert, should fail without Cert' -test {
      {Connect-FTPServer -Uri $ValidParamHash.Uri.AbsoluteUri -Credential $ValidParamHash.PSCredential -RequireCertificate $true}| Should -LegacyArg1 not -LegacyArg2 Throw
    }    
  }
 }
 
 

# SIG # Begin signature block
  # MIID1QYJKoZIhvcNAQcCoIIDxjCCA8ICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
  # gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
  # AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUaL7KSIssYRhQggoJ5xz8j5ig
  # YuCgggH3MIIB8zCCAVygAwIBAgIQKHlG3QO1WqNE9W5SzyMHWTANBgkqhkiG9w0B
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
  # FgQU+d+FDzBx9iUH6LFWyPQNy/wp4rwwDQYJKoZIhvcNAQEBBQAEgYAwpr3WB93F
  # naiSFZmG9wzr9uF+cQLoG1oKNAAm20PaQB0G0mHXGsKuWE2teg9WzjIuF5wZZmEO
  # EBts1jhmnH1ipQlSjEKJTcuea1OjImK5JFjBLBJzjo88zqnw2fztnsogPX5xhe0t
  # LclUHGWfQAGyZjJDa6Pl8Vp7fWDVFGzVXQ==
# SIG # End signature block
