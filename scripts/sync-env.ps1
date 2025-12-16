# Script de sincronización de .env
# Sincroniza DATABASE_URL del .env de la raíz al backend/.env

$ErrorActionPreference = "Stop"

Write-Host "🔄 Sincronizando .env..." -ForegroundColor Cyan

# Verificar que existe .env en la raíz
$rootEnvPath = Join-Path $PSScriptRoot "..\.env"
if (-not (Test-Path $rootEnvPath)) {
    Write-Host "❌ Error: No se encontró .env en la raíz del proyecto" -ForegroundColor Red
    exit 1
}

# Leer variables del .env de la raíz
$envContent = Get-Content $rootEnvPath
$dbUser = ""
$dbPassword = ""
$dbPort = ""
$dbName = ""

foreach ($line in $envContent) {
    if ($line -match "^DB_USER=(.+)$") {
        $dbUser = $matches[1]
    }
    elseif ($line -match "^DB_PASSWORD=(.+)$") {
        $dbPassword = $matches[1]
    }
    elseif ($line -match "^DB_PORT=(.+)$") {
        $dbPort = $matches[1]
    }
    elseif ($line -match "^DB_NAME=(.+)$") {
        $dbName = $matches[1]
    }
}

# Validar que todas las variables estén presentes
# Usar -eq $null para distinguir entre variable faltante y variable con valor vacío
$missingVars = @()
if ($null -eq $dbUser -or $dbUser -eq "") { $missingVars += "DB_USER" }
if ($null -eq $dbPassword -or $dbPassword -eq "") { $missingVars += "DB_PASSWORD" }
if ($null -eq $dbPort -or $dbPort -eq "") { $missingVars += "DB_PORT" }
if ($null -eq $dbName -or $dbName -eq "") { $missingVars += "DB_NAME" }

if ($missingVars.Count -gt 0) {
    Write-Host "❌ Error: Faltan o están vacías las siguientes variables en .env: $($missingVars -join ', ')" -ForegroundColor Red
    exit 1
}

# Construir DATABASE_URL
$databaseUrl = "postgresql://${dbUser}:${dbPassword}@localhost:${dbPort}/${dbName}"

# Crear backend/.env
$backendEnvPath = Join-Path $PSScriptRoot "..\backend\.env"
$backendEnvContent = "DATABASE_URL=`"$databaseUrl`""

Set-Content -Path $backendEnvPath -Value $backendEnvContent -Encoding UTF8

Write-Host "✅ Sincronización completada" -ForegroundColor Green
Write-Host "   📁 Archivo creado: backend\.env" -ForegroundColor Gray
Write-Host "   🔗 DATABASE_URL: postgresql://${dbUser}:***@localhost:${dbPort}/${dbName}" -ForegroundColor Gray

