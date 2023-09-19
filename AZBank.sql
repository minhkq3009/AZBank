CREATE DATABASE AZBank;
USE AZBank;

-- Create the Customer table
CREATE TABLE Customer (
    CustomerId INT PRIMARY KEY,
    Name NVARCHAR(50),
    City NVARCHAR(50),
    Country NVARCHAR(50),
    Phone NVARCHAR(15),
    Email NVARCHAR(50) 
);

-- Create the CustomerAccount table
CREATE TABLE CustomerAccount (
    AccountNumber CHAR(9) PRIMARY KEY,
    CustomerId INT NOT NULL,
    Balance MONEY NOT NULL,
    MinAccount MONEY,
    CONSTRAINT FK_CustomerAccount_CustomerId FOREIGN KEY (CustomerId) REFERENCES Customer(CustomerId)
);

-- Create the CustomerTransaction table
CREATE TABLE CustomerTransaction (
    TransactionId INT PRIMARY KEY,
    AccountNumber CHAR(9) NOT NULL,
    TransactionDate SMALLDATETIME,
    Amount MONEY NOT NULL,
    DepositorWithdraw BIT,
    CONSTRAINT FK_CustomerTransaction_AccountNumber FOREIGN KEY (AccountNumber) REFERENCES CustomerAccount(AccountNumber),
    CONSTRAINT CHK_AmountRange CHECK (Amount > 0 AND Amount <= 1000000)
);

-- Insert into the Customer table
INSERT INTO Customer (CustomerId, Name, City, Country, Phone, Email)
VALUES
    (1, 'John Doe', 'Hanoi', 'Vietnam', '123-456-7890', 'johndoe@example.com'),
    (2, 'Jane Smith', 'New York', 'USA', '555-123-4567', 'janesmith@example.com'),
    (3, 'Alice Johnson', 'Hanoi', 'Vietnam', '987-654-3210', 'alice@example.com');

-- Insert into the CustomerAccount table
INSERT INTO CustomerAccount (AccountNumber, CustomerId, Balance, MinAccount)
VALUES
    ('ACC123456', 1, 5000.00, 1000.00),
    ('ACC789012', 2, 10000.00, 2000.00),
    ('ACC345678', 3, 8000.00, 1500.00);

-- Insert into the CustomerTransaction table
INSERT INTO CustomerTransaction (TransactionId, AccountNumber, TransactionDate, Amount, DepositorWithdraw)
VALUES
    (1, 'ACC123456', '2023-09-19 09:00:00', 500.00, 1),
    (2, 'ACC789012', '2023-09-19 10:30:00', 1500.00, 0),
    (3, 'ACC345678', '2023-09-19 11:45:00', 800.00, 1);

--A query to get all customers from the Customer table who live in 'Hanoi'
SELECT * FROM Customer WHERE City = 'Hanoi';

--A query to get account information of the customers (Name, Phone, Email, AccountNumber, Balance)
SELECT C.Name, C.Phone, C.Email, CA.AccountNumber, CA.Balance
FROM Customer C
INNER JOIN CustomerAccount CA ON C.CustomerId = CA.CustomerId;

-- Create a CHECK constraint on Amount column of CustomerTransaction table to check that each transaction amount is greater thanO and less than or equal $1000000.
ALTER TABLE CustomerTransaction
ADD CONSTRAINT CK_Amount CHECK (Amount > 0 AND Amount <= 1000000);

-- Create a view named vCustomerTransactions that displays Name, AccountNumber, TransactionDate, Amount, and DepositorWithdraw from Customer, CustomerAccount, and CustomerTransaction tables
CREATE VIEW vCustomerTransactions AS
SELECT C.Name, CT.AccountNumber, CT.TransactionDate, CT.Amount, CT.DepositorWithdraw
FROM Customer C
INNER JOIN CustomerAccount CA ON C.CustomerId = CA.CustomerId
INNER JOIN CustomerTransaction CT ON CA.AccountNumber = CT.AccountNumber;

SELECT * FROM vCustomerTransactions
