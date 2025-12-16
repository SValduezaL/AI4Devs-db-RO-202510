# Active Context

## En qué estamos ahora

**Estado inicial**: Memory Bank actualizado el 2025-01-27

**Última actualización**: 2025-01-27 - Memory Bank regenerado con información real extraída del código y contexto confirmado (ejercicio de aprendizaje)

**Contexto actual**: Proyecto en estado funcional básico con:

-   Backend API REST operativa
-   Frontend React con dashboard y formulario
-   Base de datos PostgreSQL configurada
-   Tests unitarios implementados (backend)
-   Sistema de upload de archivos funcional

## Contexto confirmado

**Confirmado por el usuario (2025-01-27)**:

1. **Objetivo del proyecto**: ✅ **Ejercicio de aprendizaje** (no es MVP ni producto en producción)
2. **Autenticación**: ✅ **No se requiere** de momento
3. **Deployment**: ✅ **No hay planes de despliegue**
4. **Escala**: ✅ **No se esperan candidatos reales**, es un ejercicio
5. **Integraciones**: ✅ **No hay planes de integrar con ATS u otros sistemas**

## Próximas decisiones pendientes

**Pendiente de definir**:

1. **Próximas features**: ¿Qué funcionalidades se planean añadir al ejercicio?
2. **Prioridades**: ¿Qué áreas necesitan mejoras urgentes?
3. **Alcance del ejercicio**: ¿Hasta qué punto se debe desarrollar?

## Next steps sugeridos (backlog inicial)

Derivados del análisis del repositorio:

### Alta prioridad (funcionalidad faltante)

1. **Endpoint GET /candidates (listado)**

    - Estado: Solo existe GET por ID
    - Impacto: Necesario para dashboard
    - Esfuerzo: Bajo

2. **Búsqueda de candidatos**

    - Estado: No implementado
    - Impacto: Alto para UX
    - Esfuerzo: Medio

3. **Validación de fechas lógica**

    - Estado: Solo validación de formato
    - Impacto: Medio (evitar datos inconsistentes)
    - Esfuerzo: Bajo
    - Ubicación: `backend/src/application/validator.ts`

4. **Manejo de errores frontend**
    - Estado: UNKNOWN (no se detecta código de manejo)
    - Impacto: Medio (mejor UX)
    - Esfuerzo: Bajo-Medio

### Media prioridad (mejoras técnicas)

6. **Variables de entorno para configuración**

    - Estado: Algunas hardcoded (puerto, CORS, upload path)
    - Impacto: Medio (flexibilidad)
    - Esfuerzo: Bajo
    - Archivos: `backend/src/index.ts`, `fileUploadService.ts`

7. **Health check endpoint**

    - Estado: No existe
    - Impacto: Bajo-Medio (monitoreo)
    - Esfuerzo: Muy bajo

8. **Logging estructurado**

    - Estado: Solo `console.log`
    - Impacto: Medio (debugging en producción)
    - Esfuerzo: Medio

9. **Tests frontend**

    - Estado: Configurado pero no se detectan tests escritos
    - Impacto: Medio (calidad)
    - Esfuerzo: Medio-Alto

10. **Documentación API con Swagger UI**
    - Estado: `api-spec.yaml` existe pero no se detecta endpoint `/api-docs`
    - Impacto: Bajo-Medio (developer experience)
    - Esfuerzo: Bajo (solo conectar swagger-ui-express)

### Baja prioridad (nice to have)

11. **Paginación en listados**

    -   Estado: No aplicable aún (no hay listado)
    -   Impacto: Bajo (futuro)
    -   Esfuerzo: Medio

12. **Filtros y ordenamiento**

    -   Estado: No implementado
    -   Impacto: Bajo (futuro)
    -   Esfuerzo: Medio

13. **Migración completa a TypeScript (frontend)**

    -   Estado: Mezcla de `.js` y `.tsx`
    -   Impacto: Bajo (consistencia)
    -   Esfuerzo: Bajo-Medio

14. **Dockerfile para aplicación**

    -   Estado: Solo docker-compose para BD
    -   Impacto: Bajo (deployment)
    -   Esfuerzo: Medio

15. **CI/CD pipeline**
    -   Estado: No detectado
    -   Impacto: Medio (automatización)
    -   Esfuerzo: Alto

## Información confirmada

-   **Autenticación**: ✅ No se requiere de momento (confirmado 2025-01-27)
-   **Deployment**: ✅ No hay planes de despliegue (confirmado 2025-01-27)
-   **Escala**: ✅ No se esperan candidatos reales, es un ejercicio (confirmado 2025-01-27)
-   **Integraciones**: ✅ No hay planes de integrar con ATS u otros sistemas (confirmado 2025-01-27)

## Incertidumbres restantes

-   **Backup strategy**: No aplica (ejercicio local, no producción)
-   **Próximas features**: ¿Qué funcionalidades se planean añadir al ejercicio?

## Notas de contexto

-   ✅ **Confirmado**: El proyecto es un **ejercicio de aprendizaje** de AI4Devs (confirmado 2025-01-27)
-   Versión actual: 0.0.0.001 (muy temprana)
-   Hay tests unitarios en backend pero cobertura UNKNOWN
-   Frontend tiene estructura básica pero funcionalidad limitada
-   **No es para producción**: No requiere autenticación, deployment, ni escalabilidad
