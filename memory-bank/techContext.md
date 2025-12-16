# Tech Context

## Stack tecnológico

### Backend

-   **Runtime**: Node.js
-   **Lenguaje**: TypeScript 4.9.5
-   **Framework**: Express 4.19.2
-   **ORM**: Prisma 5.13.0
-   **Base de datos**: PostgreSQL (via Docker)
-   **File upload**: Multer 1.4.5-lts.1
-   **API Docs**: Swagger (swagger-jsdoc 6.2.8, swagger-ui-express 5.0.0)
-   **Testing**: Jest 29.7.0 + ts-jest 29.2.5
-   **Linting**: ESLint 9.2.0 + Prettier 3.2.5
-   **Dev tools**: ts-node-dev 1.1.6 (hot reload)

### Frontend

-   **Framework**: React 18.3.1
-   **Lenguaje**: TypeScript 4.9.5 (parcial, algunos archivos .js)
-   **Build tool**: Create React App (react-scripts 5.0.1)
-   **UI Library**: React Bootstrap 2.10.2 + Bootstrap 5.3.3
-   **Icons**: react-bootstrap-icons 1.11.4
-   **Date picker**: react-datepicker 6.9.0
-   **Routing**: react-router-dom 6.23.1
-   **Testing**: @testing-library/react 13.4.0 + Jest

### Infraestructura

-   **Containerización**: Docker Compose
-   **Base de datos**: PostgreSQL (imagen oficial)
-   **Gestor de paquetes**: npm (detectado package-lock.json)

## Dependencias clave y para qué

### Backend

| Dependencia          | Versión     | Propósito                          |
| -------------------- | ----------- | ---------------------------------- |
| `express`            | 4.19.2      | Framework web HTTP                 |
| `@prisma/client`     | 5.13.0      | Cliente ORM para queries           |
| `prisma`             | 5.13.0      | CLI para migraciones y generación  |
| `multer`             | 1.4.5-lts.1 | Middleware para upload de archivos |
| `cors`               | 2.8.5       | Middleware CORS                    |
| `dotenv`             | 16.4.5      | Carga variables de entorno         |
| `swagger-jsdoc`      | 6.2.8       | Generación de docs OpenAPI         |
| `swagger-ui-express` | 5.0.0       | UI de Swagger                      |
| `typescript`         | 4.9.5       | Compilador TypeScript              |
| `ts-node-dev`        | 1.1.6       | Dev server con hot reload          |
| `jest`               | 29.7.0      | Framework de testing               |
| `ts-jest`            | 29.2.5      | Preset Jest para TypeScript        |

### Frontend

| Dependencia        | Versión | Propósito                            |
| ------------------ | ------- | ------------------------------------ |
| `react`            | 18.3.1  | Biblioteca UI                        |
| `react-dom`        | 18.3.1  | Renderizado React                    |
| `react-router-dom` | 6.23.1  | Routing SPA                          |
| `react-bootstrap`  | 2.10.2  | Componentes Bootstrap para React     |
| `bootstrap`        | 5.3.3   | Framework CSS                        |
| `react-datepicker` | 6.9.0   | Componente de selección de fechas    |
| `react-scripts`    | 5.0.1   | Scripts y config de Create React App |

## Setup local exacto

### Prerrequisitos

-   Node.js (versión UNKNOWN, pero compatible con TypeScript 4.9.5)
-   npm (gestor de paquetes)
-   Docker y Docker Compose (para PostgreSQL)

### Pasos de instalación

```bash
# 1. Clonar repositorio (asumido)

# 2. Instalar dependencias backend
cd backend
npm install

# 3. Instalar dependencias frontend
cd ../frontend
npm install

# 4. Configurar variables de entorno
# Crear .env en backend/ con:
# DATABASE_URL="postgresql://user:password@localhost:5432/mydatabase"

# 5. Iniciar base de datos
cd ..
docker-compose up -d

# 6. Aplicar migraciones Prisma
cd backend
npx prisma migrate dev
# O si no hay migraciones:
npx prisma generate

# 7. Compilar backend
npm run build

# 8. Iniciar backend (terminal 1)
npm start
# O en modo desarrollo:
npm run dev

# 9. Iniciar frontend (terminal 2)
cd ../frontend
npm start
```

### Comandos útiles

**Backend**:

```bash
cd backend

# Desarrollo con hot reload
npm run dev

# Compilar TypeScript
npm run build

# Ejecutar producción
npm start

# Tests
npm test

# Prisma
npx prisma generate        # Generar cliente Prisma
npx prisma migrate dev     # Crear y aplicar migración
npx prisma studio          # Abrir Prisma Studio (GUI)
```

**Frontend**:

```bash
cd frontend

# Desarrollo
npm start                  # http://localhost:3000

# Build producción
npm run build

# Tests
npm test
```

**Docker**:

```bash
# Iniciar PostgreSQL
docker-compose up -d

# Detener PostgreSQL
docker-compose down

# Ver logs
docker-compose logs -f db
```

## Config/Env: Variables de entorno

### Backend (.env)

Variables detectadas en código:

| Variable       | Descripción                  | Ejemplo                                    | Ubicación                                      |
| -------------- | ---------------------------- | ------------------------------------------ | ---------------------------------------------- |
| `DATABASE_URL` | Connection string PostgreSQL | `postgresql://user:pass@localhost:5432/db` | `backend/prisma/schema.prisma`, `backend/.env` |

### Docker Compose (docker-compose.yml)

Variables detectadas:

| Variable      | Descripción                | Default (si no se setea) |
| ------------- | -------------------------- | ------------------------ |
| `DB_PASSWORD` | Password de PostgreSQL     | -                        |
| `DB_USER`     | Usuario de PostgreSQL      | -                        |
| `DB_NAME`     | Nombre de la base de datos | -                        |
| `DB_PORT`     | Puerto de PostgreSQL       | 5432 (mapeado)           |

**Nota**: No se detecta archivo `.env.example`, por lo que las variables exactas son UNKNOWN. Se infieren del `docker-compose.yml` y uso de `DATABASE_URL` en Prisma.

### Frontend

No se detectan variables de entorno específicas en el código frontend.

## Restricciones y limitaciones

### Versiones

-   **TypeScript**: 4.9.5 (no ES2020+, usa ES5 target)
-   **Node.js**: UNKNOWN (compatible con Express 4.x y Prisma 5.x)
-   **PostgreSQL**: Versión de imagen Docker UNKNOWN (imagen oficial `postgres`)

### Compatibilidades

-   **Backend**: CommonJS modules (`"module": "commonjs"` en tsconfig)
-   **Frontend**: ES modules (`"module": "esnext"` en tsconfig)
-   **Prisma**: Binary targets incluyen `debian-openssl-3.0.x` (para deployment Linux)

### Limitaciones de entorno

1. **CORS**: Configurado solo para `http://localhost:3000`

    - **Riesgo**: No funciona desde otros orígenes
    - **Ubicación**: `backend/src/index.ts`

2. **Upload path**: Hardcoded a `../uploads/`

    - **Riesgo**: Path relativo puede fallar según dónde se ejecute
    - **Ubicación**: `backend/src/application/services/fileUploadService.ts`

3. **Puerto backend**: Hardcoded a `3010`

    - **Ubicación**: `backend/src/index.ts`

4. **Puerto frontend**: `3000` (default de Create React App)

    - Configurable via variable de entorno `PORT` (UNKNOWN si se usa)

5. **Base de datos**: Requiere Docker o PostgreSQL local
    - No hay alternativa sin Docker documentada

### Dependencias de runtime

-   **PostgreSQL**: Debe estar corriendo antes de iniciar backend
-   **Prisma Client**: Debe generarse con `npx prisma generate` después de cambios en schema

## Configuraciones de build

### Backend (tsconfig.json)

```json
{
    "target": "es5",
    "module": "commonjs",
    "outDir": "./dist",
    "strict": true
}
```

**Output**: `backend/dist/`

### Frontend (tsconfig.json)

```json
{
    "target": "es5",
    "module": "esnext",
    "jsx": "react-jsx"
}
```

**Output**: `frontend/build/` (Create React App)

## Herramientas de desarrollo

-   **ESLint**: Configurado en backend (UNKNOWN: configuración exacta)
-   **Prettier**: Configurado en backend (UNKNOWN: configuración exacta)
-   **Jest**: Configurado para backend y frontend
-   **Prisma Studio**: Disponible via `npx prisma studio` (GUI para BD)

## Observaciones técnicas

1. **Mezcla JS/TS**: Frontend tiene archivos `.js` y `.tsx` (migración parcial)
2. **No hay CI/CD**: No se detectan archivos de GitHub Actions, GitLab CI, etc.
3. **No hay Dockerfile**: Solo `docker-compose.yml` para BD, no para app
4. **No hay health checks**: No se detectan endpoints de health
5. **Logging básico**: Solo `console.log` para requests
