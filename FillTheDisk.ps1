$FullFill_Disk = {
    param ($Disk)
    if ($Disk.Number -gt 1) {

    $part=New-Partition -DiskNumber $Disk.Number -Size 999GB -AssignDriveLetter
    Write-host "Formatting"$part.DriveLetter
    $form=Format-Volume -DriveLetter $part.DriveLetter
    $dir=$part.DriveLetter+":\data"
    $Item=New-Item -ItemType Directory $dir
    $set=Set-Location $dir
    Write-host "Creating files in $dir ..."
    for($j=0; $j -lt 500; $j++)
    {
         $out = new-object byte[] 1073741824;
         (new-object Random).NextBytes($out); 
         $file=$dir+"\"+$([guid]::NewGuid().ToString())+".txt"
         Write-host $j"-"$file
         [IO.File]::WriteAllBytes($file, $out)
            
        }

    }
}

