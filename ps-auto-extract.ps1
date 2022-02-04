# https://stackoverflow.com/questions/29066742/watch-file-for-changes-and-run-command-with-powershell

# TODO: check if 7z in path

$folder = "$env:USERPROFILE\Downloads"

Set-Location $folder

$watcher = New-Object IO.FileSystemWatcher $folder -Property @{ 
    IncludeSubdirectories = $false
    NotifyFilter = [IO.NotifyFilters]'FileName, LastWrite'
}

$onCreated = Register-ObjectEvent $watcher -EventName Created -SourceIdentifier FileCreated -Action {
    $extensions = @(".7z", ".zip", ".rar")
    $source = $Event.SourceEventArgs.FullPath
    $destination = [System.IO.Path]::GetFileNameWithoutExtension("'$source'")
    $extension = [System.IO.Path]::GetExtension($source)
    # Write-Host $source, $destination, $extension
    $isArchive = $extensions.Contains($extension)
    # $scommand = "7z x '$source' -o'$destination' 2>''"
    # Write-Host $scommand

    if ($isArchive) {
        $previousSize = -1
        $currentSize = Get-Item -Path $source | Select-Object -ExpandProperty Length
        # while( $previousSize -ne $currentSize ) {
        #     Write-Host $previousSize, $currentSize
        #     # Start-Sleep -Seconds 1
        #     $previousSize = $currentSize
        #     $currentSize = Get-Item -Path $File | Select-Object -ExpandProperty Length
        # }
        Write-Host "Extracting $source"
        $command = "7z x '$source' -o'$destination' 2>''"
        $errout = $null
        $null = Invoke-Expression -Command $command -ErrorVariable errout
        # Write-Host $errout
        if ($errout -ne $null) { 
            Write-Host $errout
            # Unregister-Event -SubscriptionId $onCreated.Id
            # $recreateCommand = "& $MyInvocation.MyCommand.Path"
            # Invoke-Expression -Command $recreateCommand
        }
    }
}