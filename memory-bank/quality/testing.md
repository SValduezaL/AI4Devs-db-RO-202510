# Testing

## Estado actual

### Backend

**Tests implementados**: ✅ Sí

**Framework**: Jest 29.7.0 + ts-jest 29.2.5

**Cobertura**: UNKNOWN (no se detecta configuración de coverage)

**Archivos de test detectados**:
- `backend/src/application/services/candidateService.test.ts`
- `backend/src/presentation/controllers/candidateController.test.ts`
- `backend/src/application/validator.test.ts`
- `backend/src/domain/models/Education.test.ts`

**Configuración**: `backend/jest.config.js`

### Frontend

**Tests implementados**: ⚠️ Parcial

**Framework**: Jest + React Testing Library (configurado en `package.json`)

**Tests escritos**: NO DETECTADOS

No se encuentran archivos `*.test.js` o `*.test.tsx` en `frontend/src/`.

## Configuración de tests

### Backend

**Jest config** (`backend/jest.config.js`):
```javascript
module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  testMatch: ['**/__tests__/**/*.ts', '**/?(*.)+(spec|test).ts'],
  moduleFileExtensions: ['ts', 'js', 'json', 'node'],
};
```

**Ejecutar tests**:
```bash
cd backend
npm test
```

### Frontend

**Configuración**: Create React App incluye Jest por defecto.

**Ejecutar tests**:
```bash
cd frontend
npm test
```

**Nota**: Aunque está configurado, no se detectan tests escritos.

## Estructura de tests

### Backend

**Patrón detectado**: Tests junto a código fuente

**Ejemplos**:
- `candidateService.ts` → `candidateService.test.ts`
- `validator.ts` → `validator.test.ts`
- `Education.ts` → `Education.test.ts`

**Ubicación**: Mismo directorio que el código fuente.

### Frontend

**Patrón esperado** (Create React App):
- Tests en mismo directorio que componentes
- Nombre: `ComponentName.test.js` o `ComponentName.test.tsx`

## Tipos de tests

### Tests unitarios (Backend)

**Implementados**:
- ✅ Tests de servicios (`candidateService.test.ts`)
- ✅ Tests de controladores (`candidateController.test.ts`)
- ✅ Tests de validación (`validator.test.ts`)
- ✅ Tests de modelos (`Education.test.ts`)

### Tests de integración

**Estado**: NO IMPLEMENTADOS

No se detectan tests que prueben:
- Flujo completo de creación de candidato
- Integración con base de datos
- Integración con filesystem

### Tests E2E

**Estado**: NO IMPLEMENTADOS

No hay tests end-to-end que prueben:
- Flujo completo frontend → backend → BD
- Interacción de usuario completa

### Tests de frontend

**Estado**: NO IMPLEMENTADOS

No se detectan tests para:
- Componentes React
- Servicios de API
- Interacciones de usuario

## Ejecutar tests

### Backend

```bash
cd backend

# Ejecutar todos los tests
npm test

# Ejecutar en modo watch
npm test -- --watch

# Ejecutar con coverage
npm test -- --coverage

# Ejecutar un archivo específico
npm test candidateService.test.ts
```

### Frontend

```bash
cd frontend

# Ejecutar todos los tests
npm test

# Ejecutar en modo watch
npm test -- --watch

# Ejecutar con coverage
npm test -- --coverage
```

## Cobertura de código

### Backend

**Estado**: UNKNOWN

No se detecta configuración explícita de coverage, pero Jest lo soporta:

```bash
npm test -- --coverage
```

**Archivos a cubrir**:
- Servicios
- Controladores
- Validadores
- Modelos de dominio

### Frontend

**Estado**: NO APLICABLE (no hay tests)

## Mocks y stubs

### Backend

**Prisma Client**: Probablemente se mockea en tests (UNKNOWN - no se ve código de tests)

**Sugerencia**: Mockear Prisma Client para tests unitarios:

```typescript
jest.mock('@prisma/client', () => ({
  PrismaClient: jest.fn(() => ({
    candidate: {
      create: jest.fn(),
      findUnique: jest.fn(),
    },
  })),
}));
```

### Frontend

**API calls**: Deberían mockearse con `jest.mock()` o `msw` (Mock Service Worker)

## Convenciones de testing

### Naming

**Backend**: `*.test.ts` o `*.spec.ts`

**Frontend**: `*.test.js` o `*.test.tsx`

### Estructura

**Patrón AAA** (Arrange, Act, Assert) recomendado:

```typescript
describe('CandidateService', () => {
  it('should create a candidate', () => {
    // Arrange
    const candidateData = { ... };
    
    // Act
    const result = await addCandidate(candidateData);
    
    // Assert
    expect(result).toBeDefined();
    expect(result.email).toBe(candidateData.email);
  });
});
```

## Tests faltantes

### Backend

1. **Tests de fileUploadService**
   - No se detecta `fileUploadService.test.ts`
   - Debería testear: validación de tipo, tamaño, almacenamiento

2. **Tests de integración**
   - Flujo completo con BD real (test database)
   - Flujo completo con filesystem

3. **Tests de error handling**
   - Errores de Prisma (P2002, P2025, etc.)
   - Errores de filesystem

4. **Tests de rutas**
   - No se detecta `candidateRoutes.test.ts`
   - Debería testear endpoints HTTP

### Frontend

1. **Tests de componentes**
   - `RecruiterDashboard.test.tsx`
   - `AddCandidateForm.test.tsx`
   - `FileUploader.test.tsx`

2. **Tests de servicios**
   - `candidateService.test.js`
   - Mock de fetch/axios

3. **Tests de integración**
   - Flujo completo de formulario
   - Upload de archivo

## Setup de test database

**Estado**: NO CONFIGURADO

Para tests de integración, se recomienda:

1. Base de datos de test separada
2. Migraciones antes de cada suite de tests
3. Limpieza después de cada test

**Ejemplo**:
```typescript
beforeAll(async () => {
  await prisma.$connect();
  await prisma.$executeRaw`TRUNCATE TABLE "Candidate" CASCADE`;
});

afterAll(async () => {
  await prisma.$disconnect();
});
```

## CI/CD Integration

**Estado**: NO CONFIGURADO

No se detecta configuración de CI/CD que ejecute tests automáticamente.

**Sugerencia**: Añadir a GitHub Actions, GitLab CI, etc.:

```yaml
# .github/workflows/test.yml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-node@v2
      - run: cd backend && npm install && npm test
      - run: cd frontend && npm install && npm test
```

## Mejoras sugeridas

### Inmediatas

1. **Añadir tests de fileUploadService**
2. **Añadir tests básicos de frontend**
3. **Configurar coverage reporting**

### Mediano plazo

1. **Tests de integración con BD de test**
2. **Tests E2E con Cypress o Playwright**
3. **CI/CD con ejecución automática de tests**

### Largo plazo

1. **Cobertura objetivo**: > 80%
2. **Tests de performance**
3. **Tests de seguridad**

## Herramientas adicionales

### Backend

- **Supertest**: Para tests de endpoints HTTP
- **Factory Bot**: Para crear datos de test
- **Faker**: Para generar datos aleatorios

### Frontend

- **React Testing Library**: Ya incluido
- **MSW (Mock Service Worker)**: Para mockear API
- **Cypress / Playwright**: Para tests E2E

## Notas

- **Tests backend existen pero cobertura UNKNOWN**
- **Tests frontend no implementados** aunque la configuración está lista
- **No hay tests de integración** que prueben flujos completos
- **No hay CI/CD** que ejecute tests automáticamente

