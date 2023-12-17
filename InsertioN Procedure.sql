Use Athlete_FITNESS
--1-- Insertion procedure for AthleteDetails table
CREATE PROCEDURE InsertAthleteDetails (
    @First_Name VARCHAR(50),
    @Last_Name VARCHAR(50),
    @Date_of_Birth DATE,
    @Gender VARCHAR(10),
    @Contact_Info VARCHAR(100),
    @Sport VARCHAR(50)
)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM AthleteDetails WHERE First_Name = @First_Name AND Last_Name = @Last_Name AND Date_of_Birth = @Date_of_Birth)
    BEGIN
        INSERT INTO AthleteDetails (First_Name, Last_Name, Date_of_Birth, Gender, Contact_Info, Sport)
        VALUES (@First_Name, @Last_Name, @Date_of_Birth, @Gender, @Contact_Info, @Sport)
    END
    ELSE
    BEGIN
        PRINT 'Athlete already exists'
    END
END
GO
Drop PROCEDURE InsertAthleteDetails

----------------------------------------------------
--2-- Insertion procedure for FitnessHistoryDetails table
CREATE PROCEDURE InsertFitnessHistoryDetails (
    @Athlete_ID INT,
    @Weight DECIMAL(5,2),
    @Height DECIMAL(5,2),
    @BMI DECIMAL(5,2),
    @Muscular_Strength DECIMAL(5,2),
    @Endurance DECIMAL(5,2),
    @Flexibility DECIMAL(5,2),
    @Date_Recorded DATE
)
AS
BEGIN
    -- Check if the Athlete_ID exists in AthleteDetails table
    IF NOT EXISTS (SELECT 1 FROM AthleteDetails WHERE Athlete_ID = @Athlete_ID)
    BEGIN
        PRINT 'Athlete does not exist. Please provide a valid Athlete_ID.'
        RETURN
    END

    -- Check for duplicate entries for the same Athlete_ID and Date_Recorded
    IF EXISTS (
        SELECT 1 
        FROM FitnessHistoryDetails 
        WHERE Athlete_ID = @Athlete_ID AND Date_Recorded = @Date_Recorded
    )
    BEGIN
        PRINT 'Fitness data for this athlete on the provided date already exists.'
        RETURN
    END

    -- Insert data into FitnessHistoryDetails if checks are successful
    INSERT INTO FitnessHistoryDetails (Athlete_ID, Weight, Height, BMI, Muscular_Strength, Endurance, Flexibility, Date_Recorded)
    VALUES (@Athlete_ID, @Weight, @Height, @BMI, @Muscular_Strength, @Endurance, @Flexibility, @Date_Recorded)
    PRINT 'Fitness history details successfully added.'
END
GO

--3-- Insertion procedure for RehabilitationDetails table
CREATE PROCEDURE InsertRehabilitationDetails (
    @Athlete_ID INT,
    @Start_Date DATE,
    @End_Date DATE,
    @Rehab_Type VARCHAR(50),
    @Notes TEXT
)
AS
BEGIN
    -- Check if the Athlete_ID exists in AthleteDetails table
    IF NOT EXISTS (SELECT 1 FROM AthleteDetails WHERE Athlete_ID = @Athlete_ID)
    BEGIN
        PRINT 'Athlete does not exist. Please provide a valid Athlete_ID.'
        RETURN
    END

    -- Check for overlapping rehabilitation dates for the same Athlete_ID
    IF EXISTS (
        SELECT 1 
        FROM RehabilitationDetails 
        WHERE Athlete_ID = @Athlete_ID 
        AND ((Start_Date <= @Start_Date AND End_Date >= @Start_Date)
        OR (Start_Date <= @End_Date AND End_Date >= @End_Date))
    )
    BEGIN
        PRINT 'The rehabilitation dates overlap with existing records for this athlete.'
        RETURN
    END

    -- Insert data into RehabilitationDetails if checks are successful
    INSERT INTO RehabilitationDetails (Athlete_ID, Start_Date, End_Date, Rehab_Type, Notes)
    VALUES (@Athlete_ID, @Start_Date, @End_Date, @Rehab_Type, @Notes)
    PRINT 'Rehabilitation details successfully added.'
END
GO

--4-- Insertion procedure for InjuryDetails table
CREATE PROCEDURE InsertInjuryDetails (
    @Athlete_ID INT,
    @Injury_Date DATE,
    @Injury_Type VARCHAR(50),
    @Severity VARCHAR(50),
    @Recovery_Status VARCHAR(50)
)
AS
BEGIN
    -- Check if the Athlete_ID exists in AthleteDetails table
    IF NOT EXISTS (SELECT 1 FROM AthleteDetails WHERE Athlete_ID = @Athlete_ID)
    BEGIN
        PRINT 'Athlete does not exist. Please provide a valid Athlete_ID.'
        RETURN
    END

    -- Insert data into InjuryDetails if Athlete_ID is valid
    INSERT INTO InjuryDetails (Athlete_ID, Injury_Date, Injury_Type, Severity, Recovery_Status)
    VALUES (@Athlete_ID, @Injury_Date, @Injury_Type, @Severity, @Recovery_Status)
    PRINT 'Injury details successfully added.'
END
GO
--5-- Insert exercise details procedure 
CREATE PROCEDURE InsertExerciseDetails (
    @Athlete_ID INT,
    @Exercise_Date DATE,
    @Exercise_Type VARCHAR(50),
    @DurationMinutes INT,
    @CaloriesBurned DECIMAL(8,2)
)
AS
BEGIN
    -- Check if the Athlete_ID exists in AthleteDetails table
    IF NOT EXISTS (SELECT 1 FROM AthleteDetails WHERE Athlete_ID = @Athlete_ID)
    BEGIN
        PRINT 'Athlete does not exist. Please provide a valid Athlete_ID.'
        RETURN
    END

    -- Insert data into ExerciseDetails if Athlete_ID is valid
    INSERT INTO ExerciseDetails (Athlete_ID, Exercise_Date, Exercise_Type, DurationMinutes, CaloriesBurned)
    VALUES (@Athlete_ID, @Exercise_Date, @Exercise_Type, @DurationMinutes, @CaloriesBurned)
    PRINT 'Exercise details successfully added.'
END
GO

--6-- Insertion procedure for DietDetails table
CREATE PROCEDURE InsertDietDetails (
    @Athlete_ID INT,
    @Diet_Date DATE,
    @Meal_Type VARCHAR(50),
    @CaloriesConsumed DECIMAL(8,2)
)
AS
BEGIN
    -- Check if the Athlete_ID exists in AthleteDetails table
    IF NOT EXISTS (SELECT 1 FROM AthleteDetails WHERE Athlete_ID = @Athlete_ID)
    BEGIN
        PRINT 'Athlete does not exist. Please provide a valid Athlete_ID.'
        RETURN
    END

    -- Check if the provided CaloriesConsumed value is reasonable (within a sensible range)
    IF @CaloriesConsumed < 0 OR @CaloriesConsumed > 10000 -- Adjust range as needed
    BEGIN
        PRINT 'Please provide a valid value for CaloriesConsumed between 0 and 10000.'
        RETURN
    END

    -- Insert data into DietDetails if Athlete_ID is valid and CaloriesConsumed is reasonable
    INSERT INTO DietDetails (Athlete_ID, Diet_Date, Meal_Type, CaloriesConsumed)
    VALUES (@Athlete_ID, @Diet_Date, @Meal_Type, @CaloriesConsumed)
    PRINT 'Diet details successfully added.'
END
GO

--7-- Insertion procedure for WorkoutScheduleDetails table
CREATE PROCEDURE InsertWorkoutScheduleDetails (
    @Athlete_ID INT,
    @Workout_Date DATE,
    @Workout_Type VARCHAR(50),
    @Workout_DurationMinutes INT
)
AS
BEGIN
    -- Check if the Athlete_ID exists in AthleteDetails table
    IF NOT EXISTS (SELECT 1 FROM AthleteDetails WHERE Athlete_ID = @Athlete_ID)
    BEGIN
        PRINT 'Athlete does not exist. Please provide a valid Athlete_ID.'
        RETURN
    END

    -- Check if Workout_DurationMinutes is within a reasonable range
    IF @Workout_DurationMinutes <= 0 OR @Workout_DurationMinutes > 240 -- Adjust range as needed
    BEGIN
        PRINT 'Please provide a valid value for Workout_DurationMinutes between 1 and 240.'
        RETURN
    END

    -- Insert data into WorkoutScheduleDetails if Athlete_ID is valid and Workout_DurationMinutes is reasonable
    INSERT INTO WorkoutScheduleDetails (Athlete_ID, Workout_Date, Workout_Type, Workout_DurationMinutes)
    VALUES (@Athlete_ID, @Workout_Date, @Workout_Type, @Workout_DurationMinutes)
    PRINT 'Workout schedule details successfully added.'
END
GO
--8-- Expenses details procedure insertion
CREATE PROCEDURE InsertExpensesDetails (
    @Athlete_ID INT,
    @Expense_Date DATE,
    @Expense_Type VARCHAR(50),
    @Amount DECIMAL(10,2),
    @Description TEXT
)
AS
BEGIN
    -- Check if the Athlete_ID exists in AthleteDetails table
    IF NOT EXISTS (SELECT 1 FROM AthleteDetails WHERE Athlete_ID = @Athlete_ID)
    BEGIN
        PRINT 'Athlete does not exist. Please provide a valid Athlete_ID.'
        RETURN
    END

    -- Check if the Amount is a positive value
    IF @Amount <= 0
    BEGIN
        PRINT 'Please provide a valid positive value for Amount.'
        RETURN
    END

    -- Insert data into ExpensesDetails if Athlete_ID is valid and Amount is positive
    INSERT INTO ExpensesDetails (Athlete_ID, Expense_Date, Expense_Type, Amount, Description)
    VALUES (@Athlete_ID, @Expense_Date, @Expense_Type, @Amount, @Description)
    PRINT 'Expense details successfully added.'
END
GO



-------------------------------------------------------------------------------


-- Execution statements for insertion procedures

----------------------------------------------------
-- Insertion for AthleteDetails
EXEC InsertAthleteDetails 'MUTAHAR', 'HASHMI', '1990-05-15', 'Male', '1234567890', 'hockey'
Select * from AthleteDetails

----------------------------------------------------
-- Insertion for FitnessHistoryDetails
EXEC InsertFitnessHistoryDetails 1, 80.5, 175.0, 24.8, 65.3, 78.2, 60.0, '2023-01-10'
Select * from FitnessHistoryDetails
----------------------------------------------------
-- Insertion for RehabilitationDetails
EXEC InsertRehabilitationDetails 1, '2023-02-15', '2023-03-30', 'Physical Therapy', 'Rehabilitation after knee surgery'
Select * from RehabilitationDetails
----------------------------------------------------
-- Insertion for InjuryDetails
EXEC InsertInjuryDetails 1, '2022-12-05', 'Sprain', 'Low', 'Recovered'
Select * from InjuryDetails
----------------------------------------------------
-- Insertion for ExerciseDetails
EXEC InsertExerciseDetails 1, '2023-01-20', 'Running', 45, 250.5
Select * from ExerciseDetails
----------------------------------------------------
-- Insertion for DietDetails
EXEC InsertDietDetails 1, '2023-01-25', 'Breakfast', 350.0
Select * from DietDetails
----------------------------------------------------
-- Insertion for WorkoutScheduleDetails
EXEC InsertWorkoutScheduleDetails 1, '2023-01-30', 'Cardio', 60
Select * from WorkoutScheduleDetails
----------------------------------------------------
-- Insertion for ExpensesDetails
EXEC InsertExpensesDetails 1, '2023-02-05', 'Nutrition', 35.75, 'Purchased protein supplements'
Select * from ExpensesDetails
----------------------------------------------------