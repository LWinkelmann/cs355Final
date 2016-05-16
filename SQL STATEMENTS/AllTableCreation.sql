use winkelmann;


# Disabled foreign key checks to make dropping easier
SET FOREIGN_KEY_CHECKS=0; 
DROP TABLE IF EXISTS 
Project_Category,
Project_Grades,
Project_User,
Project_Section,
Project_Class,
Project_Enrollment; 
SET FOREIGN_KEY_CHECKS=1; 
# Re-enabled checks for inserts


# -- User Table --
CREATE TABLE Project_User (
Id INT AUTO_INCREMENT, 
Username VARCHAR(50) NOT NULL,
Email VARCHAR(50) NOT NULL,
FirstName VARCHAR(50) NOT NULL,
MiddleInital VARCHAR(50),
LastName VARCHAR(50) NOT NULL,
Primary Key (Id),
UNIQUE (Username, Email));

INSERT INTO Project_User 
(Username, Email, FirstName, MiddleInital, LastName) 
VALUES 
("0x0d", "winkelma@sonoma.edu", "Lukas", "J", "Winkerman"),
("oHvHo", "lwinkelmann94@gmail.com", "Lucas", "", "Winkelmann"),
("Jobo", "bergero@sonoma.edu", "Jordan", "S", "Bergero"),
("prhostbyte", "haderman@sonoma.edu", "Michael", "X", "Haderman"),
("Dani", "sprouse@sonoma.edu", "Danielle", "Amanda", "Sprouse"),
("CoroNado", "murphy@georgetown.edu", "John", "Jack", "Murphy"),
("Neo", "neo@matrix.com", "Neo", "None", "I can fly"),
("Haruko", "gw2@gw2.com", "Eriq", "Bull", "Hanson");

# -- Class Table --
CREATE TABLE Project_Class (
Id INT AUTO_INCREMENT,
Department VARCHAR(50) NOT NULL,
Class_Number INT NOT NULL,
Name VARCHAR(50) NOT NULL,
PRIMARY KEY (Id));

INSERT INTO Project_Class 
(Name, Class_Number, Department)
VALUES
('Programming I', 115, 'Computer Science'), # 1
('Programming II', 215, 'Computer Science'), # 2
('Intro To Unix', 210, 'Computer Science'), # 3
('Data Structures', 315, 'Computer Science'), # 4
('Calc I', 165, 'Math'), # 5
('Calc II', 210, 'Math'), # 6
('Artificial Intelligence', 480, 'Computer Science'), # 7
('California Ethic Literature', 315, 'English'), # 8
('Developmental Pshycology', 201, 'Psychology'); # 9

# -- Section Table --
CREATE TABLE Project_Section(
Id INT AUTO_INCREMENT,
Teacher VARCHAR(50) NOT NULL,
Building VARCHAR(50) NOT NULL,
RoomNumber INT NOT NULL,
ClassId INT NOT NULL,
FOREIGN KEY (ClassId) REFERENCES Project_Class(Id) ON DELETE CASCADE,
PRIMARY KEY (Id)
);

INSERT INTO Project_Section 
(Teacher, Building, RoomNumber, ClassId)
VALUES
("Dr. Rivoire", "Darwin", "38", "1"),
("Dr. Watts", "Stevenson", "3049", "1"),
("Dr. Watts", "Stevenson", "3049", "1"),
("Dr. Kooshesh", "Darwin", "27", "2"),
("Dr. Kooshesh", "Darwin", "27", "2"),
("Dr. Ravikoomar", "Darwin", "38", "7"),
("Dr. Ravikoomar", "Darwin", "38", "7"),
("Dr. Kooshesh", "Darwin", "103", "4"),
("Dr. Kooshesh", "Darwin", "103", "4"),
("Dr. Rizzuto", "Stevenson", "1002", "8"),
("Dr. Rizzuto", "Stevenson", "1002", "8");

# -- Student To Section Lookup Table --
# This table is used to enroll students into sections
CREATE TABLE Project_Enrollment(
Id INT AUTO_INCREMENT,
UserId INT NOT NULL,
SectionId INT NOT NULL,
FOREIGN KEY (UserId) REFERENCES Project_User(Id) ON DELETE CASCADE,
FOREIGN KEY (SectionId) REFERENCES Project_Section(Id) ON DELETE CASCADE,
PRIMARY KEY (Id));

INSERT INTO Project_Enrollment
(UserId, SectionId)
VALUES
(1,1),(1,5),
(2,1),(2,4),(2,6),
(3,6),(3,8),(3,10),
(4,11),(4,2),(4,8),(4,4),
(5,3),(5,6),(5,11);

# -- Category Table --
CREATE TABLE Project_Category(
Id INT AUTO_INCREMENT,
CategoryName VARCHAR(50) NOT NULL,
Weight FLOAT NOT NULL,
#UserId INT NOT NULL,
#FOREIGN KEY (UserId) REFERENCES Project_User(Id) ON DELETE CASCADE,
#SectionId INT NOT NULL,
EnrollmentId INT NOT NULL,
#FOREIGN KEY (SectionId) REFERENCES Project_Section(Id) ON DELETE CASCADE,
FOREIGN KEY (EnrollmentId) REFERENCES Project_Enrollment(Id) ON DELETE CASCADE,
PRIMARY KEY(Id)
);

INSERT INTO Project_Category
(CategoryName, Weight, EnrollmentId)
VALUES
("Quiz", "0.20", "1"),
("Exam", "0.50", "1"),
("Homework", "0.20", "1"),
("ICA", "0.10", "1"),
("Exam", "0.5", "2"),
("Quiz", "0.5", "2"),
("Exam", "0.3", "2"),
("Quiz", "0.3", "5"),
("Exam", "0.7", "5"),
("Quiz", "0.3", "7"),
("Homework", "0.3", "7"),
("Final", "0.4", "7");

# -- Grades Table --
CREATE TABLE Project_Grades(
Score FLOAT NOT NULL,
MaxScore FLOAT NOT NULL,
CategoryId INT NOT NULL,
EnrollmentId INT NOT NULL,
FOREIGN KEY (CategoryId) REFERENCES Project_Category(Id) ON DELETE CASCADE,
FOREIGN KEY (EnrollmentId) REFERENCES Project_Enrollment(ID) ON DELETE CASCADE
);

INSERT INTO Project_Grades
(Score, MaxScore, CategoryId, EnrollmentId)
VALUES
(11, 20, 1, 1),
(94, 100, 2, 1), # 94/100 for user 1 in Exam Category (2) for Section 1
(83, 100, 2, 1),
(4, 10, 3, 3),
(61, 75, 5, 2),
(52, 75, 5, 2),
(11, 32, 5, 2),
(61, 75, 10, 7);

# Returns all users and the classes they are currently taking
SELECT Username, Name as Class_Name, Class_Number, Department, Teacher, s.Id AS Section_Number FROM Project_User u JOIN Project_Enrollment e ON u.Id = e.UserId
JOIN Project_Section s ON s.Id = e.SectionId JOIN Project_Class c 
ON c.Id = s.ClassId ORDER BY (Username);

# Returns all teachers that have tought sections of classes
SELECT DISTINCT(Teacher) FROM Project_Section;

# Sub - Query
# Returns the average grade of a user
SELECT a.* FROM
(SELECT * FROM Project_User u JOIN
Project_Enrollment e ON u.Id = e.UserId JOIN
Project_Grades g ON g.EnrollmentId = e.Id) a;

SELECT UserId,AVG(Score)/AVG(MaxScore) AS Grade FROM ( SELECT a.* FROM (SELECT * FROM Project_Enrollment e JOIN
Project_Grades g on g.EnrollmentId = e.Id) a JOIN Project_User u on a.UserId = u.Id) b
GROUP BY UserId;
# Why does this return user id 1 classes grades 2 times

# Returns users who have grades entered.
SELECT * FROM Project_User u WHERE EXISTS
(SELECT *, Score FROM Project_Enrollment e JOIN
Project_Grades g ON g.EnrollmentId = e.Id WHERE u.Id = e.UserId);

# Where not exsists
# Returns all users who have not taken a section
SELECT * FROM Project_User u WHERE NOT EXISTS 
(SELECT * FROM Project_Enrollment e WHERE u.Id = e.UserId);


# Data modification
DROP TABLE IF EXISTS Project_UserAvgGrade;
CREATE TABLE Project_UserAvgGrade AS 
(SELECT u.Id, e.SectionId as SectionId, Username, c.Name, Avg(Score) as TotalPoints, Avg(MaxScore) as maxTotalPoints, AVG(Score)/AVG(MaxScore) as Grade 
FROM Project_User u JOIN 
Project_Enrollment e ON u.Id = e.UserId JOIN 
Project_Grades g ON g.EnrollmentId = e.Id JOIN
Project_Class c ON e.Id = c.Id GROUP BY c.Name);

SELECT * FROM Project_UserAvgGrade;

SELECT Username, c.Name, Avg(Score) as TotalPoints, Avg(MaxScore) as maxTotalPoints, AVG(Score)/AVG(MaxScore) as Grade 
FROM Project_User u JOIN 
Project_Enrollment e ON u.Id = e.UserId JOIN 
Project_Grades g ON g.EnrollmentId = e.Id JOIN
Project_Class c ON e.Id = c.Id GROUP BY c.Name;

# Function
DROP FUNCTION IF EXISTS user_grade_with_id;
DELIMITER //
CREATE FUNCTION user_grade_with_id(_user_id int, _section_id int) RETURNS FLOAT
BEGIN 
	DECLARE g FLOAT;
    SELECT grade into g from Project_UserAvgGrade WHERE Id = _user_id AND SectionId = _section_id;
    RETURN g;
END //
DELIMITER ;

SELECT Username, user_grade_with_id(u.Id,e.Id) AS avg_grade FROM Project_User u JOIN
Project_Enrollment e ON u.Id = e.UserId; 

# Union
SELECT Teacher FROM Project_Section UNION SELECT FirstName FROM Project_User;

# Simple shows
SELECT * FROM Project_User;
SELECT * FROM Project_Class;
SELECT * FROM Project_Enrollment;
SELECT * FROM Project_Section;
SELECT * FROM Project_Category;
SELECT * FROM Project_Grades;

SELECT * FROM Project_Enrollment e JOIN Project_Grades g ON g.EnrollmentId = e.Id 
JOIN Project_Section s ON s.Id = e.SectionId 
JOIN Project_Class c ON c.Id = s.ClassId;

SELECT c.Name as Class_Name, AVG(Score)/AVG(MaxScore) as Avg_Grade FROM Project_Enrollment e JOIN Project_Grades g ON g.EnrollmentId = e.Id 
JOIN Project_Section s ON s.Id = e.SectionId 
JOIN Project_Class c ON c.Id = s.ClassId GROUP BY Class_Name;


CREATE OR REPLACE VIEW class_avg_grade AS SELECT c.Name as Class_Name, AVG(Score)/AVG(MaxScore) as Avg_Grade FROM Project_Enrollment e JOIN Project_Grades g ON g.EnrollmentId = e.Id 
JOIN Project_Section s ON s.Id = e.SectionId 
JOIN Project_Class c ON c.Id = s.ClassId GROUP BY Class_Name;

DROP PROCEDURE IF EXISTS users_with_grade_above;
DELIMITER //
CREATE PROCEDURE users_with_grade_above (_minGrade float)
	BEGIN
    SELECT * FROM Project_UserAvgGrade WHERE Grade >= _minGrade;
    END //
DELIMITER ;

Call users_with_grade_above(0.50);

SELECT * FROM Project_UserAvgGrade;
SELECT * FROM class_avg_grade;

# DO NOT DELETE
CREATE OR REPLACE VIEW class_to_section AS (SELECT s.*, c.Class_Number, c.Name FROM Project_Section s JOIN Project_Class c ON c.id = s.ClassId);

SELECT * FROM class_to_section WHERE ClassId = 1;

SELECT * FROM Project_Class;
# DO NOT DELETE
CREATE OR REPLACE VIEW users_classes AS (SELECT u.*,c.Department, e.SectionId, s.Teacher, s.Building, s.RoomNumber, c.Name, c.Class_Number FROM Project_Enrollment e JOIN Project_User u ON e.UserId = u.Id
JOIN Project_Section s ON e.SectionId = s.Id JOIN Project_Class c on s.ClassId = c.Id);

SELECT * FROM users_classes where Id = 1;

SELECT s.*, c.Class_Number, c.Name FROM Project_Section s JOIN Project_Class c ON c.id = s.ClassId WHERE ClassId =1;