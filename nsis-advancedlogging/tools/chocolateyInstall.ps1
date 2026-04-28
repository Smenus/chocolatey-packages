$ErrorActionPreference = 'Stop'

$nsisDir = Get-AppInstallLocation "Nullsoft Install System"
if (!$nsisDir)  { throw "Can't find NSIS install location"; }

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName

  url           = 'https://sourceforge.net/projects/nsis/files/NSIS%203/3.12/nsis-3.12-log.zip/download'
  checksum      = '61c00ca433af61068b8a57d76d3d3c87'
  checksumType  = 'md5'

  unzipLocation = $nsisDir
}

Install-ChocolateyZipPackage @packageArgs
