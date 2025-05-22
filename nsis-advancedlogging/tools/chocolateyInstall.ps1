$ErrorActionPreference = 'Stop'

$nsisDir = Get-AppInstallLocation "Nullsoft Install System"
if (!$nsisDir)  { throw "Can't find NSIS install location"; }

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName

  url           = 'https://iweb.dl.sourceforge.net/project/nsis/NSIS%203/3.04/nsis-3.04-log.zip'
  checksum      = 'e33bd03a3deb056bc217da6c929a6ad1b41ca07de6ac34574f14fbcb64d87039'
  checksumType  = 'sha256'

  unzipLocation = $nsisDir
}

Install-ChocolateyZipPackage @packageArgs
