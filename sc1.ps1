$tempDir = "C:\temp"
$previousFilePath = ""

function Remove-Files {
    $path = $tempDir
    $files = Get-ChildItem -Path $path

    foreach ($file in $files) {
        $fileName = $file.Name
        $pattern = "\b\d{8}_\d{6}.jpg\b"

        if ($fileName -match $pattern) {
            Remove-Item -Path "$path\$fileName" -Force
            Write-Host "File $path\$fileName removed"
        }
    }
}

function Save-ClipboardImage {
    param($dirPath)
    $prePath = "C:\temp\test.jpg"


    while($true) {
        try {
            # Constructed timestamp
            $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
            $filename = "$timestamp.jpg"
            $filePath = Join-Path -Path $dirPath -ChildPath $filename

            $image = Get-Clipboard -Format Image

            if ($image -ne $null) {
                $image.Save($filePath, [System.Drawing.Imaging.ImageFormat]::Jpeg)
                Set-Clipboard
                Set-Clipboard -Path $filePath
                $result = (test-path "$prePath")
                if ($result) {
                    Remove-Item -Path "$prePath" -Force
                    Write-Host "File $prePath removed"
                }
                $prePath = $filePath

                $global:previousFilePath = $filePath
            } else {
                Start-Sleep -s 1
            }
            

        } catch {
            Write-Warning "An error has occurred. Restarting Save-ClipboardImage..."
            Start-Sleep -s 1
            Save-ClipboardImage -dirPath $dirPath
        }
    }
}

Remove-Files
Save-ClipboardImage -dirPath $tempDir
