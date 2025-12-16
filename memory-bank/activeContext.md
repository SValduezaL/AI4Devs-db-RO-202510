# Active Context

## En qué estamos ahora

**Estado inicial**: Memory Bank actualizado el 2025-01-27

**Última actualización**: 2025-12-16 - Migración de base de datos completada con nuevas entidades de entrevistas

**Contexto actual**: Proyecto en estado funcional básico con:

-   Backend API REST operativa
-   Frontend React con dashboard y formulario
-   Base de datos PostgreSQL configurada y expandida
-   Tests unitarios implementados (backend)
-   Sistema de upload de archivos funcional
-   ✅ **NUEVO**: Schema de base de datos expandido con entidades para flujo completo de aplicaciones (Company, Employee, Position, InterviewFlow, InterviewStep, InterviewType, Application, Interview)

## Contexto confirmado

**Confirmado por el usuario (2025-01-27)**:

1. **Objetivo del proyecto**: ✅ **Ejercicio de aprendizaje** (no es MVP ni producto en producción)
2. **Autenticación**: ✅ **No se requiere** de momento
3. **Deployment**: ✅ **No hay planes de despliegue**
4. **Escala**: ✅ **No se esperan candidatos reales**, es un ejercicio
5. **Integraciones**: ✅ **No hay planes de integrar con ATS u otros sistemas**

## Cambios recientes (2025-12-16)

**Expansión de base de datos (2025-12-16)**:

1. ✅ **Schema Prisma actualizado**: Añadidas 8 nuevas entidades del ERD proporcionado
    - Company, Employee, Position, InterviewFlow, InterviewStep, InterviewType, Application, Interview
    - Entidades existentes actualizadas con timestamps (createdAt, updatedAt)
2. ✅ **Buenas prácticas aplicadas**:
    - Timestamps (createdAt, updatedAt) en todas las tablas
    - Índices en foreign keys y columnas de búsqueda frecuente
    - Índices compuestos para queries comunes
    - Constraints apropiados (onDelete, onUpdate)
    - Normalización 3NF
    - Check constraints (ej: score 0-100 en Interview)
3. ✅ **Script SQL generado**: `backend/prisma/migrations/erd_to_sql.sql` con estructura completa y comentarios
4. ✅ **Reglas de base de datos**: Creado `.cursor/rules/database-standards.mdc` con estándares de diseño de BD
    - Sigue convención del proyecto (formato `.mdc` con frontmatter YAML)
    - Aplica automáticamente a archivos Prisma y SQL
5. ✅ **Documentación de migración**: Creado `backend/prisma/migrations/README_MIGRATION.md` con guía completa
6. ✅ **Migración aplicada (2025-12-16)**: Migración `20251216224021_expand_database_with_interview_entities` creada y aplicada exitosamente
    - Todas las tablas creadas en la base de datos
    - Índices y foreign keys configurados correctamente
    - Puerto de base de datos cambiado a 5433 (resuelto conflicto de puertos)
7. ✅ **Documentación de prompts (2025-12-16)**: Creados archivos de documentación de prompts operativos
    - `prompts-SVL.md` - Documentación completa de la sesión de expansión de base de datos
    - `prompts-MemoryBank.md` - Documentación de prompts relacionados con Memory Bank
    - Incluye todos los prompts principales, resultados y lecciones aprendidas

## Próximas decisiones pendientes

**Pendiente de definir**:

1. **Implementación de servicios**: ¿Crear servicios/controladores para las nuevas entidades?
2. **Endpoints API**: ¿Qué endpoints se necesitan para el flujo completo?
3. **Prioridades**: ¿Qué áreas necesitan mejoras urgentes?

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
