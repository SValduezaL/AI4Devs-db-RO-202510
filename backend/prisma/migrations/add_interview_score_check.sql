-- Migration: Add check constraint for Interview.score
-- This constraint ensures score is NULL or between 0-100
-- Run this after creating the Interview table if the constraint is not already present

-- Check if constraint already exists before adding
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint 
        WHERE conname = 'Interview_score_check'
    ) THEN
        ALTER TABLE "Interview" 
        ADD CONSTRAINT "Interview_score_check" 
        CHECK ("score" IS NULL OR ("score" >= 0 AND "score" <= 100));
    END IF;
END $$;

