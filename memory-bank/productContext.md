# Product Context

## Why: Por qué existe

Este sistema existe para resolver la necesidad de gestionar información de candidatos en procesos de reclutamiento de manera estructurada y centralizada. Permite:

-   Registrar candidatos con información completa (datos personales, educación, experiencia)
-   Almacenar CVs de forma organizada
-   Consultar información de candidatos de forma rápida
-   Mantener un historial estructurado de perfiles

## What: Cómo debería funcionar a alto nivel

### Flujo principal: Añadir Candidato

1. **Reclutador accede al dashboard** (`/`)

    - Ve logo LTI y opción "Añadir Nuevo Candidato"
    - Navegación con React Router a `/add-candidate`

2. **Formulario de candidato** (`/add-candidate`)

    - Reclutador completa:
        - Datos personales (nombre, apellido, email, teléfono, dirección)
        - Educación (institución, título, fechas) - múltiples registros dinámicos
        - Experiencia laboral (empresa, puesto, descripción, fechas) - múltiples registros dinámicos
    - Reclutador sube CV (PDF o DOCX) usando componente FileUploader
    - Formulario muestra mensajes de éxito/error

3. **Procesamiento**

    - Frontend: Usuario completa formulario y sube CV
    - Frontend: FileUploader sube archivo a `POST /upload` → recibe `{filePath, fileType}`
    - Frontend: Formatea fechas a YYYY-MM-DD y envía datos completos a `POST /candidates`
    - Backend: Valida datos con regex y límites en `validator.ts`
    - Backend: Crea modelos de dominio y persiste en cascada (candidato → educación → experiencia → CV)
    - Backend: Retorna candidato creado con ID (201 Created)
    - Frontend: Muestra mensaje de éxito o error

4. **Resultado**
    - Candidato visible en base de datos
    - CV almacenado en sistema de archivos

### Flujo secundario: Consultar Candidato

1. **GET `/candidates/:id`** (implementado pero no expuesto en frontend)
    - Retorna candidato completo con educación, experiencia y CVs

## UX/Flujos principales

### Pantallas detectadas

1. **Dashboard del Reclutador** (`RecruiterDashboard.js`)

    - Logo LTI
    - Botón "Añadir Nuevo Candidato"
    - Navegación a formulario

2. **Formulario de Candidato** (`AddCandidateForm.js`)

    - Formulario multi-sección
    - Upload de archivo
    - Envío de datos

3. **Componente de Upload** (`FileUploader.js`)
    - Selección de archivo
    - Validación de tipo
    - Feedback visual

### Navegación

-   React Router configurado (detectado en `RecruiterDashboard.js` con `Link`)
-   Rutas detectadas: `/`, `/add-candidate`

## Casos borde / Riesgos de producto

### Validaciones detectadas

1. **Email duplicado**

    - Error: "The email already exists in the database"
    - Código Prisma: `P2002`

2. **Archivo inválido**

    - Solo PDF y DOCX permitidos
    - Error: "Invalid file type, only PDF and DOCX are allowed!"
    - Límite: 10MB

3. **Datos inválidos**

    - Nombres: solo letras, espacios, acentos (2-100 caracteres)
    - Email: formato estándar
    - Teléfono: formato español (6, 7 o 9 seguido de 8 dígitos)
    - Fechas: formato `YYYY-MM-DD`
    - Dirección: máximo 100 caracteres

4. **Base de datos no disponible**

    - Error: "No se pudo conectar con la base de datos"
    - Prisma `PrismaClientInitializationError`

5. **Candidato no encontrado**
    - GET por ID inexistente → 404
    - Prisma error `P2025`

### Riesgos no cubiertos (aceptables para ejercicio)

-   ✅ **Autenticación**: No hay control de acceso - **No se requiere** (confirmado 2025-01-27)
-   **Rate limiting**: No detectado - No necesario para ejercicio local
-   **Validación de fechas**: No se valida que `endDate > startDate` - Mejora sugerida
-   **Sanitización de archivos**: No se detecta escaneo de malware - Aceptable para ejercicio
-   **Backup de archivos**: No detectado sistema de backup - No necesario (ejercicio local)
-   **Búsqueda**: Solo búsqueda por ID, no hay búsqueda por nombre/email - Funcionalidad faltante
-   **Paginación**: No detectada para listados - No necesario sin listado implementado

## Estado actual del producto

-   **Versión**: 0.0.0.001 (según `VERSION`)
-   **Funcionalidad básica**: Operativa
-   **Frontend**: Dashboard y formulario implementados
-   **Backend**: API REST funcional con validaciones
-   **Base de datos**: Schema Prisma definido y migraciones disponibles
