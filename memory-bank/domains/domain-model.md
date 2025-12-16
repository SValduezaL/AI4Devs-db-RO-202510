# Domain Model

## Entidades principales

### Candidate (Candidato)

**Descripción**: Entidad central que representa un candidato en el sistema de reclutamiento.

**Atributos**:

-   `id` (Int, PK, autoincrement): Identificador único
-   `firstName` (String, 100): Nombre del candidato
-   `lastName` (String, 100): Apellido del candidato
-   `email` (String, 255, unique): Email del candidato (único)
-   `phone` (String, 15, optional): Teléfono del candidato
-   `address` (String, 100, optional): Dirección del candidato

**Relaciones**:

-   `educations`: One-to-Many con Education
-   `workExperiences`: One-to-Many con WorkExperience
-   `resumes`: One-to-Many con Resume
-   `applications`: One-to-Many con Application (nuevo)

**Ubicación**: `backend/src/domain/models/Candidate.ts`, `backend/prisma/schema.prisma`

**Métodos**:

-   `save()`: Persiste el candidato y sus relaciones en cascada
-   `static findOne(id)`: Busca un candidato por ID

**Reglas de negocio**:

-   Email debe ser único en el sistema
-   Email es obligatorio
-   Nombre y apellido son obligatorios

### Education (Educación)

**Descripción**: Representa un registro educativo de un candidato (título, universidad, etc.).

**Atributos**:

-   `id` (Int, PK, autoincrement): Identificador único
-   `institution` (String, 100): Nombre de la institución educativa
-   `title` (String, 250): Título o grado obtenido
-   `startDate` (DateTime): Fecha de inicio
-   `endDate` (DateTime, optional): Fecha de finalización (null si en curso)
-   `candidateId` (Int, FK): Referencia al candidato

**Relaciones**:

-   `candidate`: Many-to-One con Candidate

**Ubicación**: `backend/src/domain/models/Education.ts`, `backend/prisma/schema.prisma`

**Reglas de negocio**:

-   Institución y título son obligatorios
-   Fecha de inicio es obligatoria
-   Fecha de fin es opcional (puede estar en curso)
-   **UNKNOWN**: No se valida que `endDate > startDate` (debería validarse)

### WorkExperience (Experiencia Laboral)

**Descripción**: Representa una experiencia laboral de un candidato.

**Atributos**:

-   `id` (Int, PK, autoincrement): Identificador único
-   `company` (String, 100): Nombre de la empresa
-   `position` (String, 100): Puesto ocupado
-   `description` (String, 200, optional): Descripción de responsabilidades
-   `startDate` (DateTime): Fecha de inicio
-   `endDate` (DateTime, optional): Fecha de finalización (null si actual)
-   `candidateId` (Int, FK): Referencia al candidato

**Relaciones**:

-   `candidate`: Many-to-One con Candidate

**Ubicación**: `backend/src/domain/models/WorkExperience.ts`, `backend/prisma/schema.prisma`

**Reglas de negocio**:

-   Empresa y puesto son obligatorios
-   Fecha de inicio es obligatoria
-   Fecha de fin es opcional (puede ser trabajo actual)
-   **UNKNOWN**: No se valida que `endDate > startDate`

### Resume (CV)

**Descripción**: Representa un archivo CV subido por un candidato.

**Atributos**:

-   `id` (Int, PK, autoincrement): Identificador único
-   `filePath` (String, 500): Ruta del archivo en el sistema de archivos
-   `fileType` (String, 50): Tipo MIME del archivo (application/pdf, application/vnd.openxmlformats-officedocument.wordprocessingml.document)
-   `uploadDate` (DateTime): Fecha de subida (auto-generada por Prisma)
-   `candidateId` (Int, FK): Referencia al candidato

**Relaciones**:

-   `candidate`: Many-to-One con Candidate

**Ubicación**: `backend/src/domain/models/Resume.ts`, `backend/prisma/schema.prisma`

**Reglas de negocio**:

-   Solo se permiten PDF y DOCX
-   Tamaño máximo: 10MB
-   Un candidato puede tener múltiples CVs (relación One-to-Many)

## Nuevas entidades (añadidas 2025-12-16)

### Company (Empresa)

**Descripción**: Representa una empresa que publica posiciones de trabajo.

**Atributos**:

-   `id` (Int, PK, autoincrement): Identificador único
-   `name` (String, 255): Nombre de la empresa
-   `createdAt` (DateTime): Fecha de creación
-   `updatedAt` (DateTime): Fecha de última actualización

**Relaciones**:

-   `employees`: One-to-Many con Employee
-   `positions`: One-to-Many con Position

**Ubicación**: `backend/prisma/schema.prisma`

**Reglas de negocio**:

-   Nombre es obligatorio
-   Índice en nombre para búsquedas

### Employee (Empleado)

**Descripción**: Representa un empleado de una empresa que puede realizar entrevistas.

**Atributos**:

-   `id` (Int, PK, autoincrement): Identificador único
-   `companyId` (Int, FK): Referencia a Company
-   `name` (String, 255): Nombre del empleado
-   `email` (String, 255, unique): Email del empleado (único)
-   `role` (String, 100): Rol del empleado
-   `isActive` (Boolean): Si el empleado está activo
-   `createdAt` (DateTime): Fecha de creación
-   `updatedAt` (DateTime): Fecha de última actualización

**Relaciones**:

-   `company`: Many-to-One con Company
-   `interviews`: One-to-Many con Interview

**Ubicación**: `backend/prisma/schema.prisma`

**Reglas de negocio**:

-   Email único en el sistema
-   Índices en companyId, isActive, role

### Position (Posición)

**Descripción**: Representa una posición de trabajo disponible.

**Atributos**:

-   `id` (Int, PK, autoincrement): Identificador único
-   `companyId` (Int, FK): Referencia a Company
-   `interviewFlowId` (Int, FK): Referencia a InterviewFlow
-   `title` (String, 255): Título de la posición
-   `description` (Text, optional): Descripción general
-   `status` (String, 50): Estado (draft, published, closed, etc.)
-   `isVisible` (Boolean): Si la posición es visible públicamente
-   `location` (String, 255, optional): Ubicación
-   `jobDescription` (Text, optional): Descripción del trabajo
-   `requirements` (Text, optional): Requisitos
-   `responsibilities` (Text, optional): Responsabilidades
-   `salaryMin` (Decimal, optional): Salario mínimo
-   `salaryMax` (Decimal, optional): Salario máximo
-   `employmentType` (String, 50, optional): Tipo de empleo (full-time, part-time, etc.)
-   `benefits` (Text, optional): Beneficios
-   `companyDescription` (Text, optional): Descripción de la empresa
-   `applicationDeadline` (Date, optional): Fecha límite de aplicación
-   `contactInfo` (String, 255, optional): Información de contacto
-   `createdAt` (DateTime): Fecha de creación
-   `updatedAt` (DateTime): Fecha de última actualización

**Relaciones**:

-   `company`: Many-to-One con Company
-   `interviewFlow`: Many-to-One con InterviewFlow
-   `applications`: One-to-Many con Application

**Ubicación**: `backend/prisma/schema.prisma`

**Reglas de negocio**:

-   Status por defecto: 'draft'
-   isVisible por defecto: false
-   Índices en companyId, interviewFlowId, status, isVisible, applicationDeadline

### InterviewFlow (Flujo de Entrevista)

**Descripción**: Representa un flujo de entrevista predefinido que se asigna a posiciones.

**Atributos**:

-   `id` (Int, PK, autoincrement): Identificador único
-   `description` (String, 500, optional): Descripción del flujo
-   `createdAt` (DateTime): Fecha de creación
-   `updatedAt` (DateTime): Fecha de última actualización

**Relaciones**:

-   `steps`: One-to-Many con InterviewStep
-   `positions`: One-to-Many con Position

**Ubicación**: `backend/prisma/schema.prisma`

### InterviewStep (Paso de Entrevista)

**Descripción**: Representa un paso individual dentro de un flujo de entrevista.

**Atributos**:

-   `id` (Int, PK, autoincrement): Identificador único
-   `interviewFlowId` (Int, FK): Referencia a InterviewFlow
-   `interviewTypeId` (Int, FK): Referencia a InterviewType
-   `name` (String, 255): Nombre del paso
-   `orderIndex` (Int): Orden dentro del flujo
-   `createdAt` (DateTime): Fecha de creación
-   `updatedAt` (DateTime): Fecha de última actualización

**Relaciones**:

-   `interviewFlow`: Many-to-One con InterviewFlow
-   `interviewType`: Many-to-One con InterviewType
-   `interviews`: One-to-Many con Interview

**Ubicación**: `backend/prisma/schema.prisma`

**Reglas de negocio**:

-   orderIndex determina el orden de ejecución
-   Índice compuesto en (interviewFlowId, orderIndex) para ordenamiento eficiente

### InterviewType (Tipo de Entrevista)

**Descripción**: Representa tipos de entrevista (técnica, HR, cultural, etc.).

**Atributos**:

-   `id` (Int, PK, autoincrement): Identificador único
-   `name` (String, 100, unique): Nombre del tipo (único)
-   `description` (Text, optional): Descripción del tipo
-   `createdAt` (DateTime): Fecha de creación
-   `updatedAt` (DateTime): Fecha de última actualización

**Relaciones**:

-   `steps`: One-to-Many con InterviewStep

**Ubicación**: `backend/prisma/schema.prisma`

**Reglas de negocio**:

-   Nombre único en el sistema

### Application (Aplicación)

**Descripción**: Representa una aplicación de un candidato a una posición.

**Atributos**:

-   `id` (Int, PK, autoincrement): Identificador único
-   `positionId` (Int, FK): Referencia a Position
-   `candidateId` (Int, FK): Referencia a Candidate
-   `applicationDate` (Date): Fecha de aplicación (por defecto: hoy)
-   `status` (String, 50): Estado (pending, in_review, accepted, rejected, etc.)
-   `notes` (Text, optional): Notas sobre la aplicación
-   `createdAt` (DateTime): Fecha de creación
-   `updatedAt` (DateTime): Fecha de última actualización

**Relaciones**:

-   `position`: Many-to-One con Position
-   `candidate`: Many-to-One con Candidate
-   `interviews`: One-to-Many con Interview

**Ubicación**: `backend/prisma/schema.prisma`

**Reglas de negocio**:

-   Status por defecto: 'pending'
-   Índices en positionId, candidateId, status, applicationDate
-   Índice compuesto en (positionId, candidateId) para evitar duplicados

### Interview (Entrevista)

**Descripción**: Representa una entrevista realizada como parte del proceso de selección.

**Atributos**:

-   `id` (Int, PK, autoincrement): Identificador único
-   `applicationId` (Int, FK): Referencia a Application
-   `interviewStepId` (Int, FK): Referencia a InterviewStep
-   `employeeId` (Int, FK): Referencia a Employee (entrevistador)
-   `interviewDate` (DateTime): Fecha y hora de la entrevista
-   `result` (String, 50, optional): Resultado (passed, failed, pending, etc.)
-   `score` (Int, optional): Puntuación (0-100)
-   `notes` (Text, optional): Notas de la entrevista
-   `createdAt` (DateTime): Fecha de creación
-   `updatedAt` (DateTime): Fecha de última actualización

**Relaciones**:

-   `application`: Many-to-One con Application
-   `interviewStep`: Many-to-One con InterviewStep
-   `employee`: Many-to-One con Employee

**Ubicación**: `backend/prisma/schema.prisma`

**Reglas de negocio**:

-   Score debe estar entre 0 y 100 (check constraint)
-   Índices en applicationId, interviewStepId, employeeId, interviewDate, result

## Modelo de datos (Prisma Schema)

```prisma
model Candidate {
  id                Int               @id @default(autoincrement())
  firstName         String            @db.VarChar(100)
  lastName          String            @db.VarChar(100)
  email             String            @unique @db.VarChar(255)
  phone             String?           @db.VarChar(15)
  address           String?           @db.VarChar(100)
  educations        Education[]
  workExperiences   WorkExperience[]
  resumes           Resume[]
}

model Education {
  id            Int       @id @default(autoincrement())
  institution   String    @db.VarChar(100)
  title         String    @db.VarChar(250)
  startDate     DateTime
  endDate       DateTime?
  candidateId   Int
  candidate     Candidate @relation(fields: [candidateId], references: [id])
}

model WorkExperience {
  id          Int       @id @default(autoincrement())
  company     String    @db.VarChar(100)
  position    String    @db.VarChar(100)
  description String?   @db.VarChar(200)
  startDate   DateTime
  endDate     DateTime?
  candidateId Int
  candidate   Candidate @relation(fields: [candidateId], references: [id])
}

model Resume {
  id          Int       @id @default(autoincrement())
  filePath    String    @db.VarChar(500)
  fileType    String    @db.VarChar(50)
  uploadDate  DateTime
  candidateId Int
  candidate   Candidate @relation(fields: [candidateId], references: [id])
}
```

**Ubicación**: `backend/prisma/schema.prisma`

## Patrones de dominio

### Active Record Pattern

Los modelos de dominio implementan el patrón Active Record:

-   Tienen métodos de instancia para persistencia (`save()`)
-   Tienen métodos estáticos para consultas (`findOne()`)
-   Encapsulan lógica de persistencia

**Ejemplo**:

```typescript
const candidate = new Candidate(data);
await candidate.save(); // Persiste en BD
```

**Ubicación**: `backend/src/domain/models/*.ts`

### Agregado (Aggregate)

**Aggregate Root**: `Candidate`

-   Contiene las entidades relacionadas (Education, WorkExperience, Resume)
-   Se persiste como una unidad transaccional
-   Las entidades hijas no tienen sentido sin el candidato

**Entidades relacionadas**: Education, WorkExperience, Resume son parte del agregado Candidate.

## Validaciones de dominio

### Candidate

-   Email único (constraint de base de datos)
-   Nombre y apellido: 2-100 caracteres, solo letras y espacios
-   Email: formato válido (regex)
-   Teléfono: formato español (6, 7 o 9 + 8 dígitos) o vacío

**Ubicación**: `backend/src/application/validator.ts`

### Education

-   Institución: obligatorio, máximo 100 caracteres
-   Título: obligatorio, máximo 100 caracteres (schema permite 250)
-   Fecha inicio: formato YYYY-MM-DD
-   Fecha fin: formato YYYY-MM-DD o vacío

### WorkExperience

-   Empresa: obligatorio, máximo 100 caracteres
-   Puesto: obligatorio, máximo 100 caracteres
-   Descripción: opcional, máximo 200 caracteres
-   Fechas: formato YYYY-MM-DD

### Resume

-   Tipo de archivo: solo PDF o DOCX
-   Tamaño: máximo 10MB
-   Ruta: debe existir en sistema de archivos

## Invariantes de dominio

1. **Email único**: No puede haber dos candidatos con el mismo email
2. **Fechas válidas**: `endDate` debe ser posterior a `startDate` (NO IMPLEMENTADO - debería validarse)
3. **Archivo existe**: La ruta del CV debe apuntar a un archivo existente (validación implícita)

## Conceptos implementados (2025-12-16)

-   ✅ **Estados de aplicación**: Campo `status` en Application (pending, in_review, accepted, rejected, etc.)
-   ✅ **Etapas del proceso**: InterviewFlow e InterviewStep para tracking de etapas de selección
-   ✅ **Notas/comentarios**: Campo `notes` en Application e Interview
-   ✅ **Timestamps automáticos**: `createdAt` y `updatedAt` en todas las tablas

## Conceptos ausentes (UNKNOWN)

-   **Estados del candidato**: No hay estados a nivel de candidato (solo a nivel de aplicación)
-   **Tags/categorías**: No hay sistema de etiquetado
-   **Historial de cambios**: No hay auditoría de cambios (solo timestamps básicos)

## Extensiones sugeridas

1. ✅ **Timestamps automáticos**: Implementado en todas las tablas (2025-12-16)
2. **Validación de fechas**: Implementar validación `endDate > startDate` en Education y WorkExperience
3. **Soft delete**: Añadir campo `deletedAt` para borrado lógico
4. **Estados del candidato**: Añadir campo `status` a Candidate (independiente de Application)
5. **ENUMs para status**: Convertir campos `status` (String) a ENUMs para mayor consistencia
6. **Auditoría avanzada**: Añadir campos `createdBy`, `updatedBy` si se implementa autenticación
