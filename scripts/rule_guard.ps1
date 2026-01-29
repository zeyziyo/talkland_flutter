# verify_rules.ps1
param (
    [string]$Command
)

$forbidden = @("flutter build", "flutter run", "flutter clean")

foreach ($word in $forbidden) {
    if ($Command.ToLower().Contains($word)) {
        Write-Error "🛑 VIOLATION DETECTED: Local build/run commands are STRICTLY FORBIDDEN by PROJECT_RULES.md."
        Write-Error "Forbidden command: $Command"
        Write-Error "Use CI/CD (git push / /build_release) instead."
        exit 1
    }
}

Write-Host "✅ [RULE GUARD] Command validated. Executing... ($Command)"
Invoke-Expression $Command
exit $LASTEXITCODE
