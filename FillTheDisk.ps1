#------------------------------------------------------------------------------
#MIT License

#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:

#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.
#------------------------------------------------------------------------------

$FullFill_Disk = {
    param ($Disk)
    if ($Disk.Number -gt 1) {

    $Init=Initialize-Disk $Disk.Number –PartitionStyle GPT 
    $part=New-Partition -DiskNumber $Disk.Number -Size 999GB -AssignDriveLetter
    Write-host "Formatting"$part.DriveLetter
    $form=Format-Volume -DriveLetter $part.DriveLetter
    $dir=$part.DriveLetter+":\data"
    $Item=New-Item -ItemType Directory $dir
    $set=Set-Location $dir
    Write-host "Creating files in $dir ..."
    for($j=0; $j -lt 5; $j++)
    {
         $out = new-object byte[] 1073741824;
         (new-object Random).NextBytes($out); 
         $file=$dir+"\"+$([guid]::NewGuid().ToString())+".txt"
         Write-host $j"-"$file
         [IO.File]::WriteAllBytes($file, $out)
            
        }

    }
}

$Disks=Get-Disk

foreach ($disk in $Disks) {
    Start-Job -ScriptBlock $FullFill_Disk -ArgumentList $Disk 
}
