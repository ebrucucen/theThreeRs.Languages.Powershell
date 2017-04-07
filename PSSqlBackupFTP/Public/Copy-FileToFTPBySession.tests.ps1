# this is a Pester test file

#region source all functions into memory
. ($PSCommandPath -replace '\.tests\.ps1$', '.ps1')
#endregion

#Tests for Copy-FileToFTPBySession
Describe 'Copy-FileToFTPBySession' {
  BeforeAll  {
  Import-Module ..\PSSqlBackupFTP.psm1
    #Create a valid parameter set.
    $ValidParamHash=@{
      Uri='ftp://localhost/DBBackups'
      Credential=New-Object -TypeName pscredential -ArgumentList ('abc',(ConvertTo-SecureString -String '123' -AsPlainText -Force))
    }

    #Create a dummy parameter set.
    $InvalidParamHash=@{
      Uri='abcServer'
      Credential=New-Object -TypeName pscredential -ArgumentList ('bbb',(ConvertTo-SecureString -String 'aaa' -AsPlainText -Force))     
    }
    $Request=Connect-FTPServer -Uri ([Uri]$ValidParamHash.Uri).AbsoluteUri.Replace(([Uri]$ValidParamHash.Uri).AbsolutePath,"") -Credential $ValidParamHash.Credential
  }
         
  # scenario 1: call the function without arguments
  Context 'Running without arguments'   {
    # test 1: it does not throw an exception:
    It 'Test 1: runs with errors' {
      { Copy-FileToFTPBySession - } | Should Throw
    }

    # test 2: it returns nothing ($null):
    It 'Test 2: does not throw exception with valid argument set'     {
      Copy-FileToFTPBySession | Should BeNullOrEmpty 
    }
  }
}
