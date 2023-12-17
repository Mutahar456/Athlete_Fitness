Use Athlete_FITNESS
-----------------------------------------------------------------------------------
CREATE PROCEDURE GetAthleteDetailsById
    @AthleteID INT
AS
BEGIN
    -- Retrieve athlete details
    SELECT 
        AD.Athlete_ID,
        AD.First_Name,
        AD.Last_Name,
        AD.Date_of_Birth,
        AD.Gender,
        AD.Contact_Info,
        AD.Sport
    FROM AthleteDetails AD
    WHERE AD.Athlete_ID = @AthleteID;

    -- Retrieve fitness history details for the athlete
    SELECT 
        FH.FitnessHistory_ID,
        FH.Weight,
        FH.Height,
        FH.BMI,
        FH.Muscular_Strength,
        FH.Endurance,
        FH.Flexibility,
        FH.Date_Recorded
    FROM FitnessHistoryDetails FH
    WHERE FH.Athlete_ID = @AthleteID;

    -- Retrieve rehabilitation details for the athlete
    SELECT 
        RD.Rehab_ID,
        RD.Start_Date,
        RD.End_Date,
        RD.Rehab_Type,
        RD.Notes
    FROM RehabilitationDetails RD
    WHERE RD.Athlete_ID = @AthleteID;

    -- Retrieve injury details for the athlete
    SELECT 
        ID.Injury_ID,
        ID.Injury_Date,
        ID.Injury_Type,
        ID.Severity,
        ID.Recovery_Status
    FROM InjuryDetails ID
    WHERE ID.Athlete_ID = @AthleteID;

    -- Retrieve exercise details for the athlete
    SELECT 
        ED.Exercise_ID,
        ED.Exercise_Date,
        ED.Exercise_Type,
        ED.DurationMinutes,
        ED.CaloriesBurned
    FROM ExerciseDetails ED
    WHERE ED.Athlete_ID = @AthleteID;

    -- Retrieve diet details for the athlete
    SELECT 
        DD.Diet_ID,
        DD.Diet_Date,
        DD.Meal_Type,
        DD.CaloriesConsumed
    FROM DietDetails DD
    WHERE DD.Athlete_ID = @AthleteID;

    -- Retrieve workout schedule details for the athlete
    SELECT 
        WD.Schedule_ID,
        WD.Workout_Date,
        WD.Workout_Type,
        WD.Workout_DurationMinutes
    FROM WorkoutScheduleDetails WD
    WHERE WD.Athlete_ID = @AthleteID;

    -- Retrieve expenses details for the athlete
    SELECT 
        ED.Expense_ID,
        ED.Expense_Date,
        ED.Expense_Type,
        ED.Amount,
        ED.Description
    FROM ExpensesDetails ED
    WHERE ED.Athlete_ID = @AthleteID;
END;

EXEC GetAthleteDetailsById @AthleteID=50;





---------------------------------------------------------------------------
CREATE PROCEDURE GenerateBillInvoice
    @AthleteID INT
AS
BEGIN
    DECLARE @TotalExpenses DECIMAL(10, 2)

    -- Calculate the total expenses for the athlete
    SELECT @TotalExpenses = SUM(Amount)
    FROM ExpensesDetails
    WHERE Athlete_ID = @AthleteID;

    -- Insert the bill invoice into a new table or use existing table InvoiceDetails
    INSERT INTO InvoiceDetails (Athlete_ID, Total_Expenses, Invoice_Date)
    VALUES (@AthleteID, @TotalExpenses, GETDATE());

    -- Return the invoice details
    SELECT 
        Invoice_ID,
        Athlete_ID,
        Total_Expenses,
        Invoice_Date
    FROM InvoiceDetails
    WHERE Athlete_ID = @AthleteID
    ORDER BY Invoice_ID DESC; -- You can remove this line if you don't need ordering
END;

EXEC GenerateBillInvoice @AthleteID = 50;
Select * from InvoiceDetails



----------------------------------------
CREATE PROCEDURE GenerateRecoveryRankReport
AS
BEGIN
    -- Declare a temporary table variable to hold the ranked athletes
    DECLARE @RankTable TABLE (
        Athlete_ID INT,
        Recovery_Rank INT,
        Recovery_Status VARCHAR(50)
    )

    -- Insert ranked athletes into the temporary table variable
    INSERT INTO @RankTable (Athlete_ID, Recovery_Rank, Recovery_Status)
    SELECT 
        Athlete_ID,
        ROW_NUMBER() OVER (ORDER BY Recovery_Status DESC) AS Recovery_Rank,
        Recovery_Status
    FROM InjuryDetails
    WHERE Recovery_Status IS NOT NULL

    -- Return the ranked athletes
    SELECT * FROM @RankTable
    ORDER BY Recovery_Rank;
END;
Use Athlete_FITNESS
EXEC GenerateRecoveryRankReport








----------------------------------------------------------------------------------------
CREATE PROCEDURE GenerateStatisticalReport
 @AthleteID INT
AS
BEGIN
    -- Create a temporary table to store the report data
    CREATE TABLE #StatisticalReport (
        Category VARCHAR(50),
        TotalRecords INT,
        EarliestDate DATE,
        LatestDate DATE,
        AvgValue DECIMAL(18, 2)
    );

    -- Insert data into the temporary table based on different categories
    INSERT INTO #StatisticalReport (Category, TotalRecords, EarliestDate, LatestDate, AvgValue)
    SELECT 
        'AthleteDetails' AS Category,
        COUNT(*) AS TotalRecords,
        MIN(Date_of_Birth) AS EarliestDate,
        MAX(Date_of_Birth) AS LatestDate,
        NULL AS AvgValue
    FROM AthleteDetails;

    INSERT INTO #StatisticalReport (Category, TotalRecords, EarliestDate, LatestDate, AvgValue)
    SELECT 
        'FitnessHistoryDetails' AS Category,
        COUNT(*) AS TotalRecords,
        NULL AS EarliestDate,
        NULL AS LatestDate,
        AVG(Weight) AS AvgValue
    FROM FitnessHistoryDetails;

INSERT INTO #StatisticalReport (Category, TotalRecords, EarliestDate, LatestDate, AvgValue)
SELECT 
    'DietDetails' AS Category,
    COUNT(*) AS TotalRecords,
    MIN(Diet_Date) AS EarliestDate,
    MAX(Diet_Date) AS LatestDate,
    AVG(CaloriesConsumed) AS AvgValue
FROM DietDetails
WHERE Athlete_ID = @AthleteID;

-- Example for WorkoutScheduleDetails
INSERT INTO #StatisticalReport (Category, TotalRecords, EarliestDate, LatestDate, AvgValue)
SELECT 
    'WorkoutScheduleDetails' AS Category,
    COUNT(*) AS TotalRecords,
    MIN(Workout_Date) AS EarliestDate,
    MAX(Workout_Date) AS LatestDate,
    AVG(Workout_DurationMinutes) AS AvgValue
FROM WorkoutScheduleDetails
WHERE Athlete_ID = @AthleteID;
    -- Return the aggregated report stored in the temporary table
    SELECT * FROM #StatisticalReport;

    -- Drop the temporary table after use
    DROP TABLE #StatisticalReport;
END;
Use Athlete_FITNESS
EXEC GenerateStatisticalReport @AthleteID= 51;
---------------------------------------------------------------------
Drop Procedure GenerateStatisticalReport
-----------------------------------------------

CREATE PROCEDURE GenerateWorkoutScheduleReportForAthlete
    @AthleteID INT
AS
BEGIN
    SELECT Workout_Date, Workout_Type, Workout_DurationMinutes
    FROM WorkoutScheduleDetails
    WHERE Athlete_ID = @AthleteID;
END;

EXEC GenerateWorkoutScheduleReportForAthlete @AthleteID = 51;

------------------------------------------------------------------------------
CREATE PROCEDURE GenerateExerciseDetailsReportForAthlete
    @AthleteID INT
AS
BEGIN
    SELECT Exercise_Date, Exercise_Type, DurationMinutes, CaloriesBurned
    FROM ExerciseDetails
    WHERE Athlete_ID = @AthleteID;
END;

EXEC GenerateExerciseDetailsReportForAthlete @AthleteID = 53;
------------------------------------------------------------------------------
CREATE PROCEDURE GenerateExpensesDetailsReportForAthlete
    @AthleteID INT
AS
BEGIN
    SELECT Expense_Date, Expense_Type, Amount, Description
    FROM ExpensesDetails
    WHERE Athlete_ID = @AthleteID;
END;

EXEC GenerateExpensesDetailsReportForAthlete @AthleteID = 56;
-------------------------------------------------------------------------------
CREATE PROCEDURE GenerateBMIReportForAthlete
    @AthleteID INT
AS
BEGIN
    SELECT Date_Recorded, BMI
    FROM FitnessHistoryDetails
    WHERE Athlete_ID = @AthleteID;
END;

EXEC GenerateBMIReportForAthlete @AthleteID=54;
------------------------------------------------------------------------------
CREATE PROCEDURE GetTotalExpensesForAthlete
    @AthleteID INT
AS
BEGIN
    SELECT SUM(Amount) AS TotalExpenses
    FROM ExpensesDetails
    WHERE Athlete_ID = @AthleteID;
END;
EXEC GetTotalExpensesForAthlete @AthleteID = 59;
------------------------------------------------------------------------------
CREATE PROCEDURE AddWorkoutScheduleForAthlete
    @AthleteID INT,
    @WorkoutDate DATE,
    @WorkoutType VARCHAR(50),
    @WorkoutDuration INT
AS
BEGIN
    -- Check if Athlete_ID exists in AthleteDetails table
    IF NOT EXISTS (SELECT 1 FROM AthleteDetails WHERE Athlete_ID = @AthleteID)
    BEGIN
        PRINT 'Error: Athlete ID does not exist.';
        RETURN; -- Exit the procedure
    END

    -- Check Workout Duration validity (positive integer)
    IF @WorkoutDuration <= 0
    BEGIN
        PRINT 'Error: Workout duration should be a positive integer.';
        RETURN; -- Exit the procedure
    END

    -- Insert into WorkoutScheduleDetails table
    INSERT INTO WorkoutScheduleDetails (Athlete_ID, Workout_Date, Workout_Type, Workout_DurationMinutes)
    VALUES (@AthleteID, @WorkoutDate, @WorkoutType, @WorkoutDuration);

    PRINT 'Workout schedule added successfully.';
END;
Drop PROCEDURE AddWorkoutScheduleForAthlete
EXEC AddWorkoutScheduleForAthlete 
    @AthleteID =56,
    @WorkoutDate = '2023-12-13',
    @WorkoutType ='Weighlifting',
    @WorkoutDuration=42

Select * from WorkoutScheduleDetails

----------------------------------------------------------------
CREATE PROCEDURE DeleteWorkoutScheduleForAthlete
    @ScheduleID INT
AS
BEGIN
    DELETE FROM WorkoutScheduleDetails
    WHERE Schedule_ID = @ScheduleID;
END;
EXEC DeleteWorkoutScheduleForAthlete @ScheduleID =2;

Select * From WorkoutScheduleDetails
------------------------------------------------------------------
CREATE PROCEDURE UpdateInjuryStatusForAthlete
    @AthleteID INT,
    @InjuryDate DATE,
    @InjuryType VARCHAR(50),
    @Severity VARCHAR(50),
    @RecoveryStatus VARCHAR(50)
AS
BEGIN
    UPDATE InjuryDetails
    SET Injury_Date = @InjuryDate, Injury_Type = @InjuryType, Severity = @Severity, Recovery_Status = @RecoveryStatus
    WHERE Athlete_ID = @AthleteID;
END;

EXEC UpdateInjuryStatusForAthlete 
    @AthleteID = 51,
    @InjuryDate = '2023-12-31', -- Replace with the new injury date
    @InjuryType = 'Sprain', -- Replace with the new injury type
    @Severity = 'Normal', -- Replace with the new severity
    @RecoveryStatus = 'On-going'; -- Replace with the new recovery status

Select * from InjuryDetails
-----------------------------------------------------------------------------------
CREATE PROCEDURE GetTotalWorkoutDurationForAthlete
    @AthleteID INT
AS
BEGIN
    SELECT Athlete_ID, SUM(Workout_DurationMinutes) AS Total_Workout_Duration
    FROM WorkoutScheduleDetails
    WHERE Athlete_ID = @AthleteID
    GROUP BY Athlete_ID;
END;
EXEC GetTotalWorkoutDurationForAthlete @AthleteID = 59;
-----------------------------------------------------------------------------------
CREATE PROCEDURE GetTotalCaloriesBurnedByAthlete
    @AthleteID INT
AS
BEGIN
    SELECT Athlete_ID, SUM(CaloriesBurned) AS Total_Calories_Burned
    FROM ExerciseDetails
    WHERE Athlete_ID = @AthleteID
    GROUP BY Athlete_ID;
END;
EXEC GetTotalCaloriesBurnedByAthlete @AthleteID = 89;
------------------------------------------------------------------------------------


CREATE PROCEDURE GetAthleteDetailsByIdd
    @AthleteID INT
AS
BEGIN
    SELECT 
        AD.Athlete_ID,
        AD.First_Name,
        AD.Last_Name,
        AD.Date_of_Birth,
        AD.Gender,
        AD.Contact_Info,
        AD.Sport,
        FH.Weight,
        FH.Height,
        FH.BMI,
        FH.Muscular_Strength,
        FH.Endurance,
        FH.Flexibility,
        RD.Start_Date AS Rehab_Start_Date,
        RD.End_Date AS Rehab_End_Date,
        RD.Rehab_Type,
        RD.Notes AS Rehab_Notes,
        ID.Injury_Date,
        ID.Injury_Type,
        ID.Severity,
        ID.Recovery_Status,
        ED.Exercise_Date,
        ED.Exercise_Type,
        ED.DurationMinutes AS Exercise_Duration,
        ED.CaloriesBurned,
        DD.Diet_Date,
        DD.Meal_Type,
        DD.CaloriesConsumed AS Diet_CaloriesConsumed,
        WD.Workout_Date,
        WD.Workout_Type,
        WD.Workout_DurationMinutes AS Workout_Duration,
        EXD.Amount AS Expense_Amount,
        EXD.Description AS Expense_Description
    FROM AthleteDetails AD
    LEFT JOIN FitnessHistoryDetails FH ON AD.Athlete_ID = FH.Athlete_ID
    LEFT JOIN RehabilitationDetails RD ON AD.Athlete_ID = RD.Athlete_ID
    LEFT JOIN InjuryDetails ID ON AD.Athlete_ID = ID.Athlete_ID
    LEFT JOIN ExerciseDetails ED ON AD.Athlete_ID = ED.Athlete_ID
    LEFT JOIN DietDetails DD ON AD.Athlete_ID = DD.Athlete_ID
    LEFT JOIN WorkoutScheduleDetails WD ON AD.Athlete_ID = WD.Athlete_ID
    LEFT JOIN ExpensesDetails EXD ON AD.Athlete_ID = EXD.Athlete_ID
    WHERE AD.Athlete_ID = @AthleteID;
END;
EXEC GetAthleteDetailsByIdd @AthleteID =52;
------------------------------------------------------------------
CREATE PROCEDURE GetAthleteDetailsByRange
    @StartID INT,
    @EndID INT
AS
BEGIN
    SELECT 
        AD.Athlete_ID,
        AD.First_Name,
        AD.Last_Name,
        AD.Date_of_Birth,
        AD.Gender,
        AD.Contact_Info,
        AD.Sport,
        FH.Weight,
        FH.Height,
        FH.BMI,
        FH.Muscular_Strength,
        FH.Endurance,
        FH.Flexibility,
        RD.Start_Date AS Rehab_Start_Date,
        RD.End_Date AS Rehab_End_Date,
        RD.Rehab_Type,
        RD.Notes AS Rehab_Notes,
        ID.Injury_Date,
        ID.Injury_Type,
        ID.Severity,
        ID.Recovery_Status,
        ED.Exercise_Date,
        ED.Exercise_Type,
        ED.DurationMinutes AS Exercise_Duration,
        ED.CaloriesBurned,
        DD.Diet_Date,
        DD.Meal_Type,
        DD.CaloriesConsumed AS Diet_CaloriesConsumed,
        WD.Workout_Date,
        WD.Workout_Type,
        WD.Workout_DurationMinutes AS Workout_Duration,
        EXD.Amount AS Expense_Amount,
        EXD.Description AS Expense_Description
    FROM AthleteDetails AD
    LEFT JOIN FitnessHistoryDetails FH ON AD.Athlete_ID = FH.Athlete_ID
    LEFT JOIN RehabilitationDetails RD ON AD.Athlete_ID = RD.Athlete_ID
    LEFT JOIN InjuryDetails ID ON AD.Athlete_ID = ID.Athlete_ID
    LEFT JOIN ExerciseDetails ED ON AD.Athlete_ID = ED.Athlete_ID
    LEFT JOIN DietDetails DD ON AD.Athlete_ID = DD.Athlete_ID
    LEFT JOIN WorkoutScheduleDetails WD ON AD.Athlete_ID = WD.Athlete_ID
    LEFT JOIN ExpensesDetails EXD ON AD.Athlete_ID = EXD.Athlete_ID
    WHERE AD.Athlete_ID BETWEEN @StartID AND @EndID;
END;



EXEC GetAthleteDetailsByRange @StartID = 50,@EndID =70;



;WITH DuplicateAthletes AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY First_Name, Last_Name, Date_of_Birth ORDER BY Athlete_ID) AS RN
    FROM AthleteDetails
)
DELETE FROM DuplicateAthletes WHERE RN > 1;


CREATE TABLE DeletedAthleteLog (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    Athlete_ID INT,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Deleted_Date DATETIME DEFAULT GETDATE()
);

Select * from DeletedAthleteLog
Drop Table DeletedAthleteLog




