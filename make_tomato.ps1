Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Bitmap]::FromFile('d:\Harvest Days\HarvestDays\sprites\spr_crop_tomato\eb3143a2-dd00-4a7c-b89b-6d898400b363.png')
$bmp = new-object System.Drawing.Bitmap($img)
for ($y=0; $y -lt $bmp.Height; $y++) {
    for ($x=0; $x -lt $bmp.Width; $x++) {
        $c = $bmp.GetPixel($x,$y)
        if ($c.A -gt 0) {
            $bmp.SetPixel($x,$y, [System.Drawing.Color]::FromArgb($c.A, [int]($c.R*0.7), [int]($c.G*0.7), [int]($c.B*0.7)))
        }
    }
}
$bmp.Save('d:\Harvest Days\HarvestDays\datafiles\CaChuaHangB.png')
$bmp.Dispose()
$img.Dispose()
