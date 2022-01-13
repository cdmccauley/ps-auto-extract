# https://stackoverflow.com/questions/29066742/watch-file-for-changes-and-run-command-with-powershell
# https://gist.github.com/mobzystems/793007db28e3ffcc20e2#file-7-zip-psm1

$folder = "C:\Users\Chris\Downloads"
$_7zFilter = "*.7z"
$_zipFilter = "*.zip"
$_rarFilter = "*.rar"

Set-Location $folder

$_7zWatcher = New-Object IO.FileSystemWatcher $folder, $_7zFilter -Property @{ 
    IncludeSubdirectories = $false
    NotifyFilter = [IO.NotifyFilters]'FileName, LastWrite'
}

$_7zOnCreated = Register-ObjectEvent $_7zWatcher -EventName Created -SourceIdentifier _7zOnCreated -Action {
    $path = $Event.SourceEventArgs.FullPath
    $target = [System.IO.Path]::GetFileNameWithoutExtension($path)
    Expand-7zArchive $path $target
}

$_zipWatcher = New-Object IO.FileSystemWatcher $folder, $_zipFilter -Property @{ 
    IncludeSubdirectories = $false
    NotifyFilter = [IO.NotifyFilters]'FileName, LastWrite'
}

$_zipOnCreated = Register-ObjectEvent $_zipWatcher -EventName Created -SourceIdentifier _zipOnCreated -Action {
    $path = $Event.SourceEventArgs.FullPath
    $target = [System.IO.Path]::GetFileNameWithoutExtension($path)
    Expand-7zArchive $path $target
}

$_rarWatcher = New-Object IO.FileSystemWatcher $folder, $_rarFilter -Property @{ 
    IncludeSubdirectories = $false
    NotifyFilter = [IO.NotifyFilters]'FileName, LastWrite'
}

$_rarOnCreated = Register-ObjectEvent $_rarWatcher -EventName Created -SourceIdentifier _rarOnCreated -Action {
    $path = $Event.SourceEventArgs.FullPath
    $target = [System.IO.Path]::GetFileNameWithoutExtension($path)
    Expand-7zArchive $path $target
}