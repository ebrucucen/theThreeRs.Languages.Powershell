# this is a Pester test file

#region source all functions into memory
. ($PSCommandPath -replace '\.tests\.ps1$', '.ps1')
#endregion

#Test set for the function Backup-Database
Describe 'Backup-Database' {


  BeforeAll{
    Add-Type -Path 'C:\Program Files\Microsoft SQL Server\130\SDK\Assemblies\Microsoft.SqlServer.Smo.dll'
    $ValidParamHash=@{
      ServerInstance='localhost'
      DatabaseList=@('master')
      BackupToCustomDirectory=$true
      BackupFile='C:\DBBackups'
      Overwrite=$false
    }
    $InvalidParamHash=@{
      ServerInstance='abc'
      DatabaseList=@('aa','bb')
      BackupToCustomDirectory=$false
      BackupFile='T:\'
      Overwrite=$false
    }
  }
  # scenario 1: call the function without arguments/invalid argument set
  Context 'Running with invalid arguments'   {
    #Test 1: it does not throw an exception:
    It 'Test 1: Throw Error when runs with invalid arguments' {
      { Backup-Database @InvalidParamHash } | Should Throw
    }
  }
  #Scenario 2: Call the function with Valid argument set
  Context 'Running with Valid argument set' { 
    #Test 2: Throw Error with Invalid argument set
    It 'Test 2: Should Not Throw Error with valid argument set' {
      { Backup-Database -ServerInstance 'localhost' -Databaselist @('master')} | Should Not Throw
    }
    # Test 3: Create a backup with Valid argument set
    It 'Test 3: Create a backup with Valid argument set'     {
      #Backup-SqlDatabase -ServerInstance 'localhost' -Database master -BackupFile 'C:\DBBackups\master.1.bak' 
      Backup-Database  -ServerInstance 'localhost' -Databaselist @('master') | Should Not BeNullOrEmpty 
    }
  }
}
