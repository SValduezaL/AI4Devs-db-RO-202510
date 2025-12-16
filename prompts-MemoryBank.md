# Prompts Operativos - Sesión Memory Bank

Este documento recopila los principales prompts operativos utilizados en esta sesión para crear y mantener el Memory Bank del proyecto LTI - Talent Tracking System.

**Fecha de creación**: 2025-01-27  
**Rama**: `db-SVL`

---

## 1. Crear Memory Bank Completo

### Prompt Original

```
Contexto / Rol
Eres Cursor (AI agent) actuando como arquitecto de software + tech writer. Tu memoria “entre sesiones” no es fiable, así que debes crear documentación persistente y estructurada para que cualquier IA (y humano) retome el proyecto sin contexto previo.

Objetivo
Crear un Memory Bank dentro de este repositorio, con:

Estructura estándar (core files requeridos)

Contenido real extraído del código (no inventes)

Reglas del proyecto para obligarte a leer y mantener el Memory Bank en cada tarea

Ejemplos concretos: diagramas, inventario de módulos, flujos, endpoints, decisiones técnicas, etc.

0) Reglas críticas (obligatorias)

No inventes. Si algo no se puede inferir del repo, marca como UNKNOWN y crea una lista “Preguntas al humano”.

Antes de escribir, escanea el repo:

Lenguajes, frameworks, estructura de carpetas

Entrypoints (apps), módulos, paquetes (monorepo?), servicios, infra

Config (env, docker, CI), scripts, herramientas

Tests (si existen), linters, conventions

Escribe en Markdown claro y operativo.

Prioriza lo que un agente necesita para trabajar: qué es, cómo corre, dónde tocar, riesgos, patrones, estado actual.

1) Output esperado: árbol de ficheros

Crea esta estructura (si ya existe, actualízala):

/memory-bank/
  projectbrief.md
  productContext.md
  systemPatterns.md
  techContext.md
  activeContext.md
  progress.md

  /architecture/
    overview.md
    diagrams.md

  /decisions/
    ADR-0001-template.md
    ADR-0002-<slug>.md   (solo si detectas decisiones claras)

  /domains/
    domain-model.md
    key-flows.md

  /interfaces/
    api.md              (si hay API)
    events-jobs.md      (si hay colas, cron, workers)

  /ops/
    local-dev.md
    deployment.md
    observability.md

  /quality/
    testing.md
    linting-format.md


Además:

Crea reglas en formato moderno si el repo lo soporta:

.cursor/rules/memory-bank.mdc

.cursor/rules/engineering-standards.mdc

Si el proyecto usa legado o el equipo lo pide, crea también .cursorrules (opcional), pero prioriza .cursor/rules.
Cursor - Community Forum
+1

2) Contenido mínimo requerido (core files)
memory-bank/projectbrief.md

Debe responder, con bullets y secciones:

Qué es el producto (1–3 líneas)

Objetivo de negocio / problema que resuelve

Alcance dentro del repo (qué incluye/excluye)

Stakeholders / tipos de usuarios (si se deduce)

Requisitos no funcionales detectados (seguridad, rendimiento, compliance) si aparecen en código/docs

“Definition of Done” para cambios típicos en este repo

memory-bank/productContext.md

“Why”: por qué existe

“What”: cómo debería funcionar a alto nivel

UX/Flujos principales (si aplica)

Casos borde / riesgos de producto

memory-bank/systemPatterns.md

Arquitectura (monolito, microservicios, monorepo, etc.)

Patrones repetidos en el código (ej. repository pattern, DI, CQRS, event-driven)

Convenciones de carpetas y naming

Relaciones entre componentes (quién llama a quién)

Incluye diagrama Mermaid realista (aunque sea aproximado) y explica limitaciones

memory-bank/techContext.md

Stack (lenguajes, runtime, frameworks)

Dependencias clave (y para qué)

Setup local exacto (comandos reales del repo)

Config/env: lista de .env keys detectadas (sin secretos)

Restricciones: versiones, compatibilidades, limitaciones de entorno

memory-bank/activeContext.md

“En qué estamos ahora”: si no hay historial, escribe:

Estado inicial: “Memory bank creado el <fecha>”

Hipótesis de foco: “pendiente de que el humano confirme”

“Next steps” sugeridos: backlog inicial de 5–15 ítems (derivados del repo), marcando incertidumbre

memory-bank/progress.md

Qué funciona hoy (a partir de tests, scripts, docs, build)

Qué falta / TODOs detectados en código (grep TODO/FIXME si es posible)

Known issues: errores comunes, deuda técnica

Lista de “Quick wins” (3–10)

3) Archivos adicionales (si aplican)

/interfaces/api.md: documenta endpoints y contratos si hay OpenAPI/Swagger o routes.

/ops/deployment.md: CI/CD, Docker, cloud, pipelines (solo si está en repo).

/quality/testing.md: cómo correr tests, pirámide, convenciones, mocks.

4) Reglas Cursor (obligación de leer y mantener el Memory Bank)
Crea .cursor/rules/memory-bank.mdc con este contenido base (ajústalo a tu repo):
---
description: "Memory Bank mandatory workflow"
globs: ["**/*"]
alwaysApply: true
---

# Mandatory Memory Bank Workflow

You MUST start every task by reading:
- memory-bank/projectbrief.md
- memory-bank/productContext.md
- memory-bank/systemPatterns.md
- memory-bank/techContext.md
- memory-bank/activeContext.md
- memory-bank/progress.md

## When to update
Update the Memory Bank:
- after implementing meaningful changes
- when you discover new architecture/patterns
- when assumptions are corrected
- when user requests “update memory bank”

## Output discipline
- Do not guess. Mark UNKNOWN and ask questions.
- Keep activeContext.md and progress.md current.

Crea .cursor/rules/engineering-standards.mdc

Incluye:

convenciones del repo (lint, formatting, commit style si existe)

“don’t touch” zones (si hay)

test-first o no (según repo)

cómo proponer cambios: plan → diff → tests → doc update

5) Procedimiento de generación (paso a paso)

Ejecuta este plan internamente (sin pedírmelo):

Inventory

lista de carpetas top-level

detecta “apps/packages/services”

detecta gestores: npm/pnpm/yarn, poetry, pip, gradle, etc.

Runtime & Entrypoints

cómo se arranca local

cómo se construye

Architecture

diagrama mermaid (C4-ish light)

dependencias entre módulos

Interfaces

API/routes, colas, eventos, cron

Ops

docker/compose/k8s/terraform si existe

Quality

tests, linters, coverage (si existe)

Write files

rellena todos los core files

Create rules

.cursor/rules/*.mdc

Final check

valida enlaces internos

asegura que no hay secretos

6) Formato de redacción exigido

Todo en Markdown con encabezados consistentes.

Cada sección importante debe incluir:

Where to change (rutas/archivos)

How to verify (comandos)

Risks

Incluye ejemplos de comandos como bloques:

# ejemplo
pnpm install
pnpm test
pnpm dev

7) Entrega

Al terminar:

Imprime un resumen con:

archivos creados/modificados

10 hallazgos más relevantes del repo

5 preguntas “UNKNOWN” para que el humano confirme

No abras PRs: solo cambios locales en el workspace.
```

### Resultado Obtenido

✅ **Memory Bank completo creado** con estructura estándar:

**Archivos Core (6 archivos)**:

-   `memory-bank/projectbrief.md` - Qué es el producto y alcance
-   `memory-bank/productContext.md` - Por qué existe y cómo funciona
-   `memory-bank/systemPatterns.md` - Arquitectura y patrones del código
-   `memory-bank/techContext.md` - Stack tecnológico y setup
-   `memory-bank/activeContext.md` - Estado actual y próximos pasos
-   `memory-bank/progress.md` - Qué funciona y qué falta

**Archivos Adicionales (11 archivos)**:

-   `memory-bank/architecture/overview.md` - Visión general de arquitectura
-   `memory-bank/architecture/diagrams.md` - Diagramas Mermaid
-   `memory-bank/domains/domain-model.md` - Modelo de dominio
-   `memory-bank/domains/key-flows.md` - Flujos principales
-   `memory-bank/interfaces/api.md` - Documentación de API
-   `memory-bank/interfaces/events-jobs.md` - Eventos y jobs
-   `memory-bank/ops/local-dev.md` - Setup local
-   `memory-bank/ops/deployment.md` - Deployment
-   `memory-bank/ops/observability.md` - Observabilidad
-   `memory-bank/quality/testing.md` - Testing
-   `memory-bank/quality/linting-format.md` - Linting y formato

**Reglas de Cursor (2 archivos)**:

-   `.cursor/rules/memory-bank.mdc` - Workflow obligatorio del Memory Bank
-   `.cursor/rules/engineering-standards.mdc` - Estándares de ingeniería

**Total**: 19 archivos creados, 4,581 líneas añadidas

**Commit**: `6e05149` - "feat: Crear Memory Bank completo y reglas de Cursor"

---

## 2. Confirmar Contexto del Proyecto

### Prompt Original

```
Te confirmo las preguntas UNKNOWN
El objetivo del proyecto es un ejercicio de aprendizaje
De momento no se requiere autentificación
No hay planes de despliegue
No se esperan candidatos reales, es un ejercicio
No hay planes de integrar con ATS u otros sistemas de reclutamiento.
```

### Resultado Obtenido

✅ **Memory Bank actualizado** con información confirmada:

**Cambios realizados**:

-   `memory-bank/activeContext.md` - Sección "Contexto confirmado" añadida
-   `memory-bank/projectbrief.md` - Objetivo actualizado a "ejercicio de aprendizaje"
-   `memory-bank/productContext.md` - Riesgos marcados como "aceptables para ejercicio"
-   `memory-bank/interfaces/api.md` - Autenticación marcada como "no se requiere"

**Información confirmada**:

-   ✅ Objetivo: Ejercicio de aprendizaje (no MVP ni producción)
-   ✅ Autenticación: No se requiere
-   ✅ Deployment: No hay planes
-   ✅ Escala: No se esperan candidatos reales
-   ✅ Integraciones: No hay planes de integrar con ATS

**Impacto**: Eliminadas incertidumbres, prioridades ajustadas (autenticación removida de alta prioridad)

---

## 3. Crear Rama Git y Commits

### Prompt Original

```
crea una rama en Git que se llame "db-SVL", trasladando todos los cambios a esta nueva rama y haz un commit bien explicado
```

### Resultado Obtenido

✅ **Rama creada y commits realizados**:

**Rama**: `db-SVL` (creada y activa)

**Commits realizados**:

1. `6e05149` - "feat: Crear Memory Bank completo y reglas de Cursor"

    - 20 archivos, 4,581 líneas añadidas
    - Memory Bank completo + reglas de Cursor

2. `e14a73a` - "feat: Configurar gestión de .env y scripts de sincronización"

    - 9 archivos modificados, 310 inserciones
    - Scripts sync-env.js/ps1, configuración de .env

3. `e32d502` - "fix: Corregir resolución de path de .env en modo desarrollo"

    - 1 archivo modificado
    - Función getRootEnvPath() para desarrollo y producción

4. `e371d7a` - "fix: Corregir validación de variables .env y orden de middleware"
    - 3 archivos modificados
    - Validación mejorada, middleware de logging reordenado

**Total**: 4 commits en rama `db-SVL`

---

## 4. Configurar Gestión de .env

### Prompt Original

```
El archivo .env está situado en el directorio principal, el cual contiene DB_NAME, DB_PORT, DB_USER, DB_PASSWORD y DATABASE_URL, pero tu haces referencia a que se necesita uno en el backend con la DATABASE_URL. ¿Debo trasladar el archivo .env del directorio raiz a la carpeta backend? ¿O crear un .venv nuevo con las mismas variables? ¿O cambiar alguna otra cosa?
```

### Resultado Obtenido

✅ **Solución implementada**: Dos archivos `.env` sincronizados

**Solución adoptada**:

1. **`.env` en raíz** - Para `docker-compose.yml` (DB_NAME, DB_PORT, DB_USER, DB_PASSWORD, DATABASE_URL)
2. **`backend/.env`** - Para Prisma (solo DATABASE_URL, generado automáticamente)

**Cambios realizados**:

-   `backend/src/index.ts` - Modificado para leer `.env` desde la raíz
-   Scripts de sincronización creados:
    -   `scripts/sync-env.js` - Script Node.js multiplataforma
    -   `scripts/sync-env.ps1` - Script PowerShell para Windows
    -   `scripts/README.md` - Documentación de uso
-   Scripts npm añadidos:
    -   `package.json`: `"sync-env": "node scripts/sync-env.js"`
    -   `backend/package.json`: `"sync-env": "cd .. && npm run sync-env"`

**Uso**: `npm run sync-env` desde raíz o backend

**Commit**: `e14a73a` - "feat: Configurar gestión de .env y scripts de sincronización"

---

## 5. Verificar y Corregir Bugs

### Prompt Original

```
Verify this issue exists and fix it:

The `dotenv.config()` call uses `path.resolve(__dirname, '../../.env')` to load the root `.env` file. However, when running in development mode with `ts-node-dev`, `__dirname` refers to the source directory (`backend/src`), making the path resolve to `backend/.env` instead of the project root's `.env`. This works correctly only after compilation when `__dirname` is `backend/dist`, but breaks during development. The correct path should resolve to one level higher or use `process.cwd()` instead.
```

### Resultado Obtenido

✅ **Bug verificado y corregido**:

**Problema confirmado**:

-   En desarrollo: `__dirname` = `backend/src` → `path.resolve(__dirname, '../../.env')` resolvía incorrectamente
-   En producción: `__dirname` = `backend/dist` → funcionaba correctamente

**Solución implementada**:

-   Función `getRootEnvPath()` creada que:
    -   Usa `path.resolve(__dirname, '../..')` para obtener raíz (funciona en ambos modos)
    -   Verifica que el archivo existe con `fs.existsSync()`
    -   Incluye fallback usando `process.cwd()`

**Archivo modificado**: `backend/src/index.ts`

**Commit**: `e32d502` - "fix: Corregir resolución de path de .env en modo desarrollo"

---

## 6. Corregir Validación y Orden de Middleware

### Prompt Original

```
Verify these issues exist and fix them:

Bug 1: The validation logic for required environment variables uses a falsy check that incorrectly rejects empty string values. If a variable like `DB_USER=` exists in `.env` but is empty, the filter treats it as missing and exits with an error, even though the variable is present.

Bug 2: The logging middleware (lines 72-75) is registered after the route handlers (lines 67, 70, and 79). In Express, middleware executes in registration order, so requests matched by routes are handled and sent before reaching this logging middleware.
```

### Resultado Obtenido

✅ **Ambos bugs verificados y corregidos**:

**Bug 1 - Validación de variables .env**:

-   **Problema**: `!envVars[v]` es falsy para strings vacíos, trataba variables vacías como faltantes
-   **Solución**: Cambiado a `!(v in envVars)` para distinguir entre:
    -   Variable faltante: `undefined` (no existe en objeto)
    -   Variable con valor vacío: `""` (existe pero vacía)
-   **Mejora**: Añadida advertencia para variables con valor vacío
-   **Archivos corregidos**: `scripts/sync-env.js`, `scripts/sync-env.ps1`

**Bug 2 - Orden de middleware**:

-   **Problema**: Middleware de logging después de rutas, nunca se ejecutaba
-   **Solución**: Movido middleware de logging ANTES de las rutas (línea 66-70)
-   **Archivo corregido**: `backend/src/index.ts`

**Commit**: `e371d7a` - "fix: Corregir validación de variables .env y orden de middleware"

---

## Resumen de Resultados

### Archivos Creados/Modificados

**Memory Bank**: 19 archivos

-   6 archivos core
-   11 archivos adicionales (architecture, domains, interfaces, ops, quality)
-   2 reglas de Cursor

**Scripts**: 3 archivos

-   `scripts/sync-env.js`
-   `scripts/sync-env.ps1`
-   `scripts/README.md`

**Configuración**: 3 archivos modificados

-   `backend/src/index.ts` - Carga de .env y orden de middleware
-   `package.json` - Script sync-env
-   `backend/package.json` - Script sync-env

### Commits Realizados

1. `6e05149` - Memory Bank completo
2. `e14a73a` - Gestión de .env y scripts
3. `e32d502` - Fix path de .env en desarrollo
4. `e371d7a` - Fix validación y middleware

### Hallazgos Principales

1. **Arquitectura en capas**: Presentation → Application → Domain → Infrastructure
2. **Active Record Pattern**: Modelos de dominio con métodos `save()` y `findOne()`
3. **Mezcla JS/TS en frontend**: `App.js` es el activo (no `App.tsx`)
4. **Validación robusta**: Regex para nombres, email, teléfono español
5. **Tests backend**: Jest configurado con tests para servicios, controladores, validadores
6. **Sin autenticación**: API abierta (confirmado como ejercicio de aprendizaje)
7. **CORS restrictivo**: Solo permite `http://localhost:3000`
8. **Upload de archivos**: Multer con validación PDF/DOCX, límite 10MB
9. **Dos archivos .env**: Raíz para docker-compose, backend para Prisma
10. **Scripts de sincronización**: Automatizan mantenimiento de .env

### Bugs Corregidos

1. ✅ Path de .env en desarrollo (ts-node-dev vs compilado)
2. ✅ Validación de variables .env (falsy check incorrecto)
3. ✅ Orden de middleware de logging (después de rutas)

### Estado Final

-   ✅ Memory Bank completo y actualizado
-   ✅ Reglas de Cursor configuradas (`alwaysApply: true`)
-   ✅ Scripts de sincronización funcionando
-   ✅ Bugs críticos corregidos
-   ✅ Rama `db-SVL` con 4 commits organizados
-   ✅ Documentación completa y operativa

---

## Lecciones Aprendidas

### Prompts Efectivos

1. **Especificidad**: Prompts detallados con contexto y ejemplos obtienen mejores resultados
2. **Verificación**: Pedir "verify this issue exists" antes de corregir asegura precisión
3. **Estructura clara**: Dividir tareas complejas en pasos ayuda a la ejecución
4. **Resultados esperados**: Especificar formato de salida ayuda a obtener lo deseado

### Mejores Prácticas Aplicadas

1. **No inventar información**: Marcar como UNKNOWN lo que no se puede inferir
2. **Extraer del código**: Usar herramientas de búsqueda y lectura de archivos
3. **Documentar decisiones**: Incluir "por qué" además de "qué"
4. **Mantener actualizado**: Actualizar Memory Bank después de cambios significativos

### Comandos Útiles

```bash
# Sincronizar .env
npm run sync-env

# Ver commits
git log --oneline

# Verificar estado
git status

# Ver diferencias
git diff
```

---

## Notas Finales

Este documento sirve como referencia para:

-   **Futuras sesiones**: Ver qué prompts funcionaron bien
-   **Onboarding**: Entender qué se hizo y cómo
-   **Mejora continua**: Identificar patrones de prompts efectivos

**Última actualización**: 2025-01-27
