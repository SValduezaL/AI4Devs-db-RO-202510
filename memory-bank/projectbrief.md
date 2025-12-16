# Project Brief

## Qué es el producto

**LTI - Talent Tracking System** es una aplicación full-stack para gestión de candidatos en procesos de reclutamiento. Permite a los reclutadores registrar candidatos con sus datos personales, historial educativo, experiencia laboral y CVs.

## Objetivo de negocio / Problema que resuelve

**IMPORTANTE**: Este es un **ejercicio de aprendizaje**, no un producto en producción.

-   **Contexto**: Ejercicio del curso AI4Devs para aprender desarrollo full-stack
-   **Objetivo educativo**: Practicar arquitectura en capas, TypeScript, React, Prisma, y APIs REST
-   **Simulación**: Simula un sistema de tracking de talento para gestión de candidatos
-   **Alcance**: No se esperan usuarios reales ni datos de producción

## Alcance dentro del repo

### Incluye

-   Backend API REST (Express + TypeScript)
-   Frontend React (Create React App)
-   Base de datos PostgreSQL con Prisma ORM
-   Sistema de subida de archivos (PDF/DOCX)
-   Validación de datos de candidatos
-   Tests unitarios (Jest)
-   Docker Compose para base de datos

### Excluye (confirmado)

-   ✅ Sistema de autenticación/autorización - **No se requiere** (confirmado 2025-01-27)
-   ✅ Sistema de notificaciones - No necesario para ejercicio
-   ✅ Integraciones con ATS externos - **No hay planes** (confirmado 2025-01-27)
-   Sistema de búsqueda avanzada - Solo endpoint básico GET por ID
-   ✅ Deployment a producción - **No hay planes** (confirmado 2025-01-27)

## Stakeholders / Tipos de usuarios

-   **Reclutadores**: Usuarios principales que añaden y consultan candidatos
-   **Candidatos**: Entidades pasivas (sus datos son gestionados por reclutadores)

**Nota**: ✅ **Confirmado**: No se requiere autenticación (ejercicio de aprendizaje, no producción). El acceso es abierto.

## Requisitos no funcionales detectados

### Seguridad

-   Validación de tipos de archivo (solo PDF y DOCX)
-   Límite de tamaño de archivo: 10MB
-   Validación de datos de entrada con regex
-   CORS configurado para `http://localhost:3000`

### Rendimiento

-   Límite de tamaño de archivo: 10MB por upload
-   Base de datos relacional con índices (email único)

### Compliance / Calidad

-   Validación estricta de formatos (nombres, emails, teléfonos, fechas)
-   Manejo de errores con códigos HTTP apropiados
-   Tests unitarios con Jest

## Definition of Done para cambios típicos

Para considerar un cambio completado en este repo:

1. **Código**

    - Código TypeScript compila sin errores (`npm run build` en backend)
    - No hay errores de linting (ESLint + Prettier configurados)
    - Tests pasan (`npm test` en backend)

2. **Backend**

    - Endpoints documentados en `api-spec.yaml` si es nueva ruta
    - Validación de datos implementada
    - Manejo de errores apropiado
    - Tests unitarios para servicios/controladores nuevos

3. **Frontend**

    - Componentes funcionan sin errores de consola
    - Build de producción exitoso (`npm run build`)

4. **Base de datos**

    - Migraciones Prisma aplicadas si hay cambios de schema
    - Schema actualizado en `backend/prisma/schema.prisma`

5. **Documentación**

    - README actualizado si cambian instrucciones de setup
    - Memory Bank actualizado si hay cambios arquitectónicos

6. **Verificación local**
    - Backend corre en `http://localhost:3010`
    - Frontend corre en `http://localhost:3000`
    - Base de datos PostgreSQL accesible
    - Flujo end-to-end funciona (añadir candidato + subir CV)
