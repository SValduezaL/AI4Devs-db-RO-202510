# API Documentation

## Base URL

**Desarrollo**: `http://localhost:3010`

**Producción**: UNKNOWN

## Endpoints

### POST /candidates

Crea un nuevo candidato con sus datos personales, educación, experiencia laboral y CV.

**Request**:

```http
POST /candidates
Content-Type: application/json
```

**Body**:

```json
{
    "firstName": "Albert",
    "lastName": "Saelices",
    "email": "albert.saelices@gmail.com",
    "phone": "656874937",
    "address": "Calle Sant Dalmir 2, 5ºB. Barcelona",
    "educations": [
        {
            "institution": "UC3M",
            "title": "Computer Science",
            "startDate": "2006-12-31",
            "endDate": "2010-12-26"
        }
    ],
    "workExperiences": [
        {
            "company": "Coca Cola",
            "position": "SWE",
            "description": "",
            "startDate": "2011-01-13",
            "endDate": "2013-01-17"
        }
    ],
    "cv": {
        "filePath": "uploads/1715760936750-cv.pdf",
        "fileType": "application/pdf"
    }
}
```

**Validaciones**:

-   `firstName`: String, 2-100 caracteres, solo letras y espacios (regex: `^[a-zA-ZñÑáéíóúÁÉÍÓÚ ]+$`)
-   `lastName`: String, 2-100 caracteres, solo letras y espacios
-   `email`: String, formato email válido, único en sistema
-   `phone`: String opcional, formato español (6, 7 o 9 + 8 dígitos) o vacío
-   `address`: String opcional, máximo 100 caracteres
-   `educations`: Array opcional
    -   `institution`: String, máximo 100 caracteres
    -   `title`: String, máximo 100 caracteres (schema permite 250)
    -   `startDate`: String, formato `YYYY-MM-DD`
    -   `endDate`: String opcional, formato `YYYY-MM-DD`
-   `workExperiences`: Array opcional
    -   `company`: String, máximo 100 caracteres
    -   `position`: String, máximo 100 caracteres
    -   `description`: String opcional, máximo 200 caracteres
    -   `startDate`: String, formato `YYYY-MM-DD`
    -   `endDate`: String opcional, formato `YYYY-MM-DD`
-   `cv`: Object opcional
    -   `filePath`: String, ruta del archivo
    -   `fileType`: String, MIME type

**Response 201 Created**:

```json
{
  "id": 1,
  "firstName": "Albert",
  "lastName": "Saelices",
  "email": "albert.saelices@gmail.com",
  "phone": "656874937",
  "address": "Calle Sant Dalmir 2, 5ºB. Barcelona",
  "educations": [...],
  "workExperiences": [...],
  "resumes": [...]
}
```

**Response 400 Bad Request**:

```json
{
    "message": "Error message"
}
```

**Errores posibles**:

-   `"Invalid name"`: Nombre o apellido inválido
-   `"Invalid email"`: Email con formato incorrecto
-   `"Invalid phone"`: Teléfono con formato incorrecto
-   `"The email already exists in the database"`: Email duplicado (Prisma P2002)
-   `"No se pudo conectar con la base de datos"`: Error de conexión

**Ubicación**: `backend/src/routes/candidateRoutes.ts`, `backend/src/presentation/controllers/candidateController.ts`

**Especificación OpenAPI**: `backend/api-spec.yaml`

---

### GET /candidates/:id

Obtiene un candidato por su ID.

**Request**:

```http
GET /candidates/1
```

**Parámetros**:

-   `id` (path): ID numérico del candidato

**Response 200 OK**:

```json
{
  "id": 1,
  "firstName": "Albert",
  "lastName": "Saelices",
  "email": "albert.saelices@gmail.com",
  "phone": "656874937",
  "address": "Calle Sant Dalmir 2, 5ºB. Barcelona",
  "educations": [...],
  "workExperiences": [...],
  "resumes": [...]
}
```

**Response 400 Bad Request**:

```json
{
    "message": "Invalid candidate ID"
}
```

**Response 404 Not Found**:

```json
{
    "message": "Candidate not found"
}
```

**Nota**: Este endpoint existe en el código pero **no está expuesto en las rutas actuales**. Solo `POST /candidates` está activo.

**Ubicación**: `backend/src/presentation/controllers/candidateController.ts` (función `getCandidateByIdController`)

---

### POST /upload

Sube un archivo (CV) al servidor.

**Request**:

```http
POST /upload
Content-Type: multipart/form-data
```

**Body** (form-data):

-   `file`: Archivo (PDF o DOCX)

**Validaciones**:

-   Tipo de archivo: Solo `application/pdf` o `application/vnd.openxmlformats-officedocument.wordprocessingml.document` (DOCX)
-   Tamaño máximo: 10MB

**Response 200 OK**:

```json
{
    "filePath": "uploads/1715760936750-cv.pdf",
    "fileType": "application/pdf"
}
```

**Response 400 Bad Request**:

```json
{
    "error": "Invalid file type, only PDF and DOCX are allowed!"
}
```

**Response 500 Internal Server Error**:

```json
{
    "error": "Error message"
}
```

**Ubicación**: `backend/src/index.ts` (ruta directa), `backend/src/application/services/fileUploadService.ts`

**Almacenamiento**: Archivos se guardan en `../uploads/` con nombre `{timestamp}-{originalname}`

---

### GET /

Endpoint básico de health check.

**Request**:

```http
GET /
```

**Response 200 OK**:

```
Hola LTI!
```

**Ubicación**: `backend/src/index.ts`

**Nota**: No verifica conexión a BD ni estado real del sistema.

---

## Endpoints no implementados

### GET /candidates

Lista todos los candidatos.

**Estado**: NO IMPLEMENTADO

**Qué se necesitaría**:

-   Parámetros opcionales: `?limit=10&offset=0`
-   Response: Array de candidatos

---

### PUT /candidates/:id

### PATCH /candidates/:id

Actualiza un candidato existente.

**Estado**: NO IMPLEMENTADO (lógica de update existe en modelo pero no hay endpoint)

---

### DELETE /candidates/:id

Elimina un candidato.

**Estado**: NO IMPLEMENTADO

---

### GET /candidates/:id/resume/:resumeId

### GET /resumes/:id

Descarga un archivo CV.

**Estado**: NO IMPLEMENTADO

---

## Especificación OpenAPI

Existe un archivo `backend/api-spec.yaml` con especificación OpenAPI 3.0.0 que documenta:

-   `POST /candidates`
-   `POST /upload`

**Nota**: La especificación no está servida como Swagger UI actualmente, aunque las dependencias están instaladas (`swagger-ui-express`, `swagger-jsdoc`).

## CORS

Configurado para permitir requests desde:

-   `http://localhost:3000` (frontend)

**Ubicación**: `backend/src/index.ts`

**Configuración**:

```typescript
cors({
    origin: "http://localhost:3000",
    credentials: true,
});
```

## Manejo de errores

### Códigos HTTP

-   `200`: OK
-   `201`: Created
-   `400`: Bad Request (validación fallida, datos inválidos)
-   `404`: Not Found (recurso no existe)
-   `500`: Internal Server Error (error del servidor)

### Formato de errores

**Backend retorna**:

-   JSON con campo `message` o `error`
-   Texto plano en error handler global (inconsistente)

**Ejemplo**:

```json
{
    "message": "Error message"
}
```

## Autenticación

**Estado**: NO IMPLEMENTADO (y no se requiere)

✅ **Confirmado (2025-01-27)**: No se requiere autenticación porque es un ejercicio de aprendizaje, no un producto en producción. La API es abierta.

## Rate Limiting

**Estado**: NO IMPLEMENTADO

No hay límites de requests por IP o usuario.

## Versionado

**Estado**: NO IMPLEMENTADO

No hay versionado de API (ej: `/v1/candidates`).

## Paginación

**Estado**: NO IMPLEMENTADO

No hay endpoints que requieran paginación actualmente (solo existe GET por ID).
