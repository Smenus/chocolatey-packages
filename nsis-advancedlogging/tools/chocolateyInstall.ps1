$ErrorActionPreference = 'Stop'

$nsisDir = Get-AppInstallLocation "Nullsoft Install System"
if (!$nsisDir)  { throw "Can't find NSIS install location"; }

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName

  url           = 'https://sourceforge.net/projects/nsis/files/NSIS%203/3.11/nsis-3.11-log.zip/download'
  checksum      = '86044819c632da4e92ded1deeb97fff9'
  checksumType  = 'md5'

  unzipLocation = $nsisDir
}

Install-ChocolateyZipPackage @packageArgs
