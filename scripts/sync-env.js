#!/usr/bin/env node
/**
 * Script de sincronización de .env
 * Sincroniza DATABASE_URL del .env de la raíz al backend/.env
 *
 * Uso: node scripts/sync-env.js
 */

const fs = require("fs");
const path = require("path");

console.log("🔄 Sincronizando .env...");

// Ruta del .env en la raíz
const rootEnvPath = path.join(__dirname, "..", ".env");
const backendEnvPath = path.join(__dirname, "..", "backend", ".env");

// Verificar que existe .env en la raíz
if (!fs.existsSync(rootEnvPath)) {
    console.error("❌ Error: No se encontró .env en la raíz del proyecto");
    process.exit(1);
}

// Leer y parsear .env de la raíz
const envContent = fs.readFileSync(rootEnvPath, "utf8");
const envVars = {};

envContent.split("\n").forEach((line) => {
    const trimmed = line.trim();
    if (trimmed && !trimmed.startsWith("#")) {
        const match = trimmed.match(/^([^=]+)=(.*)$/);
        if (match) {
            const key = match[1].trim();
            const value = match[2].trim().replace(/^["']|["']$/g, ""); // Remover comillas
            envVars[key] = value;
        }
    }
});

// Validar variables requeridas
// Distinguir entre variable faltante (undefined) y variable con valor vacío (string vacío)
const requiredVars = ["DB_USER", "DB_PASSWORD", "DB_PORT", "DB_NAME"];
const missingVars = requiredVars.filter((v) => !(v in envVars));

if (missingVars.length > 0) {
    console.error(
        `❌ Error: Faltan variables en .env: ${missingVars.join(", ")}`
    );
    process.exit(1);
}

// Validar que las variables no estén vacías (opcional, pero recomendado)
const emptyVars = requiredVars.filter((v) => envVars[v] === "");
if (emptyVars.length > 0) {
    console.warn(
        `⚠️  Advertencia: Variables con valor vacío en .env: ${emptyVars.join(", ")}`
    );
}

// Construir DATABASE_URL
const databaseUrl = `postgresql://${envVars.DB_USER}:${envVars.DB_PASSWORD}@localhost:${envVars.DB_PORT}/${envVars.DB_NAME}`;

// Crear backend/.env
const backendEnvContent = `DATABASE_URL="${databaseUrl}"\n`;

// Crear directorio backend si no existe
const backendDir = path.dirname(backendEnvPath);
if (!fs.existsSync(backendDir)) {
    fs.mkdirSync(backendDir, { recursive: true });
}

fs.writeFileSync(backendEnvPath, backendEnvContent, "utf8");

console.log("✅ Sincronización completada");
console.log(`   📁 Archivo creado: backend/.env`);
console.log(
    `   🔗 DATABASE_URL: postgresql://${envVars.DB_USER}:***@localhost:${envVars.DB_PORT}/${envVars.DB_NAME}`
);
