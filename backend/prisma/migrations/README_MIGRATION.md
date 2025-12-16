# Migración: Expansión de Base de Datos con Entidades de Entrevistas

## Resumen

Esta migración expande la base de datos con las nuevas entidades necesarias para operar el flujo completo de aplicación para diversas posiciones, según el ERD proporcionado.

## Entidades Añadidas

1. **Company** - Empresas que publican posiciones
2. **Employee** - Empleados que realizan entrevistas
3. **Position** - Posiciones de trabajo disponibles
4. **InterviewFlow** - Flujos de entrevista predefinidos
5. **InterviewStep** - Pasos individuales dentro de un flujo
6. **InterviewType** - Tipos de entrevista (técnica, HR, cultural, etc.)
7. **Application** - Aplicaciones de candidatos a posiciones
8. **Interview** - Entrevistas realizadas

## Cambios en Entidades Existentes

- **Candidate**: Añadidos timestamps (`createdAt`, `updatedAt`) y relación con `Application`
- **Education**: Añadidos timestamps y `onDelete: Cascade`
- **WorkExperience**: Añadidos timestamps y `onDelete: Cascade`
- **Resume**: Añadidos timestamps y `onDelete: Cascade`

## Buenas Prácticas Aplicadas

### Índices

- Índices en todas las foreign keys para mejorar JOINs
- Índices en columnas de búsqueda frecuente (status, isActive, email, etc.)
- Índices compuestos para queries comunes (ej: `(positionId, candidateId)` en Application)

### Normalización

- Estructura normalizada hasta 3NF
- Sin redundancia de datos
- Relaciones apropiadas con foreign keys

### Constraints

- `onDelete: Cascade` para relaciones donde tiene sentido (ej: InterviewStep → InterviewFlow)
- `onDelete: Restrict` para prevenir eliminaciones accidentales (ej: Application → Position)
- Check constraint en Interview.score (0-100): Añadido en migración SQL (`add_interview_score_check.sql`)
  - **Nota**: Prisma no soporta check constraints directamente en el schema, por lo que debe añadirse manualmente o mediante migración raw SQL

### Timestamps

- `createdAt` y `updatedAt` en todas las tablas
- Automáticamente gestionados por Prisma

## Cómo Aplicar la Migración

### Prerrequisitos

1. **Base de datos corriendo**: Asegúrate de que PostgreSQL esté corriendo

   ```bash
   docker-compose up -d
   ```

2. **Variables de entorno**: Verifica que `backend/.env` tenga `DATABASE_URL` configurado

### Pasos

1. **Navegar al directorio backend**:

   ```bash
   cd backend
   ```

2. **Crear y aplicar la migración**:

   ```bash
   npx prisma migrate dev --name expand_database_with_interview_entities
   ```

   Este comando:

   - Creará la migración basada en los cambios del schema
   - Aplicará la migración a la base de datos
   - Regenerará el cliente de Prisma

3. **Verificar la migración**:
   ```bash
   npx prisma studio
   ```
   Abre Prisma Studio para verificar que las nuevas tablas se crearon correctamente.

### Alternativa: Script SQL Manual

Si prefieres aplicar el SQL directamente (no recomendado si usas Prisma):

1. El script SQL está en `backend/prisma/migrations/erd_to_sql.sql`
2. Puedes ejecutarlo directamente en PostgreSQL:
   ```bash
   psql -U postgres -d LTIdb -f prisma/migrations/erd_to_sql.sql
   ```

**Nota**: Si usas el script SQL manual, Prisma no tendrá registro de la migración. Es mejor usar `prisma migrate dev`.

## Verificación Post-Migración

Después de aplicar la migración, verifica:

1. **Tablas creadas**: Deben existir las 8 nuevas tablas
2. **Relaciones**: Las foreign keys deben estar correctamente configuradas
3. **Índices**: Los índices deben estar creados (verificar con `\di` en psql)
4. **Cliente Prisma**: Regenerar con `npx prisma generate`

## Rollback

Si necesitas revertir la migración:

```bash
npx prisma migrate reset
```

**⚠️ ADVERTENCIA**: Esto eliminará todos los datos. Solo usar en desarrollo.

## Archivos Relacionados

- `backend/prisma/schema.prisma` - Schema actualizado con todas las entidades
- `backend/prisma/migrations/erd_to_sql.sql` - Script SQL de referencia
- `.cursorrules` - Estándares de diseño de base de datos

## Notas Adicionales

- Los modelos existentes (Candidate, Education, WorkExperience, Resume) mantienen compatibilidad hacia atrás
- Los timestamps se añadieron a las tablas existentes, pero los registros antiguos tendrán valores NULL (o se puede hacer un UPDATE)
- Considerar migración de datos si hay datos existentes que necesiten los nuevos campos
