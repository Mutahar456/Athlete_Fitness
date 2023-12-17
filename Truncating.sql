Use Athlete_FITNESS;

-- Disable all foreign key constraints
EXEC sp_msforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT all'

-- Truncate each table
TRUNCATE TABLE RehabilitationDetails
TRUNCATE TABLE InjuryDetails
TRUNCATE TABLE ExerciseDetails
TRUNCATE TABLE DietDetails
TRUNCATE TABLE WorkoutScheduleDetails
TRUNCATE TABLE ExpensesDetails
TRUNCATE TABLE FitnessHistoryDetails
DELETE FROM RehabilitationDetails WHERE Athlete_ID IN (SELECT Athlete_ID FROM AthleteDetails)
DELETE FROM InjuryDetails WHERE Athlete_ID IN (SELECT Athlete_ID FROM AthleteDetails)
DELETE FROM ExerciseDetails WHERE Athlete_ID IN (SELECT Athlete_ID FROM AthleteDetails)
Delete From AthleteDetails
-- Enable all foreign key constraints
EXEC sp_msforeachtable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all'
