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
if (-not $dbUser -or -not $dbPassword -or -not $dbPort -or -not $dbName) {
    Write-Host "❌ Error: Faltan variables en .env (DB_USER, DB_PASSWORD, DB_PORT, DB_NAME)" -ForegroundColor Red
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

