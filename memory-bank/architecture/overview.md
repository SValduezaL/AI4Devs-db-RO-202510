# Architecture Overview

## Estilo arquitectónico

**Arquitectura en capas (Layered Architecture)** con separación clara de responsabilidades:

```
┌─────────────────────────────────────┐
│      Presentation Layer             │
│  (Controllers, Routes, Middleware)   │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│      Application Layer               │
│  (Services, Validators, Business)    │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│      Domain Layer                    │
│  (Models, Business Entities)         │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│      Infrastructure Layer            │
│  (Prisma Client, File System)       │
└─────────────────────────────────────┘
```

## Componentes principales

### Backend

1. **Entry Point**: `backend/src/index.ts`

    - Configura Express
    - Middleware setup
    - Route registration
    - Server startup

2. **Routes**: `backend/src/routes/candidateRoutes.ts`

    - Define endpoints HTTP
    - Maneja requests/responses
    - Error handling básico

3. **Controllers**: `backend/src/presentation/controllers/candidateController.ts`

    - Extrae datos de request
    - Llama a servicios
    - Formatea respuestas HTTP

4. **Services**: `backend/src/application/services/`

    - `candidateService.ts`: Lógica de negocio de candidatos
    - `fileUploadService.ts`: Lógica de upload de archivos
    - `validator.ts`: Validaciones de datos

5. **Domain Models**: `backend/src/domain/models/`

    - `Candidate.ts`: Modelo de candidato con métodos de persistencia
    - `Education.ts`: Modelo de educación
    - `WorkExperience.ts`: Modelo de experiencia laboral
    - `Resume.ts`: Modelo de CV

6. **Database**: Prisma ORM
    - Schema: `backend/prisma/schema.prisma`
    - Migrations: `backend/prisma/migrations/`
    - Client: Generado automáticamente

### Frontend

1. **Entry Point**: `frontend/src/index.tsx`

    - Renderiza React app
    - Configura routing

2. **App Component**: `frontend/src/App.js` (NOTA: App.tsx existe pero no se usa, App.js es el activo)

    - Componente raíz
    - Configuración de rutas con React Router
    - Rutas: `/` (RecruiterDashboard), `/add-candidate` (AddCandidateForm)

3. **Components**: `frontend/src/components/`

    - `RecruiterDashboard.js`: Dashboard principal
    - `AddCandidateForm.js`: Formulario de candidato
    - `FileUploader.js`: Componente de upload

4. **Services**: `frontend/src/services/candidateService.js`
    - Comunicación con API backend
    - HTTP requests

## Flujo de datos

### Crear Candidato

```
User Input (Frontend)
  ↓
AddCandidateForm.js
  ↓
candidateService.js (HTTP POST)
  ↓
Express Router (index.ts)
  ↓
candidateRoutes.ts
  ↓
candidateController.ts
  ↓
candidateService.ts (backend)
  ↓
validator.ts (validación)
  ↓
Candidate.save() (domain model)
  ↓
Prisma Client
  ↓
PostgreSQL
```

### Upload de Archivo

```
User Selects File (Frontend)
  ↓
FileUploader.js
  ↓
HTTP POST /upload (multipart/form-data)
  ↓
fileUploadService.ts (multer)
  ↓
File System (../uploads/)
  ↓
Response: { filePath, fileType }
  ↓
Included in candidate data
```

## Decisiones arquitectónicas

### 1. Active Record en Domain Models

**Decisión**: Los modelos de dominio tienen métodos de instancia para persistencia (`save()`, `findOne()`)

**Razón**: Simplicidad y encapsulación de lógica de persistencia

**Trade-off**: Acoplamiento entre dominio e infraestructura (Prisma)

**Ubicación**: `backend/src/domain/models/*.ts`

### 2. Service Layer para orquestación

**Decisión**: Servicios orquestan validación, creación de modelos y persistencia en cascada

**Razón**: Separar lógica de negocio de controladores HTTP

**Ubicación**: `backend/src/application/services/candidateService.ts`

### 3. Validación en capa de aplicación

**Decisión**: Validación separada en `validator.ts` con funciones puras

**Razón**: Reutilizable y testeable

**Ubicación**: `backend/src/application/validator.ts`

### 4. Frontend como SPA

**Decisión**: React SPA con React Router

**Razón**: Experiencia de usuario fluida, separación frontend/backend

**Trade-off**: Requiere configuración de routing y manejo de estado

## Dependencias entre módulos

### Backend

```
index.ts
  ├── candidateRoutes.ts
  │     └── candidateController.ts
  │           └── candidateService.ts
  │                 ├── validator.ts
  │                 └── Candidate.ts (domain)
  │                       ├── Education.ts
  │                       ├── WorkExperience.ts
  │                       └── Resume.ts
  └── fileUploadService.ts
```

### Frontend

```
index.tsx
  └── App.tsx
        └── RecruiterDashboard.js
              └── AddCandidateForm.js
                    ├── FileUploader.js
                    └── candidateService.js
```

## Puntos de extensión

### Fácil de extender

1. **Nuevos endpoints**: Añadir rutas en `routes/` y controladores en `presentation/controllers/`
2. **Nuevos modelos**: Crear en `domain/models/` siguiendo patrón Active Record
3. **Nuevas validaciones**: Añadir funciones en `application/validator.ts`
4. **Nuevos componentes frontend**: Añadir en `components/` y rutas en `App.tsx`

### Requiere refactor

1. **Cambiar ORM**: Los modelos de dominio están acoplados a Prisma
2. **Añadir autenticación**: Requiere middleware y cambios en rutas
3. **Cambiar storage de archivos**: `fileUploadService.ts` usa multer con filesystem local

## Limitaciones actuales

1. **No hay separación de infraestructura**: Prisma está acoplado a modelos de dominio
2. **No hay inyección de dependencias**: Dependencias se importan directamente
3. **No hay eventos/eventos de dominio**: Todo es síncrono
4. **No hay capa de repositorio explícita**: Prisma actúa como repositorio implícito
