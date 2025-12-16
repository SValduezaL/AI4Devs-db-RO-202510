import { Request, Response, NextFunction } from 'express';
import express from 'express';
import { PrismaClient } from '@prisma/client';
import dotenv from 'dotenv';
import candidateRoutes from './routes/candidateRoutes';
import { uploadFile } from './application/services/fileUploadService';
import cors from 'cors';

// Extender la interfaz Request para incluir prisma
declare global {
  namespace Express {
    interface Request {
      prisma: PrismaClient;
    }
  }
}

// Cargar .env desde la raíz del proyecto (donde está docker-compose.yml)
// Solución que funciona tanto en desarrollo (ts-node-dev) como en producción (compilado)
// En desarrollo: __dirname es backend/src, en producción: __dirname es backend/dist
import path from 'path';
import fs from 'fs';

const getRootEnvPath = (): string => {
  // En desarrollo: __dirname = backend/src, subir 2 niveles → raíz
  // En producción: __dirname = backend/dist, subir 2 niveles → raíz
  const rootPath = path.resolve(__dirname, '../..');
  const envPath = path.join(rootPath, '.env');
  
  // Verificar que el archivo existe
  if (fs.existsSync(envPath)) {
    return envPath;
  }
  
  // Fallback: si no encontramos en la raíz, usar process.cwd()
  // Esto cubre casos donde se ejecuta desde otro directorio
  const cwd = process.cwd();
  if (cwd.endsWith('backend')) {
    return path.resolve(cwd, '..', '.env');
  }
  
  return path.join(cwd, '.env');
};

dotenv.config({ path: getRootEnvPath() });
const prisma = new PrismaClient();

export const app = express();
export default app;

// Middleware para parsear JSON. Asegúrate de que esto esté antes de tus rutas.
app.use(express.json());

// Middleware para adjuntar prisma al objeto de solicitud
app.use((req, res, next) => {
  req.prisma = prisma;
  next();
});

// Middleware para permitir CORS desde http://localhost:3000
app.use(cors({
  origin: 'http://localhost:3000',
  credentials: true
}));

// Middleware de logging (debe ir ANTES de las rutas para que se ejecute)
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.path}`);
  next();
});

// Import and use candidateRoutes
app.use('/candidates', candidateRoutes);

// Route for file uploads
app.post('/upload', uploadFile);

const port = 3010;

app.get('/', (req, res) => {
  res.send('Hola LTI!');
});

app.use((err: any, req: Request, res: Response, next: NextFunction) => {
  console.error(err.stack);
  res.type('text/plain'); 
  res.status(500).send('Something broke!');
});

app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});
