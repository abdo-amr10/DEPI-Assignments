use [Task1 DEPI]
-----------------Task1 Part1-----------------------
Create table Employee(
SSN int Primary Key,
FName Varchar(50) not null,
LName Varchar(50),
Gender Varchar(10),
Birth_Date date,
Supervise int,
CONSTRAINT Employee_Supervisor FOREIGN KEY (Supervise) REFERENCES Employee(SSN) 
)
Alter table Employee
Add DNum int,
FOREIGN KEY (DNum) REFERENCES Department(DNum) 
go


------------------Task1 Part2---------------------
create table Department(
DNum int primary key,
DName varchar(50),
Dept_Location varchar(50),
SSN int ,
FOREIGN KEY (SSN) REFERENCES Employee(SSN) 
)
------------------Task1 Part3---------------------
create table Project(
PNumber int primary key,
PName varchar(50),
Project_Location varchar(50),
DNum int,
FOREIGN KEY (DNum) REFERENCES Department(DNum) 
)
------------------Task1 Part4---------------------
create table Dependent(
Name varchar(50) primary key,
Gender varchar(50),
Birth_Date date,
SSN int,
FOREIGN KEY (SSN) REFERENCES Employee(SSN) on delete cascade
)
------------------Task1 Part5--------------------
INSERT INTO Employee(SSN, FName, LName, Gender, Birth_Date, Supervise)
VALUES (1, 'Ahmed', 'Mohamed', 'Male', '2005-10-01', NULL);

INSERT INTO Employee(SSN, FName, LName, Gender, Birth_Date, Supervise)
VALUES (2, 'Omar', 'Hassan', 'Male', '2002-06-15', 1)

INSERT INTO Employee(SSN, FName, LName, Gender, Birth_Date, Supervise)
VALUES (3, 'Sara', 'Ali', 'Female', '1999-12-25', 1)

INSERT INTO Employee(SSN, FName, LName, Gender, Birth_Date, Supervise)
VALUES (4, 'Youssef', 'Ibrahim', 'Male', '2000-07-08', 1)

INSERT INTO Employee(SSN, FName, LName, Gender, Birth_Date, Supervise)
VALUES (5, 'Mariam', 'Tarek', 'Female', '2003-11-30', 1);
-------------------Task1 Part6-----------------------
INSERT INTO Department(DNum, DName, Dept_Location, SSN)
VALUES (1, 'CS', 'Menofia', 1)

INSERT INTO Department(DNum, DName, Dept_Location, SSN)
VALUES (2, 'IT', 'Alexandria', 2)

INSERT INTO Department(DNum, DName, Dept_Location, SSN)
VALUES (3, 'IS', 'Giza', 4)
--------
UPDATE  Employee SET DNum = 1 WHERE SSN = 1

UPDATE Employee SET DNum = 2 WHERE SSN = 2

UPDATE Employee SET DNum = 1 WHERE SSN = 3

UPDATE Employee SET DNum = 3 WHERE SSN = 4

UPDATE Employee SET DNum = 1 WHERE SSN = 5

-------------------Task1 Part7-----------------------
UPDATE Employee
SET DNum = 3
WHERE SSN = 2

UPDATE Employee
SET DNum = 2
WHERE SSN = 5
------------------Task1 Part 8----------------------
INSERT INTO Dependent(Name,Gender,Birth_Date,SSN)
VALUES('Mahmoud','Male','6/6/2020',2)

DELETE FROM Dependent
WHERE Name ='Mahmoud'
------------------Task1 Part 9----------------------
SELECT *
FROM Employee e
WHERE e.DNum = 3
------------------Task1 Part 10----------------------
create table Employee_Project(
PNumber int,
SSN int,
PRIMARY KEY (SSN, PNumber),
FOREIGN KEY (SSN) REFERENCES Employee(SSN),
FOREIGN KEY (PNumber) REFERENCES Project(PNumber),
Working_Hours int
)

SELECT e.FName , e.LName , e.SSN , e.Gender , c.PNumber, p.PName , c.Working_Hours 
FROM Employee e , Project p, Employee_Project c
WHERE e.SSN = c.SSN and p.PNumber = c.PNumber
