# this is a Pester test file

#region source all functions into memory
. ($PSCommandPath -replace '\.tests\.ps1$', '.ps1')
#endregion

#Test set for the function Backup-Database
Describe 'Backup-Database' {
  BeforeAll{
    $ValidParamHash=@{
      Server='localhost'
      DatabaseList=@('master')
      BackupPath=Join-Path -Path "C:\\DBBackups"
      Overwrite=$false
      }
      $InvalidParamHash=@{
        Server='abc'
        DatabaseList=@('aa','bb')
        BackupPath="T:\"
        Overwrite=$false
      }
  }
  # scenario 1: call the function without arguments/invalid argument set
  Context 'Running without arguments'   {
    #Test 1: it does not throw an exception:
    It 'Test 1: Throw Error when runs without arguments' {
      { Backup-Database  } | Should Throw
    }
       #Test 2: Throw Error with Invalid argument set
    It 'Test 2: Throw Error with Invalid argument set' {
      { Backup-Database } | Should Not Throw
    }

  }
  #Scenario 2: Call the function with Valid argument set
    Context 'Running with Valid argument set' { 
      # Test 3: Create a backup with Valid argument set
      It 'Test 3: Create a backup with Valid argument set'     {
      #Backup-SqlDatabase -ServerInstance 'localhost' -Database master -BackupFile 'C:\DBBackups\master.1.bak' 
        Backup-Database -ServerInstance $ValidParamHash.Server -DatabaseList $ValidParamHash.DatabaseList -BackupToCustomDirectory $ValidParamHash.BackupPath  | Should Not BeNullOrEmpty 
      }
    }
}
