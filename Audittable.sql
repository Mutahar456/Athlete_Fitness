Use Athlete_FITNESS
CREATE TABLE AuditDeletedFitnessHistory (
    DeletedRecord_ID INT PRIMARY KEY IDENTITY(1,1),
    TableName VARCHAR(100),
    RecordID INT,
    DeletedAt DATETIME DEFAULT GETDATE(),
    DeletedBy VARCHAR(100) -- You might want to capture who performed the deletion
);
CREATE TRIGGER trg_AuditDeleteFitnessHistory
ON FitnessHistoryDetails
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditDeletedFitnessHistory (TableName, RecordID)
    SELECT 'FitnessHistoryDetails', deleted.FitnessHistory_ID
    FROM deleted;
END;

DELETE FROM FitnessHistoryDetails WHERE FitnessHistory_ID = 9;
Select * from FitnessHistoryDetails

------------------------------------------------

CREATE TABLE AuditDeleted_Invoice (
    DeletedRecord_ID INT PRIMARY KEY IDENTITY(1,1),
    TableName VARCHAR(100),
    RecordID INT,
    DeletedAt DATETIME DEFAULT GETDATE(),
    DeletedBy VARCHAR(100) -- You might want to capture who performed the deletion
);
CREATE TRIGGER trg_AuditDelete_Invoice
ON InvoiceDetails -- Replace 'InvoiceDetails' with the actual table name
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditDeleted_Invoice (TableName, RecordID)
    SELECT 'InvoiceDetails', deleted.Invoice_ID -- Replace 'Invoice_ID' with the actual primary key column name
    FROM deleted;
END;


DELETE FROM InvoiceDetails WHERE Invoice_ID = YourInvoiceID;
SELECT * FROM AuditDeleted_Invoice;
