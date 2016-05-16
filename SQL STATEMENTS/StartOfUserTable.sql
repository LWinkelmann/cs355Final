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
("Jobo", "bergero@sonoma.edu", "Jordan", "S", "Bergero");

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
('Programming I', 115, 'Computer Science'),
('Programming II', 215, 'Computer Science'),
('Intro To Unix', 210, 'Computer Science'),
('Data Structures', 315, 'Computer Science'),
('Calc I', 165, 'Math'),
('Calc II', 210, 'Math');

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
("Dr. Kooshesh", "Darwin", "27", "2");

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
(1,1),
(1,3),
(2,1);

# -- Category Table --
CREATE TABLE Project_Category(
Id INT AUTO_INCREMENT,
CategoryName VARCHAR(50) NOT NULL,
Weight FLOAT NOT NULL,
SectionId INT NOT NULL,
EnrollmentId INT NOT NULL,
FOREIGN KEY (SectionId) REFERENCES Project_Section(Id) ON DELETE CASCADE,
FOREIGN KEY (EnrollmentId) REFERENCES Project_Enrollment(Id) ON DELETE CASCADE,
PRIMARY KEY(Id)
);

INSERT INTO Project_Category
(CategoryName, Weight, SectionId, EnrollmentId)
VALUES
("Quiz", "0.20", "1", "1"),
("Exam", "0.50", "1", "1"),
("Homework", "0.20", "1", "1"),
("ICA", "0.10", "1", "1"),
("Exam", "1", "2", "2");

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
(94, 100, 2, 1), # 94/100 for user 1 in Exam Category (2) for Section 1
(83, 100, 2, 1);

# Returns all users and the classes they are currently taking
SELECT Username, Name as Class_Name, Class_Number, Teacher FROM Project_User u JOIN Project_Enrollment e ON u.Id = e.UserId
JOIN Project_Section s ON s.Id = e.SectionId JOIN Project_Class c 
ON c.Id = s.ClassId ORDER BY (Username);

# Returns all teachers that have tought sections of classes
SELECT DISTINCT(Teacher) FROM Project_Section;
# Simple shows
#SELECT * FROM Project_User;
#SELECT * FROM Project_Class;
#SELECT * FROM Project_Enrollment;
#SELECT * FROM Project_Section;
#SELECT * FROM Project_Category;
#SELECT * FROM Project_Grades;