# Local Development

## Prerrequisitos

-   **Node.js**: Versión UNKNOWN (compatible con TypeScript 4.9.5 y Express 4.x)
-   **npm**: Gestor de paquetes (viene con Node.js)
-   **Docker Desktop**: Para ejecutar PostgreSQL
-   **Editor**: Cualquier editor de código (VS Code recomendado)

## Setup inicial

### 1. Clonar repositorio

```bash
git clone <repository-url>
cd AI4Devs-db-RO-202510
```

### 2. Instalar dependencias backend

```bash
cd backend
npm install
```

### 3. Instalar dependencias frontend

```bash
cd ../frontend
npm install
```

### 4. Configurar variables de entorno

Crear archivo `backend/.env`:

```env
DATABASE_URL="postgresql://postgres:password@localhost:5432/mydatabase"
```

**Nota**: Ajustar según configuración de `docker-compose.yml`:

-   Usuario: `DB_USER` (default: `postgres`)
-   Password: `DB_PASSWORD` (default: `password`)
-   Base de datos: `DB_NAME` (default: `mydatabase`)
-   Puerto: `DB_PORT` (default: `5432`)

### 5. Iniciar base de datos

Desde la raíz del proyecto:

```bash
docker-compose up -d
```

Verificar que el contenedor está corriendo:

```bash
docker-compose ps
```

### 6. Aplicar migraciones Prisma

```bash
cd backend
npx prisma migrate dev
```

Si no hay migraciones, generar el cliente Prisma:

```bash
npx prisma generate
```

### 7. Compilar backend

```bash
npm run build
```

## Ejecutar en desarrollo

### Backend

**Terminal 1**:

```bash
cd backend

# Modo desarrollo (hot reload)
npm run dev

# O modo producción
npm run build
npm start
```

Backend estará disponible en: `http://localhost:3010`

### Frontend

**Terminal 2**:

```bash
cd frontend
npm start
```

Frontend estará disponible en: `http://localhost:3000`

El navegador se abrirá automáticamente.

## Verificar que todo funciona

### 1. Health check backend

```bash
curl http://localhost:3010/
```

Debería retornar: `Hola LTI!`

### 2. Probar upload de archivo

```bash
curl -X POST http://localhost:3010/upload \
  -F "file=@/path/to/test.pdf"
```

Debería retornar:

```json
{
    "filePath": "uploads/1234567890-test.pdf",
    "fileType": "application/pdf"
}
```

### 3. Crear candidato (desde API)

```bash
curl -X POST http://localhost:3010/candidates \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "Test",
    "lastName": "User",
    "email": "test@example.com",
    "phone": "612345678",
    "educations": [],
    "workExperiences": [],
    "cv": {
      "filePath": "uploads/test.pdf",
      "fileType": "application/pdf"
    }
  }'
```

### 4. Verificar en base de datos

```bash
cd backend
npx prisma studio
```

Se abrirá Prisma Studio en el navegador (default: `http://localhost:5555`)

## Comandos útiles

### Backend

```bash
cd backend

# Desarrollo con hot reload
npm run dev

# Compilar TypeScript
npm run build

# Ejecutar tests
npm test

# Generar cliente Prisma
npx prisma generate

# Crear nueva migración
npx prisma migrate dev --name migration_name

# Abrir Prisma Studio (GUI para BD)
npx prisma studio

# Ver estado de migraciones
npx prisma migrate status

# Resetear base de datos (CUIDADO: borra datos)
npx prisma migrate reset
```

### Frontend

```bash
cd frontend

# Desarrollo
npm start

# Build producción
npm run build

# Tests
npm test

# Eject (irreversible, expone configuración)
npm run eject
```

### Docker

```bash
# Iniciar PostgreSQL
docker-compose up -d

# Detener PostgreSQL
docker-compose down

# Ver logs
docker-compose logs -f db

# Reiniciar contenedor
docker-compose restart db

# Ver estado
docker-compose ps
```

## Estructura de directorios de desarrollo

```
.
├── backend/
│   ├── src/              # Código fuente
│   ├── dist/             # Código compilado (después de build)
│   ├── prisma/
│   │   ├── schema.prisma
│   │   └── migrations/
│   ├── .env              # Variables de entorno (crear manualmente)
│   └── package.json
├── frontend/
│   ├── src/              # Código fuente
│   ├── build/            # Build de producción (después de build)
│   ├── public/
│   └── package.json
├── uploads/              # Archivos subidos (se crea automáticamente)
└── docker-compose.yml
```

## Troubleshooting

### Error: "Cannot connect to database"

**Causa**: PostgreSQL no está corriendo o DATABASE_URL incorrecta.

**Solución**:

1. Verificar que Docker está corriendo: `docker-compose ps`
2. Verificar variables de entorno en `backend/.env`
3. Verificar que el puerto no está en uso: `netstat -an | findstr 5432` (Windows)

### Error: "Port 3010 already in use"

**Causa**: Otro proceso está usando el puerto 3010.

**Solución**:

1. Encontrar proceso: `netstat -ano | findstr 3010` (Windows)
2. Matar proceso o cambiar puerto en `backend/src/index.ts`

### Error: "Port 3000 already in use"

**Causa**: Otro proceso está usando el puerto 3000 (común con Create React App).

**Solución**:

1. Cerrar otra instancia de React
2. O usar otro puerto: `PORT=3001 npm start` (Linux/Mac) o `set PORT=3001 && npm start` (Windows)

### Error: "Prisma Client not generated"

**Causa**: Cliente Prisma no se ha generado después de cambios en schema.

**Solución**:

```bash
cd backend
npx prisma generate
```

### Error: "Upload directory not found"

**Causa**: Directorio `../uploads/` no existe.

**Solución**:
Crear directorio manualmente:

```bash
# Desde backend/
mkdir ../uploads
```

O cambiar path en `fileUploadService.ts` a path absoluto.

### Error: "CORS error" en frontend

**Causa**: Backend no permite requests desde el origen del frontend.

**Solución**:
Verificar que CORS está configurado para `http://localhost:3000` en `backend/src/index.ts`

### Error: "Email already exists"

**Causa**: Intentando crear candidato con email duplicado.

**Solución**: Usar email diferente o eliminar candidato existente desde Prisma Studio.

## Hot reload

### Backend

Usando `ts-node-dev`:

-   Cambios en `.ts` se recargan automáticamente
-   No requiere reiniciar servidor manualmente

### Frontend

Create React App tiene hot reload por defecto:

-   Cambios en componentes se reflejan automáticamente
-   No requiere refresh manual del navegador

## Debugging

### Backend

1. **Logs en consola**: `console.log()` en código
2. **Debugger**: Configurar launch.json en VS Code para Node.js
3. **Prisma logs**: Añadir `log: ['query', 'info', 'warn', 'error']` en Prisma Client

### Frontend

1. **React DevTools**: Extensión de navegador
2. **Console del navegador**: Ver errores y logs
3. **Network tab**: Ver requests HTTP

## Base de datos

### Acceso directo

```bash
# Conectarse a PostgreSQL
psql -h localhost -p 5432 -U postgres -d mydatabase
```

O usar cualquier cliente PostgreSQL (pgAdmin, DBeaver, etc.) con:

-   Host: `localhost`
-   Port: `5432`
-   User: `postgres` (o valor de `DB_USER`)
-   Password: `password` (o valor de `DB_PASSWORD`)
-   Database: `mydatabase` (o valor de `DB_NAME`)

### Prisma Studio

GUI para ver y editar datos:

```bash
cd backend
npx prisma studio
```

Abre en: `http://localhost:5555`

## Testing local

### Backend

```bash
cd backend
npm test
```

Tests se ejecutan con Jest.

### Frontend

```bash
cd frontend
npm test
```

Tests se ejecutan con Jest + React Testing Library.

## Variables de entorno necesarias

### Backend

| Variable       | Descripción                  | Ejemplo                                    | Requerida |
| -------------- | ---------------------------- | ------------------------------------------ | --------- |
| `DATABASE_URL` | Connection string PostgreSQL | `postgresql://user:pass@localhost:5432/db` | Sí        |

### Frontend

No se detectan variables de entorno específicas.

### Docker Compose

| Variable      | Descripción         | Default |
| ------------- | ------------------- | ------- |
| `DB_PASSWORD` | Password PostgreSQL | -       |
| `DB_USER`     | Usuario PostgreSQL  | -       |
| `DB_NAME`     | Nombre de BD        | -       |
| `DB_PORT`     | Puerto mapeado      | -       |

## Notas importantes

1. **Uploads directory**: Se crea en `../uploads/` relativo a donde se ejecuta el backend. Puede causar problemas si se ejecuta desde diferentes directorios.

2. **Base de datos**: Los datos persisten en el volumen de Docker. Si se hace `docker-compose down -v`, se pierden los datos.

3. **Puertos**: Backend (3010) y Frontend (3000) deben estar libres.

4. **CORS**: Solo permite `http://localhost:3000`. Si se cambia el puerto del frontend, actualizar CORS en backend.
