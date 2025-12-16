# Deployment

## Estado actual

**Deployment**: NO CONFIGURADO

No hay configuración de deployment a producción detectada en el repositorio.

## Componentes a desplegar

1. **Backend API** (Express + Node.js)
2. **Frontend** (React SPA)
3. **PostgreSQL** (Base de datos)
4. **File storage** (Archivos CVs)

## Opciones de deployment

### Opción 1: VPS / Servidor tradicional

**Stack sugerido**:

-   **Backend**: Node.js process (PM2 para gestión)
-   **Frontend**: Nginx como reverse proxy y servidor de archivos estáticos
-   **Base de datos**: PostgreSQL en servidor o Docker
-   **Storage**: Filesystem local o montado

**Pros**:

-   Control total
-   Costo predecible
-   Flexibilidad

**Contras**:

-   Requiere mantenimiento
-   Escalabilidad manual

### Opción 2: Docker Compose

**Stack sugerido**:

-   **Backend**: Container Node.js
-   **Frontend**: Container Nginx con build estático
-   **Base de datos**: Container PostgreSQL
-   **Storage**: Volume Docker

**Pros**:

-   Fácil de replicar
-   Ya tiene docker-compose.yml (parcial)

**Contras**:

-   No es ideal para alta disponibilidad
-   Un solo servidor

**Archivos necesarios**:

-   `Dockerfile` para backend
-   `Dockerfile` para frontend
-   `docker-compose.prod.yml`

### Opción 3: Cloud Platform (AWS, GCP, Azure)

#### AWS

**Servicios sugeridos**:

-   **Backend**: Elastic Beanstalk o ECS/Fargate
-   **Frontend**: S3 + CloudFront
-   **Base de datos**: RDS PostgreSQL
-   **Storage**: S3 para CVs

**Pros**:

-   Escalable
-   Managed services
-   Alta disponibilidad

**Contras**:

-   Costo variable
-   Curva de aprendizaje

#### Google Cloud Platform

**Servicios sugeridos**:

-   **Backend**: Cloud Run o App Engine
-   **Frontend**: Cloud Storage + Cloud CDN
-   **Base de datos**: Cloud SQL PostgreSQL
-   **Storage**: Cloud Storage

#### Azure

**Servicios sugeridos**:

-   **Backend**: App Service
-   **Frontend**: Static Web Apps o Blob Storage + CDN
-   **Base de datos**: Azure Database for PostgreSQL
-   **Storage**: Blob Storage

### Opción 4: Platform as a Service (PaaS)

#### Heroku

**Stack**:

-   **Backend**: Heroku dyno
-   **Frontend**: Heroku dyno o Netlify/Vercel
-   **Base de datos**: Heroku Postgres
-   **Storage**: Heroku filesystem (ephemeral) o S3

**Pros**:

-   Muy fácil de desplegar
-   Git-based deployment

**Contras**:

-   Costo puede escalar
-   Filesystem efímero (necesita S3)

#### Railway

**Stack**:

-   **Backend**: Railway service
-   **Frontend**: Railway service o Vercel
-   **Base de datos**: Railway PostgreSQL
-   **Storage**: Railway volume o S3

#### Render

**Stack**:

-   **Backend**: Render web service
-   **Frontend**: Render static site
-   **Base de datos**: Render PostgreSQL
-   **Storage**: Render disk o S3

## Consideraciones de deployment

### Variables de entorno producción

**Backend**:

```env
NODE_ENV=production
DATABASE_URL=postgresql://user:pass@host:5432/db
PORT=3010
CORS_ORIGIN=https://yourdomain.com
UPLOAD_PATH=/app/uploads
```

**Frontend**:

```env
REACT_APP_API_URL=https://api.yourdomain.com
```

### Base de datos

1. **Migraciones**: Ejecutar `npx prisma migrate deploy` en producción (no `migrate dev`)
2. **Backups**: Configurar backups automáticos
3. **Connection pooling**: Considerar PgBouncer o Prisma connection pooling

### File storage

**Problema actual**: Archivos en filesystem local (`../uploads/`)

**Soluciones**:

1. **Cloud Storage**: Migrar a S3, GCS, o Azure Blob
2. **Volume persistente**: Si se usa Docker, usar volumen
3. **NFS**: Montar network filesystem

**Código a modificar**: `backend/src/application/services/fileUploadService.ts`

### Seguridad

1. **HTTPS**: Obligatorio en producción
2. **CORS**: Configurar origen correcto
3. **Rate limiting**: Implementar (no existe actualmente)
4. **Autenticación**: Implementar (no existe actualmente)
5. **Secrets**: Usar secret management (no hardcodear en código)

### Monitoreo

**No implementado actualmente**. Considerar:

-   **Logging**: Servicio de logs (CloudWatch, Stackdriver, etc.)
-   **APM**: Application Performance Monitoring (New Relic, Datadog, etc.)
-   **Health checks**: Endpoint mejorado que verifique BD
-   **Alertas**: Notificaciones de errores

### CI/CD

**No implementado actualmente**. Considerar:

-   **GitHub Actions**: Para tests y deployment
-   **GitLab CI**: Si se usa GitLab
-   **CircleCI / Travis CI**: Alternativas

**Pipeline sugerido**:

1. Tests automáticos
2. Build
3. Deploy a staging
4. Tests de integración
5. Deploy a producción

## Dockerfiles sugeridos

### Backend Dockerfile

```dockerfile
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY . .
RUN npm run build

EXPOSE 3010

CMD ["npm", "start"]
```

### Frontend Dockerfile

```dockerfile
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=builder /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

## Docker Compose para producción

```yaml
version: "3.8"

services:
    backend:
        build: ./backend
        ports:
            - "3010:3010"
        environment:
            - DATABASE_URL=postgresql://postgres:password@db:5432/mydatabase
            - NODE_ENV=production
        volumes:
            - uploads:/app/uploads
        depends_on:
            - db

    frontend:
        build: ./frontend
        ports:
            - "80:80"
        depends_on:
            - backend

    db:
        image: postgres:15
        environment:
            POSTGRES_PASSWORD: ${DB_PASSWORD}
            POSTGRES_USER: ${DB_USER}
            POSTGRES_DB: ${DB_NAME}
        volumes:
            - postgres_data:/var/lib/postgresql/data

volumes:
    postgres_data:
    uploads:
```

## Checklist de deployment

### Pre-deployment

-   [ ] Variables de entorno configuradas
-   [ ] Base de datos creada y migraciones aplicadas
-   [ ] Build de frontend exitoso
-   [ ] Tests pasando
-   [ ] CORS configurado para dominio producción
-   [ ] HTTPS configurado
-   [ ] Secrets en lugar seguro (no en código)

### Post-deployment

-   [ ] Health check funcionando
-   [ ] Base de datos accesible
-   [ ] Upload de archivos funcionando
-   [ ] Frontend carga correctamente
-   [ ] API responde correctamente
-   [ ] Logs funcionando
-   [ ] Monitoreo configurado
-   [ ] Backups configurados

## Notas

-   **No hay configuración de deployment actual**: Todo es local/desarrollo
-   **Filesystem local no es escalable**: Necesita migración a cloud storage
-   **No hay CI/CD**: Deployment sería manual
-   **No hay health checks robustos**: Solo endpoint básico
-   **No hay autenticación**: API es abierta (riesgo de seguridad)

## Preguntas para el equipo

1. **Target de deployment**: ¿Dónde se desplegará? (Cloud, VPS, PaaS)
2. **Presupuesto**: ¿Cuál es el presupuesto para infraestructura?
3. **Escala esperada**: ¿Cuántos usuarios/candidatos se esperan?
4. **Disponibilidad**: ¿Qué nivel de disponibilidad se requiere?
5. **Backup strategy**: ¿Cómo se gestionarán backups?
