# this is a Pester test file

#region source all functions into memory
. ($PSCommandPath -replace '\.tests\.ps1$', '.ps1')
#endregion

#Tests for Copy-FileToFTPBySession
Describe 'Copy-FileToFTPBySession' {

  # scenario 1: call the function without arguments
  Context 'Running without arguments'   {
    # test 1: it does not throw an exception:
    It 'Test 1: runs with errors' {
      { Copy-FileToFTPBySession } | Should Throw
    }

    # test 2: it returns nothing ($null):
    It 'Test 2: does not throw exception with valid argument set'     {
      Copy-FileToFTPBySession | Should BeNullOrEmpty 
    }
  }
}
