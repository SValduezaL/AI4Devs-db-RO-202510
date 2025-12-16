# Architecture Diagrams

## Diagrama C4 - Context Level

```mermaid
graph TB
    User[Reclutador]
    Frontend[React Frontend<br/>localhost:3000]
    Backend[Express API<br/>localhost:3010]
    DB[(PostgreSQL<br/>Docker)]
    FS[File System<br/>uploads/]

    User -->|Interactúa| Frontend
    Frontend -->|HTTP REST| Backend
    Backend -->|Prisma ORM| DB
    Backend -->|Multer| FS

    style User fill:#e1f5ff
    style Frontend fill:#61dafb
    style Backend fill:#90EE90
    style DB fill:#336791
    style FS fill:#FFD700
```

## Diagrama C4 - Container Level

```mermaid
graph TB
    subgraph "Frontend Application"
        UI[React Components]
        Router[React Router]
        Service[API Service]
    end

    subgraph "Backend Application"
        Express[Express Server]
        Routes[Route Handlers]
        Controllers[Controllers]
        Services[Application Services]
        Models[Domain Models]
        Prisma[Prisma Client]
    end

    subgraph "Data Storage"
        PostgreSQL[(PostgreSQL)]
        FileSystem[File System]
    end

    UI --> Router
    Router --> UI
    UI --> Service
    Service -->|HTTP| Express
    Express --> Routes
    Routes --> Controllers
    Controllers --> Services
    Services --> Models
    Models --> Prisma
    Prisma --> PostgreSQL
    Services --> FileSystem

    style UI fill:#61dafb
    style Express fill:#90EE90
    style PostgreSQL fill:#336791
    style FileSystem fill:#FFD700
```

## Diagrama de Componentes - Backend

```mermaid
graph TB
    subgraph "Presentation Layer"
        Routes[candidateRoutes.ts]
        Controller[candidateController.ts]
        UploadRoute[POST /upload]
    end

    subgraph "Application Layer"
        CandidateService[candidateService.ts]
        FileUploadService[fileUploadService.ts]
        Validator[validator.ts]
    end

    subgraph "Domain Layer"
        Candidate[Candidate Model]
        Education[Education Model]
        WorkExp[WorkExperience Model]
        Resume[Resume Model]
    end

    subgraph "Infrastructure"
        PrismaClient[Prisma Client]
        Multer[Multer]
        PostgreSQL[(PostgreSQL)]
        FileSystem[File System]
    end

    Routes --> Controller
    UploadRoute --> FileUploadService
    Controller --> CandidateService
    CandidateService --> Validator
    CandidateService --> Candidate
    Candidate --> Education
    Candidate --> WorkExp
    Candidate --> Resume
    Candidate --> PrismaClient
    Education --> PrismaClient
    WorkExp --> PrismaClient
    Resume --> PrismaClient
    FileUploadService --> Multer
    Multer --> FileSystem
    PrismaClient --> PostgreSQL

    style Routes fill:#90EE90
    style CandidateService fill:#FFD700
    style Candidate fill:#FFA500
    style PrismaClient fill:#336791
```

## Diagrama de Flujo - Crear Candidato

```mermaid
sequenceDiagram
    participant U as Usuario
    participant F as Frontend
    participant B as Backend API
    participant V as Validator
    participant S as Service
    participant M as Model
    participant P as Prisma
    participant DB as PostgreSQL

    U->>F: Completa formulario + sube CV
    F->>B: POST /upload (file)
    B->>F: { filePath, fileType }
    F->>B: POST /candidates (data + cv)
    B->>V: validateCandidateData()
    V-->>B: OK / Error
    B->>S: addCandidate()
    S->>M: new Candidate()
    M->>P: candidate.create()
    P->>DB: INSERT Candidate
    DB-->>P: Candidate ID
    S->>M: new Education() (loop)
    M->>P: education.create()
    P->>DB: INSERT Education
    S->>M: new WorkExperience() (loop)
    M->>P: workExperience.create()
    P->>DB: INSERT WorkExperience
    S->>M: new Resume()
    M->>P: resume.create()
    P->>DB: INSERT Resume
    P-->>M: Saved data
    M-->>S: Candidate object
    S-->>B: Candidate
    B-->>F: 201 Created
    F-->>U: Éxito
```

## Diagrama de Base de Datos

```mermaid
erDiagram
    Candidate ||--o{ Education : has
    Candidate ||--o{ WorkExperience : has
    Candidate ||--o{ Resume : has

    Candidate {
        int id PK
        string firstName
        string lastName
        string email UK
        string phone
        string address
    }

    Education {
        int id PK
        string institution
        string title
        datetime startDate
        datetime endDate
        int candidateId FK
    }

    WorkExperience {
        int id PK
        string company
        string position
        string description
        datetime startDate
        datetime endDate
        int candidateId FK
    }

    Resume {
        int id PK
        string filePath
        string fileType
        datetime uploadDate
        int candidateId FK
    }
```

## Diagrama de Deployment (Actual)

```mermaid
graph TB
    subgraph "Development Machine"
        Dev[Developer]
        Docker[Docker Desktop]
        FrontendDev[React Dev Server<br/>:3000]
        BackendDev[Node.js Process<br/>:3010]
    end

    subgraph "Docker Container"
        PostgresContainer[PostgreSQL Container<br/>:5432]
    end

    subgraph "File System"
        UploadsDir[uploads/ directory]
    end

    Dev --> FrontendDev
    Dev --> BackendDev
    Dev --> Docker
    Docker --> PostgresContainer
    BackendDev --> PostgresContainer
    BackendDev --> UploadsDir
    FrontendDev -->|HTTP| BackendDev

    style FrontendDev fill:#61dafb
    style BackendDev fill:#90EE90
    style PostgresContainer fill:#336791
    style UploadsDir fill:#FFD700
```

## Notas sobre los diagramas

### Limitaciones

1. **Simplificaciones**:

    - No se muestran todos los middlewares (CORS, logging, error handler)
    - No se muestra la estructura completa de carpetas
    - No se muestran tests

2. **Asunciones**:

    - Frontend y backend en misma máquina (desarrollo)
    - PostgreSQL en Docker local
    - No hay load balancer ni múltiples instancias

3. **Faltantes**:
    - Diagrama de deployment producción (no existe aún)
    - Diagrama de seguridad (autenticación/autorización no implementada)
    - Diagrama de monitoreo (no implementado)

### Actualización

Estos diagramas deben actualizarse cuando:

-   Se añada autenticación
-   Se cambie la arquitectura de deployment
-   Se añadan nuevos componentes significativos
-   Se cambien patrones arquitectónicos
