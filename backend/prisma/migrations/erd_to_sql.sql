-- Script SQL generado a partir del ERD proporcionado
-- Incluye buenas prácticas: índices, normalización, constraints

-- ============================================
-- TABLA: COMPANY
-- ============================================
CREATE TABLE IF NOT EXISTS "Company" (
    "id" SERIAL PRIMARY KEY,
    "name" VARCHAR(255) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Índices para Company
CREATE INDEX IF NOT EXISTS "Company_name_idx" ON "Company"("name");

-- ============================================
-- TABLA: EMPLOYEE
-- ============================================
CREATE TABLE IF NOT EXISTS "Employee" (
    "id" SERIAL PRIMARY KEY,
    "company_id" INTEGER NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "role" VARCHAR(100) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "Employee_company_id_fkey" FOREIGN KEY ("company_id") 
        REFERENCES "Company"("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Índices para Employee
CREATE UNIQUE INDEX IF NOT EXISTS "Employee_email_key" ON "Employee"("email");
CREATE INDEX IF NOT EXISTS "Employee_company_id_idx" ON "Employee"("company_id");
CREATE INDEX IF NOT EXISTS "Employee_is_active_idx" ON "Employee"("is_active");
CREATE INDEX IF NOT EXISTS "Employee_role_idx" ON "Employee"("role");

-- ============================================
-- TABLA: INTERVIEW_TYPE
-- ============================================
CREATE TABLE IF NOT EXISTS "InterviewType" (
    "id" SERIAL PRIMARY KEY,
    "name" VARCHAR(100) NOT NULL,
    "description" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Índices para InterviewType
CREATE UNIQUE INDEX IF NOT EXISTS "InterviewType_name_key" ON "InterviewType"("name");

-- ============================================
-- TABLA: INTERVIEW_FLOW
-- ============================================
CREATE TABLE IF NOT EXISTS "InterviewFlow" (
    "id" SERIAL PRIMARY KEY,
    "description" VARCHAR(500),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABLA: INTERVIEW_STEP
-- ============================================
CREATE TABLE IF NOT EXISTS "InterviewStep" (
    "id" SERIAL PRIMARY KEY,
    "interview_flow_id" INTEGER NOT NULL,
    "interview_type_id" INTEGER NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "order_index" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "InterviewStep_interview_flow_id_fkey" FOREIGN KEY ("interview_flow_id") 
        REFERENCES "InterviewFlow"("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "InterviewStep_interview_type_id_fkey" FOREIGN KEY ("interview_type_id") 
        REFERENCES "InterviewType"("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Índices para InterviewStep
CREATE INDEX IF NOT EXISTS "InterviewStep_interview_flow_id_idx" ON "InterviewStep"("interview_flow_id");
CREATE INDEX IF NOT EXISTS "InterviewStep_interview_type_id_idx" ON "InterviewStep"("interview_type_id");
CREATE INDEX IF NOT EXISTS "InterviewStep_order_index_idx" ON "InterviewStep"("interview_flow_id", "order_index");

-- ============================================
-- TABLA: POSITION
-- ============================================
CREATE TABLE IF NOT EXISTS "Position" (
    "id" SERIAL PRIMARY KEY,
    "company_id" INTEGER NOT NULL,
    "interview_flow_id" INTEGER NOT NULL,
    "title" VARCHAR(255) NOT NULL,
    "description" TEXT,
    "status" VARCHAR(50) NOT NULL DEFAULT 'draft',
    "is_visible" BOOLEAN NOT NULL DEFAULT false,
    "location" VARCHAR(255),
    "job_description" TEXT,
    "requirements" TEXT,
    "responsibilities" TEXT,
    "salary_min" DECIMAL(10, 2),
    "salary_max" DECIMAL(10, 2),
    "employment_type" VARCHAR(50),
    "benefits" TEXT,
    "company_description" TEXT,
    "application_deadline" DATE,
    "contact_info" VARCHAR(255),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "Position_company_id_fkey" FOREIGN KEY ("company_id") 
        REFERENCES "Company"("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Position_interview_flow_id_fkey" FOREIGN KEY ("interview_flow_id") 
        REFERENCES "InterviewFlow"("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Índices para Position
CREATE INDEX IF NOT EXISTS "Position_company_id_idx" ON "Position"("company_id");
CREATE INDEX IF NOT EXISTS "Position_interview_flow_id_idx" ON "Position"("interview_flow_id");
CREATE INDEX IF NOT EXISTS "Position_status_idx" ON "Position"("status");
CREATE INDEX IF NOT EXISTS "Position_is_visible_idx" ON "Position"("is_visible");
CREATE INDEX IF NOT EXISTS "Position_application_deadline_idx" ON "Position"("application_deadline");

-- ============================================
-- TABLA: CANDIDATE (ya existe, pero se mantiene)
-- ============================================
-- La tabla Candidate ya existe en el schema actual
-- Se mantiene sin cambios para compatibilidad

-- ============================================
-- TABLA: APPLICATION
-- ============================================
CREATE TABLE IF NOT EXISTS "Application" (
    "id" SERIAL PRIMARY KEY,
    "position_id" INTEGER NOT NULL,
    "candidate_id" INTEGER NOT NULL,
    "application_date" DATE NOT NULL DEFAULT CURRENT_DATE,
    "status" VARCHAR(50) NOT NULL DEFAULT 'pending',
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "Application_position_id_fkey" FOREIGN KEY ("position_id") 
        REFERENCES "Position"("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Application_candidate_id_fkey" FOREIGN KEY ("candidate_id") 
        REFERENCES "Candidate"("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Índices para Application
CREATE INDEX IF NOT EXISTS "Application_position_id_idx" ON "Application"("position_id");
CREATE INDEX IF NOT EXISTS "Application_candidate_id_idx" ON "Application"("candidate_id");
CREATE INDEX IF NOT EXISTS "Application_status_idx" ON "Application"("status");
CREATE INDEX IF NOT EXISTS "Application_application_date_idx" ON "Application"("application_date");
-- Índice compuesto para búsquedas comunes
CREATE INDEX IF NOT EXISTS "Application_position_candidate_idx" ON "Application"("position_id", "candidate_id");

-- ============================================
-- TABLA: INTERVIEW
-- ============================================
CREATE TABLE IF NOT EXISTS "Interview" (
    "id" SERIAL PRIMARY KEY,
    "application_id" INTEGER NOT NULL,
    "interview_step_id" INTEGER NOT NULL,
    "employee_id" INTEGER NOT NULL,
    "interview_date" TIMESTAMP(3) NOT NULL,
    "result" VARCHAR(50),
    "score" INTEGER,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "Interview_application_id_fkey" FOREIGN KEY ("application_id") 
        REFERENCES "Application"("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "Interview_interview_step_id_fkey" FOREIGN KEY ("interview_step_id") 
        REFERENCES "InterviewStep"("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Interview_employee_id_fkey" FOREIGN KEY ("employee_id") 
        REFERENCES "Employee"("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Interview_score_check" CHECK ("score" IS NULL OR ("score" >= 0 AND "score" <= 100))
);

-- Índices para Interview
CREATE INDEX IF NOT EXISTS "Interview_application_id_idx" ON "Interview"("application_id");
CREATE INDEX IF NOT EXISTS "Interview_interview_step_id_idx" ON "Interview"("interview_step_id");
CREATE INDEX IF NOT EXISTS "Interview_employee_id_idx" ON "Interview"("employee_id");
CREATE INDEX IF NOT EXISTS "Interview_interview_date_idx" ON "Interview"("interview_date");
CREATE INDEX IF NOT EXISTS "Interview_result_idx" ON "Interview"("result");

-- ============================================
-- COMENTARIOS Y DOCUMENTACIÓN
-- ============================================
COMMENT ON TABLE "Company" IS 'Empresas que publican posiciones';
COMMENT ON TABLE "Employee" IS 'Empleados de las empresas que pueden realizar entrevistas';
COMMENT ON TABLE "Position" IS 'Posiciones de trabajo disponibles';
COMMENT ON TABLE "InterviewFlow" IS 'Flujos de entrevista predefinidos';
COMMENT ON TABLE "InterviewStep" IS 'Pasos individuales dentro de un flujo de entrevista';
COMMENT ON TABLE "InterviewType" IS 'Tipos de entrevista (técnica, HR, cultural, etc.)';
COMMENT ON TABLE "Application" IS 'Aplicaciones de candidatos a posiciones';
COMMENT ON TABLE "Interview" IS 'Entrevistas realizadas como parte del proceso de selección';

