# https://stackoverflow.com/questions/29066742/watch-file-for-changes-and-run-command-with-powershell
# https://gist.github.com/mobzystems/793007db28e3ffcc20e2#file-7-zip-psm1

$folder = "C:\Users\Chris\Downloads"
$filter = "*.*z*"

$Watcher = New-Object IO.FileSystemWatcher $folder, $filter -Property @{ 
    IncludeSubdirectories = $false
    NotifyFilter = [IO.NotifyFilters]'FileName, LastWrite'
}

$onCreated = Register-ObjectEvent $Watcher -EventName Created -SourceIdentifier FileCreated -Action {
    $path = $Event.SourceEventArgs.FullPath
    $target = [System.IO.Path]::GetFileNameWithoutExtension($path)
    Expand-7zArchive $path $target
}