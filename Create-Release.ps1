param(
    [Parameter(Mandatory = $true)]
    [string]$StatusVersion,
    
    [Parameter(Mandatory = $true)]
    [string]$OriginalVersion,
    
    [Parameter(Mandatory = $true)]
    [string]$Environment,
    
    [Parameter(Mandatory = $true)]
    [string]$Status,
    
    [Parameter(Mandatory = $false)]
    [string]$ArtifactUrls = '[]',
    
    [Parameter(Mandatory = $false)]
    [bool]$IsPrerelease = $true,
    
    [Parameter(Mandatory = $true)]
    [string]$GitHubToken,
    
    [Parameter(Mandatory = $true)]
    [string]$Repository,
    
    [Parameter(Mandatory = $true)]
    [string]$ServerUrl,
    
    [Parameter(Mandatory = $true)]
    [string]$RunId,
    
    [Parameter(Mandatory = $true)]
    [string]$CommitSha,
    
    [Parameter(Mandatory = $true)]
    [string]$Actor
)

Write-Host "🚀 Creating GitHub release for $Environment $Status..." -ForegroundColor Yellow
Write-Host "📦 Status Version: $StatusVersion" -ForegroundColor Cyan
Write-Host "🏷️ Original Version: $OriginalVersion" -ForegroundColor Cyan
Write-Host "🌍 Environment: $Environment" -ForegroundColor Cyan
Write-Host "📊 Status: $Status" -ForegroundColor Cyan
Write-Host "🔖 Is Prerelease: $IsPrerelease" -ForegroundColor Cyan

try {
    # Parse artifact URLs
    $artifacts = @()
    if ($ArtifactUrls -and $ArtifactUrls -ne '[]') {
        try {
            $parsedUrls = $ArtifactUrls | ConvertFrom-Json
            $artifacts = $parsedUrls
            Write-Host "📋 Found $($artifacts.Count) artifact(s)" -ForegroundColor Green
        }
        catch {
            Write-Host "⚠️ Could not parse artifact URLs, proceeding without artifacts" -ForegroundColor Yellow
        }
    }

    # Determine status icon and description
    $statusIcon = switch ($Status.ToLower()) {
        "deployed" { "🚀" }
        "passed" { "✅" }
        "failed" { "❌" }
        default { "📊" }
    }

    # Create release title and body
    $releaseTitle = "$statusIcon $Environment $Status - $StatusVersion"
    
    $releaseBody = @"
# $statusIcon $Environment $Status

**Original Version:** $OriginalVersion  
**Status Version:** $StatusVersion  
**Environment:** $Environment  
**Status:** $Status  
**Workflow:** [$RunId]($ServerUrl/$Repository/actions/runs/$RunId)  
**Commit:** [$($CommitSha.Substring(0,7))]($ServerUrl/$Repository/commit/$CommitSha)  
**Actor:** $Actor  

"@

    # Add artifacts section if any
    if ($artifacts.Count -gt 0) {
        $releaseBody += @"
## 📦 Artifacts

"@
        foreach ($artifact in $artifacts) {
            $releaseBody += "- $artifact`n"
        }
        $releaseBody += "`n"
    }

    # Add timestamp
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss UTC"
    $releaseBody += "---`n*Created: $timestamp*"

    Write-Host "📝 Release Title: $releaseTitle" -ForegroundColor Green
    Write-Host "📄 Creating release with GitHub CLI..." -ForegroundColor Yellow

    # Create the release using GitHub CLI
    $releaseArgs = @(
        "release", "create", $StatusVersion,
        "--title", $releaseTitle,
        "--notes", $releaseBody,
        "--repo", $Repository
    )

    if ($IsPrerelease) {
        $releaseArgs += "--prerelease"
    }

    $releaseOutput = & gh @releaseArgs 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        $releaseUrl = $releaseOutput.Trim()
        Write-Host "✅ Successfully created release: $releaseUrl" -ForegroundColor Green
        
        # Set output for GitHub Actions
        "release-url=$releaseUrl" >> $env:GITHUB_OUTPUT
        Write-Host "📤 Set output: release-url=$releaseUrl" -ForegroundColor Yellow
    }
    else {
        Write-Error "❌ Failed to create release. GitHub CLI output: $releaseOutput"
        exit 1
    }
}
catch {
    Write-Error "❌ Error creating release: $_"
    Write-Error $_.ScriptStackTrace
    exit 1
}