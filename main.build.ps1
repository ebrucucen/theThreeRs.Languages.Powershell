$TestLocation=Join-Path -Path $PSScriptRoot -ChildPath "Public"
$TestOutputDirectory=Join-Path -Path $TestLocation -ChildPath "Tests"
$Timestamp= Get-date -format "ddMM_hhmmss"

task Test {
  $TestFiles= Get-ChildItem -Path $TestLocation -Filter "*.tests.*"    
  foreach ($TestFile in $TestFiles){        
    $TestOutputFileName= Join-path -path $TestOutputDirectory -ChildPath "$($Testfile.basename)_$Timestamp.xml"        
    $TestResult=Invoke-Pester -Script $TestFile.Fullname  -OutputFile $TestOutputFileName -OutputFormat NUnitXml    
  }    
  #upload to Appveyor    
  #(New-Object 'System.Net.WebClient').UploadFile("https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)", (Resolve-Path $TestOutputFileName))    
  if($TestResult.FailedCount -gt 0){
    Write-Error "Failed '$($TestResult.FailedCount)' tests, build failed"     
  }
}
task . Test 