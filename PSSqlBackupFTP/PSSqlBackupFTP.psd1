
@{

# Script module or binary module file associated with this manifest.
RootModule = 'PSSqlBackupFTP'

# Version number of this module.
ModuleVersion = '1.0'

# ID used to uniquely identify this module
GUID = 'eb71d5e5-b0ee-4e43-b4c4-0932b0102f10'

# Author of this module
Author = 'Ebru Cucen'

# Company or vendor of this module
CompanyName = 'personal'

# Copyright statement for this module
Copyright = '(c) 2017 Administrator. All rights reserved.'

# Description of the functionality provided by this module
# Description = 'Back up sql database(s) and copies over to FTP location'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '5.1'


# Assemblies that must be loaded prior to importing this module
RequiredAssemblies = @('Microsoft.SqlServer.SmoExtended.dll')

# Functions to export from this module
FunctionsToExport = '*'

# Cmdlets to export from this module
CmdletsToExport = '*'

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module
AliasesToExport = '*'

# List of all files packaged with this module
FileList = @( 'PSSqlBackupFTP.psd1','PSSqlBackupFTP.psm1', '.\Public\Backup-Database.ps1', '.\Public\Backup-Database.test.ps1','.\Public\Connect-FTPServer.ps1','.\Public\Connect-FTPServer.test.ps1','.\Public\Copy-FileToFTPBySession.ps1','.\Public\Copy-FileToFTPBySession.tests.ps1' )


}

