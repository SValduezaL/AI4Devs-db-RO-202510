# Progress

## Qué funciona hoy

### Backend

✅ **API REST operativa**

-   Endpoint `POST /candidates` - Crear candidato
-   Endpoint `GET /candidates/:id` - Obtener candidato por ID
-   Endpoint `POST /upload` - Subir archivo (PDF/DOCX)
-   Endpoint `GET /` - Health básico ("Hola LTI!")

✅ **Validación de datos**

-   Validación de nombres (regex, longitud)
-   Validación de email (formato)
-   Validación de teléfono (formato español)
-   Validación de fechas (formato YYYY-MM-DD)
-   Validación de educación y experiencia
-   Validación de archivos (tipo y tamaño)

✅ **Base de datos**

-   Schema Prisma definido y expandido (2025-12-16)
-   Modelos originales: Candidate, Education, WorkExperience, Resume
-   Nuevos modelos (2025-12-16): Company, Employee, Position, InterviewFlow, InterviewStep, InterviewType, Application, Interview
-   Relaciones configuradas con constraints apropiados
-   Timestamps (createdAt, updatedAt) en todas las tablas
-   Índices en foreign keys y columnas de búsqueda frecuente
-   Script SQL de referencia: `backend/prisma/migrations/erd_to_sql.sql`
-   ✅ **Migración aplicada (2025-12-16)**: `20251216224021_expand_database_with_interview_entities`
-   Puerto de base de datos: 5433 (cambiado desde 5432 para evitar conflictos)

✅ **Tests unitarios**

-   `candidateService.test.ts` - Tests de servicio
-   `candidateController.test.ts` - Tests de controlador
-   `validator.test.ts` - Tests de validación
-   `Education.test.ts` - Tests de modelo

✅ **File upload**

-   Multer configurado
-   Validación de tipo (PDF/DOCX)
-   Límite de tamaño (10MB)
-   Almacenamiento en `../uploads/`

### Frontend

✅ **Dashboard**

-   Componente `RecruiterDashboard` funcional
-   Navegación con React Router
-   Logo LTI integrado

✅ **Formulario de candidato**

-   Componente `AddCandidateForm` implementado
-   Integración con backend API
-   Upload de archivos funcional

✅ **UI/UX básica**

-   React Bootstrap integrado
-   Componentes visuales básicos
-   Navegación entre pantallas

### Infraestructura

✅ **Docker Compose**

-   PostgreSQL containerizado
-   Configuración de variables de entorno
-   Puerto mapeado correctamente

✅ **Build system**

-   TypeScript compila correctamente
-   Frontend build funcional
-   Scripts npm configurados

## Cambios recientes (2025-12-16)

✅ **Expansión de base de datos completada (2025-12-16)**:

-   Schema Prisma actualizado con 8 nuevas entidades del ERD
-   Buenas prácticas aplicadas: normalización 3NF, índices, constraints, timestamps
-   Reglas de base de datos documentadas en `.cursor/rules/database-standards.mdc`
-   Script SQL de referencia generado
-   Documentación de migración creada
-   ✅ **Migración aplicada**: `20251216224021_expand_database_with_interview_entities`
-   ✅ **Puerto actualizado**: Cambiado a 5433 para resolver conflicto de puertos

## Qué falta / TODOs detectados

### Funcionalidad faltante

1. **Listado de candidatos**

    - No existe `GET /candidates` (solo por ID)
    - Frontend no muestra lista de candidatos
    - **Ubicación**: `backend/src/routes/candidateRoutes.ts`

2. **Búsqueda de candidatos**

    - No hay endpoint de búsqueda
    - No hay filtros
    - **Impacto**: Alto para UX

3. **Edición de candidatos**

    - No existe `PUT /candidates/:id` o `PATCH /candidates/:id`
    - Modelo `Candidate.save()` soporta update pero no hay endpoint
    - **Ubicación**: `backend/src/domain/models/Candidate.ts` (método existe)

4. **Eliminación de candidatos**

    - No existe `DELETE /candidates/:id`
    - **Impacto**: Medio

5. **Visualización de CVs**
    - No hay endpoint para descargar/ver CVs
    - Frontend no muestra CVs subidos
    - **Impacto**: Alto para funcionalidad completa

### Tests faltantes

6. **Tests de integración**

    - Solo tests unitarios
    - No hay tests E2E
    - **Ubicación**: No existe carpeta de tests de integración

7. **Tests frontend**

    - Configuración existe pero no se detectan tests escritos
    - **Ubicación**: `frontend/src/` (no hay archivos `*.test.js` o `*.test.tsx`)

8. **Tests de file upload**
    - No se detectan tests para `fileUploadService`
    - **Ubicación**: `backend/src/application/services/fileUploadService.ts`

### Mejoras técnicas

9. **Variables de entorno**

    - Puerto hardcoded (3010)
    - CORS origin hardcoded (`http://localhost:3000`)
    - Upload path hardcoded (`../uploads/`)
    - **Ubicación**: `backend/src/index.ts`, `fileUploadService.ts`

10. **Manejo de errores frontend**

    - No se detecta código de manejo de errores en componentes
    - **Ubicación**: `frontend/src/components/`

11. **Logging estructurado**

    - Solo `console.log` básico
    - No hay niveles de log (info, error, warn)
    - **Ubicación**: `backend/src/index.ts`

12. **Health check endpoint**

    - Solo existe `GET /` con mensaje básico
    - No verifica conexión a BD
    - **Impacto**: Bajo-Medio

13. **Swagger UI**

    - `api-spec.yaml` existe
    - Dependencias instaladas (swagger-ui-express)
    - No se detecta endpoint `/api-docs` configurado
    - **Ubicación**: `backend/src/index.ts`

14. **Validación de fechas lógica**
    - No valida que `endDate > startDate`
    - Solo valida formato
    - **Ubicación**: `backend/src/application/validator.ts`

### Infraestructura

15. **Dockerfile para aplicación**

    -   Solo docker-compose para BD
    -   No hay containerización de app
    -   **Impacto**: Bajo (solo necesario para deployment)

16. **CI/CD**

    -   No se detectan pipelines
    -   No hay automatización de tests
    -   **Impacto**: Medio

17. **Backup strategy**
    -   No detectado sistema de backup
    -   **Impacto**: Alto para producción

## Known issues

### Errores comunes

1. **Path de upload relativo**

    - **Problema**: `../uploads/` puede fallar según dónde se ejecute
    - **Solución sugerida**: Usar path absoluto o variable de entorno
    - **Ubicación**: `backend/src/application/services/fileUploadService.ts:6`

2. **CORS restrictivo**

    - **Problema**: Solo permite `http://localhost:3000`
    - **Impacto**: No funciona desde otros orígenes
    - **Solución sugerida**: Configurar via variable de entorno
    - **Ubicación**: `backend/src/index.ts:34-37`

3. **Error handler genérico**

    - **Problema**: Retorna texto plano en lugar de JSON
    - **Impacto**: Inconsistente con resto de API
    - **Ubicación**: `backend/src/index.ts:56-60`

4. **Prisma Client no cerrado**
    - **Problema**: No se detecta `prisma.$disconnect()` en shutdown
    - **Impacto**: Conexiones pueden quedar abiertas
    - **Ubicación**: `backend/src/index.ts:19`

### Deuda técnica

5. **Mezcla JS/TS en frontend**

    - Archivos `.js` y `.tsx` mezclados
    - **Impacto**: Bajo (consistencia)
    - **Solución**: Migrar a TypeScript completo

6. **Duplicación de lógica de validación**

    - Validación en `validator.ts` y también en `api-spec.yaml`
    - **Impacto**: Bajo (mantenimiento)
    - **Solución**: Generar validación desde OpenAPI spec

7. **Falta de tipos en algunos lugares**

    - Uso de `any` en algunos servicios
    - **Ubicación**: `backend/src/application/services/candidateService.ts:7`
    - **Impacto**: Bajo (type safety)

8. **No hay rate limiting**

    - API expuesta sin límites de requests
    - **Impacto**: Medio (seguridad/abuso)

9. **No hay sanitización de archivos**
    - Archivos se guardan sin escaneo de malware
    - **Impacto**: Medio-Alto (seguridad)

## Quick wins (3-10)

1. **Añadir endpoint GET /candidates** (listado)

    - Esfuerzo: Bajo (1-2 horas)
    - Impacto: Alto
    - Archivos: `backend/src/routes/candidateRoutes.ts`, `candidateService.ts`

2. **Configurar Swagger UI**

    - Esfuerzo: Muy bajo (30 min)
    - Impacto: Medio (developer experience)
    - Archivos: `backend/src/index.ts`

3. **Health check mejorado**

    - Esfuerzo: Bajo (1 hora)
    - Impacto: Bajo-Medio
    - Archivos: `backend/src/index.ts`

4. **Variables de entorno para configuración**

    - Esfuerzo: Bajo (1-2 horas)
    - Impacto: Medio
    - Archivos: `backend/src/index.ts`, `fileUploadService.ts`

5. **Validación de fechas lógica**

    - Esfuerzo: Muy bajo (30 min)
    - Impacto: Medio
    - Archivos: `backend/src/application/validator.ts`

6. **Error handler JSON**

    - Esfuerzo: Muy bajo (15 min)
    - Impacto: Bajo
    - Archivos: `backend/src/index.ts:56-60`

7. **Cerrar Prisma Client en shutdown**

    - Esfuerzo: Bajo (30 min)
    - Impacto: Bajo-Medio
    - Archivos: `backend/src/index.ts`

8. **Tests básicos frontend**

    - Esfuerzo: Medio (2-3 horas)
    - Impacto: Medio
    - Archivos: `frontend/src/components/*.test.tsx`

9. **Endpoint para descargar CVs**

    - Esfuerzo: Bajo (1 hora)
    - Impacto: Alto
    - Archivos: `backend/src/routes/candidateRoutes.ts`, `candidateController.ts`

10. **Manejo de errores frontend**
    - Esfuerzo: Bajo-Medio (1-2 horas)
    - Impacto: Medio
    - Archivos: `frontend/src/components/`
