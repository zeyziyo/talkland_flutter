# scripts/generate_materials_index.ps1
# Scan docs/materials/Korean and generate docs/materials_v3.json

$baseDir = "docs/materials/Korean"
$outputFile = "docs/materials_v3.json"
$categories = @("dialogues", "words", "sentences")

$materials = @()

foreach ($category in $categories) {
    $path = Join-Path $baseDir $category
    if (Test-Path $path) {
        $files = Get-ChildItem -Path $path -Filter "*.json"
        foreach ($file in $files) {
            try {
                $content = Get-Content -Path $file.FullName -Raw | ConvertFrom-Json
                
                $id = $file.BaseName
                $name = if ($content.subject) { $content.subject } else { $id }
                $description = if ($content.description) { $content.description } else { "$category material: $id" }
                
                # Normalize category names for display
                $displayCategory = switch ($category) {
                    "dialogues" { "Dialogue" }
                    "words" { "Words" }
                    "sentences" { "Sentences" }
                    default { $category }
                }

                $materials += @{
                    id          = $id
                    name        = $name
                    description = $description
                    category    = $displayCategory
                    path        = "$category/$($file.Name)"
                }
                Write-Host "Found: [$displayCategory] $name"
            }
            catch {
                Write-Warning "Failed to parse $($file.FullName): $_"
            }
        }
    }
}

$index = @{
    version    = "3.0"
    updated_at = (Get-Date -Format "yyyy-MM-dd")
    materials  = $materials
}

$index | ConvertTo-Json -Depth 10 | Out-File -FilePath $outputFile -Encoding utf8
Write-Host "`nSuccessfully generated $outputFile with $($materials.Count) materials."
