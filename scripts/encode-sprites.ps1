
$iconlibrary = "C:\Users\javen\Downloads\gcp-icons\GCP Icons\Products and services"

Write-Output "Encoding sprites from GCP icon library..."

Add-Type -AssemblyName System.Drawing
[int32]$new_width = 70
[int32]$new_height = 70
$cwd = Get-Location
$template_dir = Join-Path -Path (Split-Path -Path $cwd -Parent) -ChildPath "templates"
 
# iterate through GCP icons dir
foreach ($file in Get-ChildItem -Path $iconlibrary -Recurse –File | where Extension -eq ".png") {
	$resourceName = $file.Name.replace(".png","").replace(" ", "")
	$serviceName = (Split-Path (Split-Path $file.FullName -Parent) -leaf).replace(" ", "")
	$inputFullName = $file.FullName
	$inputFileName = $file.Name

	Write-Output "Creating sprite and PUML file for ${serviceName}/${resourceName}"	
	
	# create service dir in templates dir if it doesnt exist
	New-Item -ItemType Directory -Force -Path (Join-Path -Path $template_dir -ChildPath $serviceName) | Out-Null	
	$outputImageFile = Join-Path -Path (Join-Path -Path $template_dir -ChildPath $serviceName) -ChildPath "${resourceName}.png"
	
	# resize image to 70x70
	$img = [System.Drawing.Image]::FromFile((Get-Item $inputFullName))
	$img2 = New-Object System.Drawing.Bitmap($new_width, $new_height)
	$graph = [System.Drawing.Graphics]::FromImage($img2)
	$graph.DrawImage($img, 0, 0, $new_width, $new_height)
	$img2.Save($outputImageFile)
	
	# encode sprite
	$spriteObj = java -jar "${cwd}\plantuml.jar" -encodesprite 16z "${outputImageFile}"
	$spriteStr = $spriteObj | Out-String

	# remove resized png file
	Remove-Item $outputImageFile
	
	# create PUML file
	$pumlFile = Join-Path -Path (Join-Path -Path $template_dir -ChildPath $serviceName) -ChildPath "${resourceName}.puml"
	New-Item $pumlFile -ItemType File -Force -Value $spriteStr | Out-Null
	Add-Content $pumlFile "GCPEntityColoring(${resourceName})"
	Add-Content $pumlFile "!define ${resourceName}(e_alias, e_label, e_techn) GCPEntity(e_alias, e_label, e_techn, GCP_SYMBOL_COLOR, ${resourceName}, ${resourceName})"
	Add-Content $pumlFile "!define ${resourceName}(e_alias, e_label, e_techn, e_descr) GCPEntity(e_alias, e_label, e_techn, e_descr, GCP_SYMBOL_COLOR, ${resourceName}, ${resourceName})"
}