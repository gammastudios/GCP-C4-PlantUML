
$iconlibrary = "..\icons"

Write-Output "Encoding sprites from GCP icon library..."

Add-Type -AssemblyName System.Drawing
[int32]$new_width = 70
[int32]$new_height = 70
[int32]$new_width_part = 50
[int32]$new_height_part = 50
$cwd = Get-Location
$template_dir = Join-Path -Path (Split-Path -Path $cwd -Parent) -ChildPath "templates"
 
# iterate through GCP icons dir
foreach ($file in Get-ChildItem -Path $iconlibrary -Recurse –File | Where-Object Extension -eq ".png") {
$resourceName = $file.Name.replace(".png","").replace(" ", "").replace("-", "")
$serviceName = (Split-Path (Split-Path $file.FullName -Parent) -leaf).replace(" ", "").replace("-", "")
$inputFullName = $file.FullName
#$inputFileName = $file.Name

Write-Output "Creating sprite and PUML file for ${serviceName}/${resourceName}"	

# create service dir in templates dir if it doesnt exist
New-Item -ItemType Directory -Force -Path (Join-Path -Path $template_dir -ChildPath $serviceName) | Out-Null	
$outputImageFile = Join-Path -Path (Join-Path -Path $template_dir -ChildPath $serviceName) -ChildPath "${resourceName}.png"
$outputImageFilePart = Join-Path -Path (Join-Path -Path $template_dir -ChildPath $serviceName) -ChildPath "${resourceName}Participant.png"

## regular sized image
# resize image to 70x70
$img = [System.Drawing.Image]::FromFile((Get-Item $inputFullName))
$img2 = New-Object System.Drawing.Bitmap($new_width, $new_height)
$graph = [System.Drawing.Graphics]::FromImage($img2)
$graph.Clear([System.Drawing.Color]::White)
$graph.DrawImage($img, 0, 0, $new_width, $new_height)
$img2.Save($outputImageFile)

# encode sprite
$spriteObj = java -jar "${cwd}\plantuml.jar" -encodesprite 4z "${outputImageFile}"
$spriteStr = $spriteObj | Out-String
$partResourceName = "${resourceName}Participant"

# remove resized png file
Remove-Item $outputImageFile

## participant sized image (for sequence diagrams)
# resize image to 30x30
$img = [System.Drawing.Image]::FromFile((Get-Item $inputFullName))
$img2 = New-Object System.Drawing.Bitmap($new_width_part, $new_height_part)
$graph = [System.Drawing.Graphics]::FromImage($img2)
$graph.Clear([System.Drawing.Color]::White)
$graph.DrawImage($img, 0, 0, $new_width_part, $new_height_part)
$img2.Save($outputImageFilePart)

# encode sprite
$spriteObj = java -jar "${cwd}\plantuml.jar" -encodesprite 4z "${outputImageFilePart}"
$spriteStrPart = $spriteObj | Out-String

# remove resized png file
Remove-Item $outputImageFilePart

# create PUML file
$pumlFile = Join-Path -Path (Join-Path -Path $template_dir -ChildPath $serviceName) -ChildPath "${resourceName}.puml"
New-Item $pumlFile -ItemType File -Force -Value $spriteStr | Out-Null
$Str = $spriteStrPart
Add-Content -Path $pumlFile -Value $Str
$Str = "!define ${resourceName}(e_alias, e_label, e_techn) GCPEntity(e_alias, e_label, e_techn, GCP_SYMBOL_COLOR, ${resourceName}, resource)"
Add-Content -Path $pumlFile -Value $Str
$Str = "!define ${resourceName}(e_alias, e_label, e_techn, e_descr) GCPEntity(e_alias, e_label, e_techn, e_descr, GCP_SYMBOL_COLOR, ${resourceName}, resource)"
Add-Content -Path $pumlFile -Value $Str
$Str = "!define ${partResourceName}(p_alias, p_label, p_techn) GCPParticipant(p_alias, p_label, p_techn, GCP_SYMBOL_COLOR, ${partResourceName}, ${partResourceName})"
Add-Content -Path $pumlFile -Value $Str
$Str = "!define ${partResourceName}(p_alias, p_label, p_techn, p_descr) GCPParticipant(p_alias, p_label, p_techn, p_descr, GCP_SYMBOL_COLOR, ${partResourceName}, ${partResourceName})"
Add-Content -Path $pumlFile -Value $Str
}