function Create-Temp-Folder {
    $parent = [System.IO.Path]::GetTempPath()
    [string] $name = [System.Guid]::NewGuid()
    $folder = New-Item -ItemType Directory -Path (Join-Path $parent $name)
    return $folder.FullName
}

# [Script]
# Name = Install-Btrfs-Driver
# Description = Download and install latest version of WinBtrfs, driver for Btrfs storage filesystems
# Requires = null
function Install-Btrfs-Driver {
    $TempFolder = Create-Temp-Folder
    
    $RepoGithub = "maharmstone/btrfs"

    $RepoLatest = Invoke-WebRequest -Uri "https://api.github.com/repos/$RepoGithub/releases/latest"
    $Json = ConvertFrom-Json $RepoLatest.content
    $Tag = $Json.tag_name
    $Ver = $Tag.substring(1)
    $FileName = "btrfs-$Ver.zip"
    $DriverArchiveLink = "https://github.com/$RepoGithub/releases/download/$Tag/$FileName.zip"

    try {
        $ProgressPreference = 'SilentlyContinue' # https://stackoverflow.com/a/43477248
        Invoke-WebRequest -URI $DriverArchiveLink -OutFile "$TempFolder/$FileName"
        Expand-Archive "$TempFolder/$FileName" -DestinationPath "$TempFolder/btrfs-unpacked"

        pnputil /add-driver  "$TempFolder/btrfs-unpacked/*.inf" /install
    }
    finally {
        try { Remove-Item -Path $TempFolder -Force -Recurse } catch {}
    }
}