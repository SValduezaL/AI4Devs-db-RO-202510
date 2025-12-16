# Linting & Formatting

## Estado actual

### Backend

**Linting**: ✅ Configurado (ESLint 9.2.0)

**Formatting**: ✅ Configurado (Prettier 3.2.5)

**Dependencias**:

-   `eslint`: 9.2.0
-   `prettier`: 3.2.5
-   `eslint-config-prettier`: 9.1.0
-   `eslint-plugin-prettier`: 5.1.3

**Configuración**: UNKNOWN (no se detecta archivo `.eslintrc` o `eslint.config.js`)

### Frontend

**Linting**: ✅ Configurado (via Create React App)

**Formatting**: UNKNOWN

**Configuración**: `package.json` tiene `eslintConfig` con `react-app` y `react-app/jest`

## Ejecutar linting

### Backend

```bash
cd backend

# Ejecutar ESLint (comando UNKNOWN - no detectado en package.json)
npx eslint src/

# Fix automático
npx eslint src/ --fix
```

### Frontend

```bash
cd frontend

# Ejecutar ESLint
npm run lint  # Si está configurado en package.json
# O
npx eslint src/
```

## Ejecutar formatting

### Backend

```bash
cd backend

# Formatear con Prettier
npx prettier --write "src/**/*.{ts,js}"

# Verificar sin modificar
npx prettier --check "src/**/*.{ts,js}"
```

### Frontend

**Estado**: UNKNOWN (no se detecta Prettier en frontend)

## Convenciones detectadas

### TypeScript

-   **Strict mode**: Habilitado en `tsconfig.json`
-   **Target**: ES5
-   **Module**: CommonJS (backend), ESNext (frontend)

### Naming

-   **Archivos**: `camelCase.ts` (backend), `PascalCase.tsx` (frontend componentes)
-   **Clases**: `PascalCase`
-   **Funciones**: `camelCase`
-   **Constantes**: UNKNOWN

## Configuración sugerida

### Backend ESLint

Crear `.eslintrc.js` o `eslint.config.js`:

```javascript
module.exports = {
    extends: [
        "eslint:recommended",
        "plugin:@typescript-eslint/recommended",
        "prettier",
    ],
    parser: "@typescript-eslint/parser",
    plugins: ["@typescript-eslint", "prettier"],
    rules: {
        "prettier/prettier": "error",
    },
};
```

### Backend Prettier

Crear `.prettierrc`:

```json
{
    "semi": true,
    "trailingComma": "es5",
    "singleQuote": true,
    "printWidth": 100,
    "tabWidth": 2
}
```

## Pre-commit hooks

**Estado**: NO CONFIGURADO

**Sugerencia**: Usar Husky + lint-staged:

```bash
npm install --save-dev husky lint-staged
```

## Notas

-   **Configuración de ESLint no visible**: Existe pero no se detecta archivo de config
-   **Prettier configurado pero sin archivo de config visible**
-   **No hay pre-commit hooks**: Linting no se ejecuta automáticamente
