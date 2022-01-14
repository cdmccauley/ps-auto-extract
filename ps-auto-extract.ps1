# https://stackoverflow.com/questions/29066742/watch-file-for-changes-and-run-command-with-powershell

# TODO: check if 7z in path

$folder = "C:\Users\Chris\Downloads"

Set-Location $folder

$watcher = New-Object IO.FileSystemWatcher $folder -Property @{ 
    IncludeSubdirectories = $false
    NotifyFilter = [IO.NotifyFilters]'FileName, LastWrite'
}

$onCreated = Register-ObjectEvent $watcher -EventName Created -SourceIdentifier FileCreated -Action {
    $extensions = @(".7z", ".zip", ".rar")
    $source = $Event.SourceEventArgs.FullPath
    $destination = [System.IO.Path]::GetFileNameWithoutExtension($source)
    $extension = [System.IO.Path]::GetExtension($source)
    $isArchive = $extensions.Contains($extension)
    $command = "7z x $source -o$destination"
    if ($isArchive) { Invoke-Expression -Command $command }
}