
function pause() {
    Write-Host "Press any key to continue ..."
    cmd /c pause | out-null
}

$srcDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$outFileNm = "..\breeze.debug.js"
$outMinFileNm = "..\breeze.min.js"
$outBaseFileNm = "..\breeze.base.debug.js"
$outMinBaseFileNm = "..\breeze.base.min.js"

echo creating breeze.base.???.js
cat _head.jsfrag, a??_*.js, _tail.jsfrag > withBOM.tmp
$contents = Get-Content withBOM.tmp
# writes the file without the BOM ( which cause Uglify to fail if we don't)
[System.IO.File]::WriteAllLines($outBaseFileNm, $contents)
$expr = "uglifyjs " + $outBaseFileNm + " -mt -c -o " + $outMinBaseFileNm  
invoke-expression $expr

echo creating breeze.???.js
cat _head.jsfrag, a??_*.js, b??_*.*.js, _tail.jsfrag > withBOM.tmp
$contents = Get-Content withBOM.tmp
# writes the file without the BOM ( which cause Uglify to fail if we don't)
[System.IO.File]::WriteAllLines($outFileNm, $contents)
$expr = "uglifyjs " + $outFileNm + " -mt -c -o " + $outMinFileNm  
invoke-expression $expr

remove-item withBOM.tmp
Write-Host "completed."

# pause
