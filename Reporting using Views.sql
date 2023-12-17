Use Athlete_FITNESS

-- Create a view to get athlete details
CREATE VIEW vw_AthleteDetails AS
SELECT 
    Athlete_ID,
    First_Name,
    Last_Name,
    Date_of_Birth,
    Gender,
    Contact_Info,
    Sport
FROM AthleteDetails;

-- Create a view to get exercise details
CREATE VIEW vw_ExerciseDetails AS
SELECT 
    Athlete_ID,
    Exercise_Date,
    Exercise_Type,
    DurationMinutes,
    CaloriesBurned
FROM ExerciseDetails;

-- Create a view to get expenses details
CREATE VIEW vw_ExpensesDetails AS
SELECT 
    Athlete_ID,
    Expense_Date,
    Expense_Type,
    Amount,
    Description
FROM ExpensesDetails;








SELECT 
    AD.First_Name,
    AD.Last_Name,
    AD.Sport,
    ED.Exercise_Date,
    ED.Exercise_Type,
    ED.DurationMinutes AS Exercise_Duration,
    ED.CaloriesBurned AS Exercise_Calories,
    ExpD.Expense_Date,
    ExpD.Expense_Type,
    ExpD.Amount AS Expense_Amount,
    ExpD.Description AS Expense_Description
FROM vw_AthleteDetails AD
LEFT JOIN vw_ExerciseDetails ED ON AD.Athlete_ID = ED.Athlete_ID
LEFT JOIN vw_ExpensesDetails ExpD ON AD.Athlete_ID = ExpD.Athlete_ID;




-- Create a view to get rehabilitation details
CREATE VIEW vw_RehabilitationDetails AS
SELECT 
    Athlete_ID,
    Start_Date,
    End_Date,
    Rehab_Type,
    Notes
FROM RehabilitationDetails;

-- Generate a report combining athlete details with rehabilitation data
SELECT 
    AD.First_Name,
    AD.Last_Name,
    RD.Rehab_Type,
    RD.Start_Date AS Rehab_Start,
    RD.End_Date AS Rehab_End,
    RD.Notes AS Rehab_Notes
FROM vw_AthleteDetails AD
LEFT JOIN vw_RehabilitationDetails RD ON AD.Athlete_ID = RD.Athlete_ID;



-- Generate a report summarizing workout schedule details per athlete
SELECT 
    AD.First_Name,
    AD.Last_Name,
    COUNT(WD.Schedule_ID) AS Total_Workout_Schedules,
    SUM(WD.Workout_DurationMinutes) AS Total_Workout_Minutes
FROM vw_AthleteDetails AD
LEFT JOIN WorkoutScheduleDetails WD ON AD.Athlete_ID = WD.Athlete_ID
GROUP BY AD.First_Name, AD.Last_Name;



-- Generate a report on injury details of athletes
SELECT 
    AD.First_Name,
    AD.Last_Name,
    ID.Injury_Date,
    ID.Injury_Type,
    ID.Severity,
    ID.Recovery_Status
FROM vw_AthleteDetails AD
LEFT JOIN InjuryDetails ID ON AD.Athlete_ID = ID.Athlete_ID;




SELECT 
    AD.Athlete_ID,
    AD.First_Name,
    AD.Last_Name,
    FH.Weight,
    FH.Height,
    FH.BMI,
    FH.Muscular_Strength,
    FH.Endurance,
    FH.Flexibility,
    FH.Date_Recorded
FROM AthleteDetails AD
INNER JOIN FitnessHistoryDetails FH ON AD.Athlete_ID = FH.Athlete_ID
WHERE AD.Athlete_ID >= 549;


SELECT 
    AD.Athlete_ID,
    AD.First_Name,
    AD.Last_Name,
    COUNT(WD.Schedule_ID) AS Total_Workout_Schedules,
    SUM(WD.Workout_DurationMinutes) AS Total_Workout_Minutes
FROM AthleteDetails AD
LEFT JOIN WorkoutScheduleDetails WD ON AD.Athlete_ID = WD.Athlete_ID
WHERE AD.Athlete_ID >= 549
GROUP BY AD.Athlete_ID, AD.First_Name, AD.Last_Name;



SELECT 
    AD.Athlete_ID,
    AD.First_Name,
    AD.Last_Name,
    ED.Expense_Date,
    ED.Expense_Type,
    ED.Amount,
    ED.Description
FROM AthleteDetails AD
INNER JOIN ExpensesDetails ED ON AD.Athlete_ID = ED.Athlete_ID
WHERE AD.Athlete_ID >= 549;
