# Observability

## Estado actual

**Observabilidad**: MÍNIMA

El sistema tiene logging básico pero no hay monitoreo, métricas o tracing estructurado.

## Logging

### Backend

**Implementación actual**:

-   `console.log()` para requests HTTP
-   `console.error()` para errores en error handler

**Ubicación**: `backend/src/index.ts`

**Ejemplo**:

```typescript
app.use((req, res, next) => {
    console.log(`${new Date().toISOString()} - ${req.method} ${req.path}`);
    next();
});
```

**Limitaciones**:

-   No hay niveles de log (info, warn, error, debug)
-   No hay formato estructurado (JSON)
-   No hay rotación de logs
-   No hay agregación de logs
-   Logs solo en stdout/stderr

### Frontend

**Implementación actual**: UNKNOWN

No se detecta logging específico en el código frontend.

## Métricas

**Estado**: NO IMPLEMENTADO

No hay sistema de métricas (Prometheus, Datadog, etc.).

### Métricas sugeridas

1. **Request metrics**:

    - Total de requests
    - Requests por segundo
    - Latencia (p50, p95, p99)
    - Tasa de errores (4xx, 5xx)

2. **Business metrics**:

    - Candidatos creados por día
    - CVs subidos por día
    - Tamaño promedio de CVs

3. **System metrics**:
    - Uso de CPU/Memoria
    - Conexiones a base de datos
    - Espacio en disco (uploads)

## Tracing

**Estado**: NO IMPLEMENTADO

No hay distributed tracing (Jaeger, Zipkin, etc.).

**Útil para**:

-   Seguir requests a través de frontend → backend → BD
-   Identificar cuellos de botella
-   Debugging de problemas complejos

## Health Checks

### Implementación actual

**Endpoint**: `GET /`

**Respuesta**: `"Hola LTI!"`

**Ubicación**: `backend/src/index.ts`

**Limitaciones**:

-   No verifica conexión a base de datos
-   No verifica estado del filesystem
-   No retorna información estructurada
-   No tiene códigos de estado diferentes

### Health check mejorado (sugerido)

```typescript
app.get("/health", async (req, res) => {
    const health = {
        status: "ok",
        timestamp: new Date().toISOString(),
        checks: {
            database: "unknown",
            filesystem: "unknown",
        },
    };

    // Check database
    try {
        await prisma.$queryRaw`SELECT 1`;
        health.checks.database = "ok";
    } catch (error) {
        health.checks.database = "error";
        health.status = "degraded";
    }

    // Check filesystem
    try {
        const fs = require("fs");
        fs.accessSync("../uploads", fs.constants.W_OK);
        health.checks.filesystem = "ok";
    } catch (error) {
        health.checks.filesystem = "error";
        health.status = "degraded";
    }

    const statusCode = health.status === "ok" ? 200 : 503;
    res.status(statusCode).json(health);
});
```

## Alertas

**Estado**: NO IMPLEMENTADO

No hay sistema de alertas configurado.

### Alertas sugeridas

1. **Error rate alto**: > 5% de requests con error
2. **Latencia alta**: p95 > 1 segundo
3. **Base de datos down**: Health check falla
4. **Disco lleno**: Espacio en uploads < 10%
5. **Memoria alta**: Uso de memoria > 80%

## Herramientas sugeridas

### Logging

1. **Winston**: Librería de logging para Node.js

    - Niveles de log
    - Transports (archivo, console, etc.)
    - Formato estructurado

2. **Pino**: Logger rápido y estructurado

    - JSON logs
    - Muy performante

3. **Morgan**: HTTP request logger middleware
    - Logs de requests HTTP
    - Formatos predefinidos

### Métricas

1. **Prometheus**: Sistema de métricas

    - Exportar métricas desde Node.js
    - Scraping de métricas

2. **Datadog**: APM y métricas

    - Integración fácil
    - Dashboard predefinidos

3. **New Relic**: APM completo
    - Monitoreo de aplicación
    - Alertas

### Logging agregado

1. **ELK Stack** (Elasticsearch, Logstash, Kibana)

    - Agregación de logs
    - Búsqueda y visualización

2. **Loki + Grafana**

    - Alternativa más ligera a ELK
    - Integración con Grafana

3. **Cloud Logging**
    - AWS CloudWatch Logs
    - Google Cloud Logging
    - Azure Monitor Logs

## Implementación sugerida

### Paso 1: Logging estructurado

```bash
cd backend
npm install winston
```

```typescript
// logger.ts
import winston from "winston";

export const logger = winston.createLogger({
    level: process.env.LOG_LEVEL || "info",
    format: winston.format.json(),
    transports: [
        new winston.transports.Console({
            format: winston.format.simple(),
        }),
    ],
});
```

### Paso 2: Health check mejorado

Implementar endpoint `/health` que verifique:

-   Conexión a base de datos
-   Acceso a filesystem
-   Estado de servicios externos (si los hay)

### Paso 3: Métricas básicas

```bash
npm install prom-client
```

Exponer endpoint `/metrics` con métricas Prometheus.

### Paso 4: Error tracking

```bash
npm install @sentry/node
```

Integrar Sentry para tracking de errores en producción.

## Configuración recomendada por entorno

### Desarrollo

-   **Logging**: Console con formato legible
-   **Métricas**: Opcional (solo para debugging)
-   **Tracing**: No necesario

### Staging

-   **Logging**: Structured logs (JSON) a archivo
-   **Métricas**: Básicas (requests, errores)
-   **Tracing**: Opcional

### Producción

-   **Logging**: Structured logs a servicio agregado (CloudWatch, etc.)
-   **Métricas**: Completas (Prometheus o servicio cloud)
-   **Tracing**: Recomendado (Jaeger, Datadog APM)
-   **Alertas**: Configuradas y activas

## Notas

-   **Logging actual es insuficiente** para producción
-   **No hay visibilidad** de problemas en producción sin mejoras
-   **Health check básico** no es suficiente para monitoreo
-   **No hay alertas** para problemas críticos

## Quick wins

1. **Añadir Winston**: 1-2 horas
2. **Health check mejorado**: 1 hora
3. **Métricas básicas con prom-client**: 2-3 horas
4. **Integrar Sentry**: 1 hora
