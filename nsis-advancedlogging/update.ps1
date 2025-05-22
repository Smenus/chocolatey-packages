Import-Module Chocolatey-AU

$feed = 'https://sourceforge.net/projects/nsis/rss?path=/'

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $feed -UseBasicParsing
  $feed = ([xml]$download_page.Content).rss.channel

  $release = $feed.item | Where-Object link -match "-log.zip/download$" | Select-Object -First 1

  $url = $release.content.url
  $hash = $release.content.hash.innerText

  $version = [version]::Parse( ($url -split "-" | Select-Object -last 1 -skip 1) )

  $major = $version.Major
  $minor = $version.Minor
  $build = 0
  if ($version.Build -ne -1) { $build = $version.Build }

  $normalizedVersion = [version]::new(
    $major,
    $minor,
    $build
  )

  return @{
    Version = $normalizedVersion.ToString()

    URL32 = $url
    FileType = 'zip'

    Checksum32 = $hash
    ChecksumType32 = 'md5'
  }
}

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
        "(?i)(^\s*url\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
        "(?i)(^\s*checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
        "(?i)(^\s*checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
    }

    ".\nsis-advancedlogging.nuspec" = @{
        "(\<dependency .+?`"nsis.install`" version=)`"([^`"]+)`"" = "`$1`"[$($Latest.Version)]`""
    }
  }
}

update -ChecksumFor None -NoCheckChocoVersion