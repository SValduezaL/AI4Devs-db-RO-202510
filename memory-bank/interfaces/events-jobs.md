# Events & Jobs

## Eventos

**Estado**: NO IMPLEMENTADO

No hay sistema de eventos (event-driven architecture) en el proyecto actual.

### Eventos potenciales (sugerencias)

Si se implementara un sistema de eventos, estos serían candidatos:

1. **CandidateCreated**

    - Disparado cuando se crea un candidato
    - Payload: Datos del candidato creado
    - Posibles listeners: Notificaciones, integraciones externas, analytics

2. **ResumeUploaded**

    - Disparado cuando se sube un CV
    - Payload: `{ candidateId, filePath, fileType }`
    - Posibles listeners: Procesamiento de CV (parsing, indexación)

3. **CandidateUpdated**
    - Disparado cuando se actualiza un candidato
    - Payload: Datos actualizados
    - Posibles listeners: Sincronización con sistemas externos

## Jobs / Tareas programadas

**Estado**: NO IMPLEMENTADO

No hay sistema de jobs, colas o tareas programadas (cron jobs).

### Jobs potenciales (sugerencias)

1. **Limpieza de archivos huérfanos**

    - Frecuencia: Diaria
    - Descripción: Eliminar CVs que no están asociados a ningún candidato
    - Razón: Si falla la creación de candidato después del upload, el archivo queda huérfano

2. **Backup de base de datos**

    - Frecuencia: Diaria/Semanal
    - Descripción: Backup automático de PostgreSQL
    - Razón: Seguridad y recuperación

3. **Validación de integridad de archivos**

    - Frecuencia: Semanal
    - Descripción: Verificar que todos los archivos referenciados en BD existen en filesystem
    - Razón: Detectar archivos eliminados accidentalmente

4. **Envío de reportes**

    - Frecuencia: Semanal/Mensual
    - Descripción: Reporte de candidatos nuevos, estadísticas
    - Razón: Analytics y reporting

5. **Procesamiento de CVs**
    - Frecuencia: On-demand o batch
    - Descripción: Parsear CVs para extraer información (si se implementa)
    - Razón: Mejorar búsqueda y matching

## Workers / Procesos en background

**Estado**: NO IMPLEMENTADO

No hay workers o procesos en background.

### Workers potenciales (sugerencias)

1. **Worker de procesamiento de CVs**

    - Descripción: Procesar CVs subidos para extraer texto, keywords, etc.
    - Tecnología sugerida: Node.js worker threads o servicio separado

2. **Worker de notificaciones**

    - Descripción: Enviar emails/notificaciones cuando se crean candidatos
    - Tecnología sugerida: Cola de mensajes (Bull, RabbitMQ) o servicio externo

3. **Worker de sincronización**
    - Descripción: Sincronizar con sistemas externos (ATS, HRIS)
    - Tecnología sugerida: Cola de mensajes

## Colas de mensajes

**Estado**: NO IMPLEMENTADO

No hay sistema de colas de mensajes.

### Tecnologías sugeridas (si se implementa)

-   **Bull**: Cola de trabajos para Node.js (Redis-based)
-   **RabbitMQ**: Message broker
-   **AWS SQS**: Si se despliega en AWS
-   **Google Cloud Tasks**: Si se despliega en GCP

## Cron Jobs

**Estado**: NO IMPLEMENTADO

No hay cron jobs configurados.

### Herramientas sugeridas (si se implementa)

-   **node-cron**: Librería para cron jobs en Node.js
-   **Agenda**: Job scheduling para Node.js (MongoDB-based)
-   **Cron en Docker**: Usar imagen con cron si se containeriza
-   **Cloud Scheduler**: Si se despliega en cloud (AWS EventBridge, GCP Cloud Scheduler)

## Integraciones externas

**Estado**: NO IMPLEMENTADO

No hay integraciones con sistemas externos detectadas.

### Integraciones potenciales

1. **ATS (Applicant Tracking System)**

    - Sincronización bidireccional de candidatos
    - Webhooks para eventos

2. **Email service** (SendGrid, Mailgun, AWS SES)

    - Notificaciones a candidatos
    - Confirmaciones de recepción

3. **Storage en cloud** (AWS S3, Google Cloud Storage)

    - Almacenamiento de CVs en lugar de filesystem local
    - Mejor escalabilidad

4. **Analytics** (Google Analytics, Mixpanel)
    - Tracking de uso de la aplicación

## Webhooks

**Estado**: NO IMPLEMENTADO

No hay sistema de webhooks para notificar a sistemas externos.

### Webhooks potenciales

1. **CandidateCreated webhook**

    - Notificar cuando se crea un candidato
    - Payload: Datos del candidato

2. **ResumeUploaded webhook**
    - Notificar cuando se sube un CV
    - Payload: Información del archivo

## Notas

-   El sistema actual es **síncrono**: Todas las operaciones se completan en la request HTTP
-   No hay procesamiento asíncrono
-   No hay necesidad de workers actualmente dado el alcance del proyecto
-   Si se escala, sería recomendable implementar:
    -   Cola para procesamiento de CVs
    -   Jobs para limpieza y mantenimiento
    -   Eventos para desacoplar componentes
