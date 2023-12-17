Use Athlete_FITNESS


--Trigger 1: Enforce BMI Calculation
--This trigger automatically calculates the BMI (Body Mass Index) whenever a new record is inserted or updated in the FitnessHistoryDetails table.
CREATE TRIGGER CalculateBMI
ON FitnessHistoryDetails
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE f
    SET BMI = (f.Weight / (f.Height * f.Height)) * 703 -- Formula to calculate BMI
    FROM FitnessHistoryDetails f
    INNER JOIN inserted i ON f.FitnessHistory_ID = i.FitnessHistory_ID;
END;

Select * from FitnessHistoryDetails
---------------------------------------------------------------------------
--Trigger 2: Log Expense Details
--This trigger logs whenever an expense is added to the ExpensesDetails table.
CREATE TRIGGER LogExpense
ON ExpensesDetails
AFTER INSERT
AS
BEGIN
    DECLARE @AthleteID INT
    DECLARE @ExpenseType VARCHAR(50)
    DECLARE @Amount DECIMAL(10,2)

    SELECT @AthleteID = Athlete_ID, @ExpenseType = Expense_Type, @Amount = Amount
    FROM inserted;

    INSERT INTO ExpensesDetails(Athlete_ID, Expense_Type, Amount, Description)
    VALUES (@AthleteID, @ExpenseType, @Amount, Description);
END;

-------CAN CHECK ABOVE TRIGGER USING THIS ------------------------------
INSERT INTO ExpensesDetails (Athlete_ID, Expense_Date, Expense_Type, Amount, Description)
VALUES (1, '2023-12-20', 'Food', 50.00, 'Dinner at a restaurant');

SELECT * FROM ExpenseLog;








-------------------------------------------------------------------------------------------------
--Trigger 3: Maintain Workout Schedule
--This trigger ensures that an athlete doesn't have overlapping workout schedules.

CREATE TRIGGER CheckWorkoutSchedule
ON WorkoutScheduleDetails
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM WorkoutScheduleDetails w1
        JOIN inserted i ON w1.Athlete_ID = i.Athlete_ID
        WHERE w1.Workout_Date = i.Workout_Date
          AND w1.Schedule_ID <> i.Schedule_ID -- Exclude the same schedule being updated
    )
    BEGIN
        DECLARE @ErrorMessage NVARCHAR(200) = 'Overlapping workout schedules are not allowed.'
        RAISERROR(@ErrorMessage, 16, 1);
        ROLLBACK TRANSACTION; -- If inside a transaction
        RETURN;
    END;
END;


------------------CAN CHECK THE ABOVE TRIGGER WORKING PROPERLY--------------------------------------------------------
INSERT INTO WorkoutScheduleDetails (Athlete_ID, Workout_Date, Workout_Type, Workout_DurationMinutes)
VALUES (1, '2023-12-15', 'Running', 60);

-- This insert will attempt to schedule another workout on the same date for the same athlete (Athlete_ID = 1)
INSERT INTO WorkoutScheduleDetails (Athlete_ID, Workout_Date, Workout_Type, Workout_DurationMinutes)
VALUES (1, '2023-12-15', 'Weightlifting', 45);
----------------------------------------------------------------------------------------------------------------------


--Trigger 4: Update RehabilitationDetails End Date on New Injury Insertion
--This trigger updates the End_Date in RehabilitationDetails table when a new injury is inserted.
CREATE TRIGGER UpdateRehabEndDate
ON InjuryDetails
AFTER INSERT
AS
BEGIN
    DECLARE @AthleteID INT
    DECLARE @InjuryDate DATE

    SELECT @AthleteID = Athlete_ID, @InjuryDate = Injury_Date
    FROM inserted;

    UPDATE RehabilitationDetails
    SET End_Date = DATEADD(month, 1, @InjuryDate) -- Assuming rehabilitation takes a month after an injury
    WHERE Athlete_ID = @AthleteID;
END;



-- Check if End_Date in RehabilitationDetails is updated after adding a new injury in InjuryDetails
SELECT *
FROM RehabilitationDetails
WHERE Athlete_ID = 51; -- Check for the respective Athlete_ID


---------------------------------------------------------------------------------------------------------------------------
--Trigger 5 ----------------------------------------------------
CREATE TRIGGER UpdateTotalExpenses
ON ExpensesDetails
AFTER INSERT
AS
BEGIN
    DECLARE @AthleteID INT
    DECLARE @TotalExpenses DECIMAL(10, 2)

    SELECT @AthleteID = Athlete_ID, @TotalExpenses = SUM(Amount)
    FROM inserted
    GROUP BY Athlete_ID

    UPDATE InvoiceDetails
    SET Total_Expenses = ISNULL(Total_Expenses, 0) + @TotalExpenses
    WHERE Athlete_ID = @AthleteID
END;
INSERT INTO ExpensesDetails (Athlete_ID, Expense_Type, Amount)
VALUES (51, 'Nutrition', 10.00);


SELECT *
FROM InvoiceDetails
WHERE Athlete_ID = 51;
------------------



\
---------------------------------------------------------------]


CREATE TRIGGER trg_DeleteAthlete1
ON AthleteDetails
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Log deleted athlete information into DeletedAthleteLog table
    INSERT INTO DeletedAthleteLog (Athlete_ID, First_Name, Last_Name)
    SELECT deleted.Athlete_ID, deleted.First_Name, deleted.Last_Name
    FROM deleted;
END;
d