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

## Conceptos ausentes (UNKNOWN)

-   **Estados del candidato**: No hay estados (nuevo, en proceso, rechazado, contratado)
-   **Etapas del proceso**: No hay tracking de etapas de selección
-   **Notas/comentarios**: No hay sistema de notas sobre candidatos
-   **Tags/categorías**: No hay sistema de etiquetado
-   **Historial de cambios**: No hay auditoría de cambios

## Extensiones sugeridas

1. **Estados del candidato**: Añadir campo `status` a Candidate
2. **Validación de fechas**: Implementar validación `endDate > startDate`
3. **Soft delete**: Añadir campo `deletedAt` para borrado lógico
4. **Timestamps automáticos**: Añadir `createdAt` y `updatedAt` (Prisma puede hacerlo automáticamente)
