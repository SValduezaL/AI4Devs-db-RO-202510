# Scripts de utilidad

## sync-env.js / sync-env.ps1

Sincroniza el archivo `DATABASE_URL` del `.env` de la raíz al `backend/.env`.

### Uso

**Desde la raíz del proyecto:**

```bash
npm run sync-env
```

**Desde backend:**

```bash
cd backend
npm run sync-env
```

**Directamente con Node.js:**

```bash
node scripts/sync-env.js
```

**Directamente con PowerShell (Windows):**

```powershell
.\scripts\sync-env.ps1
```

### Qué hace

1. Lee el archivo `.env` de la raíz del proyecto
2. Extrae las variables: `DB_USER`, `DB_PASSWORD`, `DB_PORT`, `DB_NAME`
3. Construye el `DATABASE_URL` con el formato: `postgresql://${DB_USER}:${DB_PASSWORD}@localhost:${DB_PORT}/${DB_NAME}`
4. Crea/actualiza el archivo `backend/.env` con solo `DATABASE_URL`

### Cuándo usarlo

-   Después de cambiar variables en el `.env` de la raíz
-   Después de clonar el repositorio (si necesitas crear `backend/.env`)
-   Cuando Prisma no encuentra `DATABASE_URL` al ejecutar comandos desde `backend/`

### Notas

-   El archivo `backend/.env` está en `.gitignore` y no se versiona
-   El script valida que todas las variables requeridas estén presentes
-   Muestra un mensaje de confirmación al completar la sincronización
