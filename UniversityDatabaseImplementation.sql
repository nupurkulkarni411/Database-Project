
 ---------------------------------						
 --Name: Nupur Kulkarni
 --SUID: 631402325
 ---------------------------------



 --***********************
 --Creation of New Schema
 --***********************

CREATE SCHEMA pr2;
GO

--************************************
--Table Creation Scripts (25 tables)
--************************************

CREATE TABLE pr2.Addresses
(
	AddressID     INTEGER        PRIMARY KEY    IDENTITY(1,1),
	Street1       VARCHAR(20)    NOT NULL,
	Street2       VARCHAR(20),
	City          VARCHAR(20)    NOT NULL,
	State         VARCHAR(20)    NOT NULL,
	ZIP           VARCHAR(10)    NOT NULL
);

CREATE TABLE pr2.AreaOfStudy
(
	AreaOfStudyID	    VARCHAR(20)						PRIMARY KEY,
	StudyTitle	        VARCHAR(50)			NOT NULL,
	CollegeID	        INTEGER				NOT NULL	REFERENCES pr2.College(CollegeID)
);

CREATE TABLE pr2.Benefits
(
	BenefitID           INTEGER        PRIMARY KEY    IDENTITY(1,1),
	BenefitCost         INTEGER        NOT NULL,
	BenefitDescription  VARCHAR(500),
	BenefitSelection    INTEGER        NOT NULL       REFERENCES pr2.BenefitSelection(BenefitSelectionID),
);

CREATE TABLE pr2.BenefitSelection
(
	BenefitSelectionID INTEGER      PRIMARY KEY     IDENTITY(1,1),
	BenefitSelection   VARCHAR(20)  NOT NULL
);

CREATE TABLE pr2.Buildings
(
	ID				INTEGER      PRIMARY KEY   IDENTITY(1,1),
	BuildingName	VARCHAR(80)  NOT NULL
);

CREATE TABLE pr2.ClassRoom
(
	ClassRoomID		VARCHAR(20)  NOT NULL	PRIMARY KEY,
	Building		INTEGER      NOT NULL   REFERENCES pr2.Buildings(Id),
	RoomNumber		VARCHAR(20)  NOT NULL,
	MaximumSeating	INTEGER      NOT NULL   CHECK(MaximumSeating > 0),
	Projector		INTEGER      NOT NULL   REFERENCES pr2.ProjectorInfo(ProjectorID),
	WhiteBoardCount INTEGER      NOT NULL,
	OtherAV         VARCHAR(20)  
);

CREATE TABLE pr2.College
(
	CollegeID	INTEGER		PRIMARY KEY		IDENTITY(1,1),
	CollegeName	VARCHAR(20)	NOT NULL		UNIQUE
);

CREATE TABLE pr2.CourseCatalogue
(
	CourseCode   VARCHAR(20) NOT NULL,
	CourseNumber INTEGER     NOT NULL,
	PRIMARY KEY (CourseCode,CourseNumber),
	CourseTitle  VARCHAR(50) NOT NULL,
	CourseDesc   VARCHAR(500) 
);

CREATE TABLE pr2.CourseDailySchedule
(
	DailyID			INTEGER	  PRIMARY KEY	  IDENTITY(1,1),
	CourseID		INTEGER	  NOT NULL        UNIQUE			REFERENCES pr2.CourseSchedule(CourseScheduleID),
	DayOfWeek		INTEGER	  NOT NULL							REFERENCES pr2.DayOfWeek(Id),
	StartTime		TIME	  NOT NULL,
	EndTime     	TIME      NOT NULL		  CHECK (EndTime > StartTime)
);

CREATE TABLE pr2.CourseEnrollment
(
	EnrollmentID	INTEGER	        PRIMARY KEY,
	CourseID	    INTEGER	        NOT NULL      REFERENCES    pr2.CourseSchedule(CourseScheduleID),
	StudentID	    INTEGER	        NOT NULL      REFERENCES    pr2.StudentInfo(StudentID),
	StatusID	    INTEGER	        NOT NULL      REFERENCES    pr2.StudentGradingStatus(StudentGradingStatusID),
	GradeID	        INTEGER	                      REFERENCES    pr2.Grades(GradeID)
);

CREATE TABLE pr2.CourseSchedule
(
	CourseScheduleID INTEGER     PRIMARY KEY IDENTITY(1,1),
	CourseCode       VARCHAR(20) NOT NULL,
	CourseNumber	 INTEGER     NOT NULL,
	FOREIGN KEY(CourseCode,CourseNumber)  REFERENCES pr2.CourseCatalogue(CourseCode, CourseNumber),
	NumberOfSeats    INTEGER     NOT NULL CHECK(NumberOfSeats>=0),
	Location		 VARCHAR(20)          REFERENCES pr2.ClassRoom(ClassRoomID),
	Semester		 INTEGER     NOT NULL REFERENCES pr2.SemesterInfo(SemesterID)
);

CREATE TABLE pr2.DayOfWeek
(
	Id	    INTEGER			PRIMARY KEY	 IDENTITY(1,1),
	Text	VARCHAR(50)		NOT NULL	 UNIQUE
);

CREATE TABLE pr2.EmployeeInfo
(
	EmployeeID     VARCHAR(20)    PRIMARY KEY,
	PersonID       INTEGER        NOT NULL       REFERENCES pr2.People(PersonID),
	YearlyPay      DECIMAL(10,2)  NOT NULL,
	HealthBenefits INTEGER        NOT NULL       REFERENCES pr2.Benefits(BenefitID),
	VisionBenefits INTEGER        NOT NULL       REFERENCES pr2.Benefits(BenefitID),
	DentalBenefits INTEGER        NOT NULL       REFERENCES pr2.Benefits(BenefitID),
	JobInformation InTEGER        NOT NULL       REFERENCES pr2.JobInformation(JobID)
);

CREATE TABLE pr2.Grades
(
	GradeID	    INTEGER	       PRIMARY KEY	 IDENTITY(1,1),
	Grade		VARCHAR(20)	   NOT NULL		 UNIQUE
);

CREATE TABLE pr2.JobInformation
( 
	JobID           INTEGER        PRIMARY KEY    IDENTITY(1,1),
	JobDescription  VARCHAR(500)   NOT NULL,
	JobRequirements VARCHAR(500),
	MinPay          DECIMAL(10,2)  NOT NULL       CHECK  (Minpay >= 0),
    MaxPay          DECIMAL(10,2)  NOT NULL       CHECK  (Maxpay >= 0),
	UnionJob        VARCHAR(3)     NOT NULL	      DEFAULT 'Yes'
);

CREATE TABLE pr2.People
(
	PersonID     INTEGER        PRIMARY KEY		IDENTITY(1,1),
	NTID         VARCHAR(20)    NOT NULL		UNIQUE,
	FirstName    VARCHAR(50)    NOT NULL,
    LastName     VARCHAR(50)    NOT NULL,
	Password     VARCHAR(50),
	DOB          DATE           NOT NULL,
	SSN          VARCHAR(11),
	HomeAddress  INTEGER        NOT NULL		REFERENCES pr2.Addresses(AddressID),
	LocalAddress INTEGER						REFERENCES pr2.Addresses(AddressID),
	IsActive     VARCHAR(3)     NOT NULL		DEFAULT 'Yes'
);

CREATE TABLE pr2.Prerequisites
(
	ParentCode   VARCHAR(20) NOT NULL,
	ParentNumber INTEGER     NOT NULL,
	ChildCode    VARCHAR(20) NOT NULL,
	ChildNumber  INTEGER     NOT NULL,
	PRIMARY KEY (ParentCode, ParentNumber,ChildCode,ChildNumber),
	FOREIGN KEY (ParentCode, ParentNumber) REFERENCES pr2.CourseCatalogue(CourseCode, CourseNumber),
	FOREIGN KEY (ChildCode,ChildNumber)    REFERENCES pr2.CourseCatalogue(CourseCode, CourseNumber)
);

CREATE TABLE pr2.ProjectorInfo
(
	ProjectorID   INTEGER      PRIMARY KEY  IDENTITY(1,1),
	ProjectorText VARCHAR(20)  NOT NULL
);

CREATE TABLE pr2.SemesterInfo
(
	SemesterID	INTEGER	    PRIMARY KEY		  IDENTITY(1,1),
	Semester	INTEGER	    NOT NULL		  REFERENCES        pr2.SemesterText(SemesterTextID),
	Year		INTEGER	    NOT NULL,
	FirstDay	DATE		NOT NULL,
	LastDay		DATE		NOT NULL          CHECK(LastDay > FirstDay)
);

CREATE TABLE pr2.SemesterText
(
	SemesterTextID	INTEGER			PRIMARY KEY		IDENTITY(1,1),
	SemesterText	VARCHAR(50)		NOT NULL
);

CREATE TABLE pr2.StudentAreaOfStudy
(
	AreaOfStudyID	INTEGER	      PRIMARY KEY,
	StudentID		INTEGER	      NOT NULL		REFERENCES pr2.StudentInfo(StudentID),
	AreaID		    VARCHAR(20)	  NOT NULL		REFERENCES pr2.AreaOfStudy(AreaOfStudyID),
	IsMajor			VARCHAR(3)	  NOT NULL
);

CREATE TABLE pr2.StudentGradingStatus
(
	StudentGradingStatusId      INTEGER	       PRIMARY KEY IDENTITY(1,1),
	StudentGradingStatus        VARCHAR(20)    NOT NULL
);

CREATE TABLE pr2.StudentInfo 
(
	StudentID				INTEGER	    PRIMARY KEY    IDENTITY(1,1),
	PersonID				INTEGER 	NOT NULL       REFERENCES     pr2.People(PersonID),
	StudentStatusID			INTEGER					   REFERENCES     pr2.StudentStatus(StudentStatusID)	
);

CREATE TABLE pr2.StudentStatus 
(
	StudentStatusID      INTEGER	    PRIMARY KEY	   IDENTITY(1,1),
	StudentStatus		 VARCHAR(80)	NOT NULL
);

CREATE TABLE pr2.TeachingAssignment
(
	EmployeeID           VARCHAR(20)     NOT NULL	  REFERENCES pr2.EmployeeInfo(EmployeeID),
	CourseScheduleID     INTEGER         NOT NULL     REFERENCES pr2.CourseSchedule(CourseScheduleID) ,
	PRIMARY KEY (EmployeeID, CourseScheduleID)
);


--*************************
--Data Loading commands
--*************************

--Data inserted seperately was added later for testing purpose

INSERT INTO pr2.Addresses (Street1, Street2 , City , State , ZIP) VALUES 
('740 Park Avenue','Westcott Street','Syracuse','NewYork','13210'),
('437 Columbus Avenue','Westcott Street','Syracuse','NewYork','13210'),
('128 Westcott Street',NULL,'Syracuse','NewYork','13210'),
('12th Avenue',NULL,'Syracuse','NewYork','13210'),
('1120 N Street','Eureka','Sacremento','California','96001'),
('111 Grand Avenue',NULL,'East Bay','California','96000'),
('Paras Apartment','Paud Road','Pune','Maharashtra','411038'),
('123 Kailas Tower','Powai','Mumbai','Maharashtra','760004');

--SELECT * FROM pr2.Addresses

INSERT INTO pr2.AreaOfStudy VALUES
('01-CE','Computer Engineering',1),
('02-ME','Mechanical Engineering',1),
('03-CE','Civil Engineering',1),
('04-AP','Astrophysics',3),
('05-SE','Systems Engineering',1),
('08-S','Statistics',5);

--SELECT * FROM pr2.AreaOfStudy

INSERT INTO pr2.Benefits (BenefitCost,BenefitDescription,BenefitSelection) VALUES
(1000,'OutpatientCare',3),
(2000,'ICU',1),
(3000, 'InpatientCare',2),
(4000, 'BabyCare',2),
(5000, 'Psychotherapy',1),
(6000, 'LabTest',3)

--SELECT * FROM pr2.Benefits

INSERT INTO pr2.BenefitSelection (BenefitSelection) VALUES 
('Single'),
('Family'),
('Op-out');

--SELECT * FROM pr2.BenefitSelection;

INSERT INTO pr2.Buildings (BuildingName) VALUES
('Crouse College'),
('Hall of Languages'),
('Hendricks Chapel'),
('Center for Science and Technology'),
('Newhouse Communications Center'),
('Slutzker Center')

--SELECT * FROM pr2.Buildings;

INSERT INTO pr2.ClassRoom (ClassRoomID,Building,RoomNumber,MaximumSeating,Projector,WhiteBoardCount,OtherAV) VALUES
('01-CC',1,'CC-101',50,2,3,'Slide Projector'),
('02-HL',2,'HL-410',50,3,2,'Conference Phone'),
('03-HC',3,'HC-114',40,1,2,'Handheld Microphone'),
('04-CST',4,'CST-112',80,3,1,'Tape Player'),
('05-NCC',5,'NCC-312',30,4,0,'Podiums'),
('06-SC',6,'SC-222',20,2,3,'Audio Recording')

--SELECT * FROM pr2.ClassRoom

INSERT INTO pr2.College(CollegeName)VALUES
('College Of Engineering'),
('College of Journalism'),
('College of Information Studies'),
('College of Management Studies'),
('Physics College'),
('College of Mathematics'),
('Arts college'),
('College of Pschycology studies');

--SELECT * FROM pr2.College

INSERT INTO pr2.CourseCatalogue VALUES('CS','702','Integer Optimization','Introduces optimization problems over integers, and surveys the theory behind the algorithms used in state-of-the-art methods for solving such problems.')
INSERT INTO pr2.CourseCatalogue VALUES('CS','612','Machine Learning','Computational approaches to learning: including inductive inference, explanation-based learning, analogical learning, connectionism, and formal models.')
INSERT INTO pr2.CourseCatalogue VALUES('EE','632','VLSI Systems Design','Overview of MOS devices and circuits; introduction to integrated circuit fabrication; topological design of data flow and control; interactive graphics layout; circuit simulation; system timing; organizational and architectural considerations; alternative implementation approaches')
INSERT INTO pr2.CourseCatalogue VALUES('EE','662','Advanced Computer Architecture','Advanced techniques of computer design. Parallel processing and pipelining; multiprocessors, multi-computers and networks; high performance machines and special purpose processors; data flow architecture.')
INSERT INTO pr2.CourseCatalogue VALUES('CS','772','Distributed Systems','distributed programming; distributed file systems; atomic actions; fault tolerance, transactions, program & data replication, recovery; distributed machine architectures; security and authentication')
INSERT INTO pr2.CourseCatalogue VALUES('CS','692','Dynamic Programming','A generalized optimization model; discrete and continuous state spaces; deterministic and stochastic transition functions. Multistage decision processes. Functional equations and successive approximation in function ')
INSERT INTO pr2.CourseCatalogue VALUES('MAE','111','Energy Conversion','Energy demand and resources. Fundamentals of combustion. Power plants, refrigeration systems. Turbines and engines.')
INSERT INTO pr2.CourseCatalogue VALUES('CE','775','Distributed Objects','Design and implement software components using the Component Object Model (COM).')

--SELECT * FROM pr2.CourseCatalogue

INSERT INTO pr2.CourseDailySchedule (CourseID , DayOfWeek , StartTime , EndTime) VALUES
(13,2,'13:00:00','15:00:00');

DBCC CHECKIDENT ('pr2.CourseDailySchedule', RESEED, 2)

INSERT INTO pr2.CourseDailySchedule (CourseID , DayOfWeek , StartTime , EndTime) VALUES
(19,2,'15:00:00','17:00:00');

DBCC CHECKIDENT ('pr2.CourseDailySchedule', RESEED, 4)
INSERT INTO pr2.CourseDailySchedule (CourseID , DayOfWeek , StartTime , EndTime) VALUES
(20,3,'16:00:00','18:00:00'),
(21,4,'18:00:00','19:20:00'),
(22,5,'9:00:00','10:30:00'),
(27,3,'16:30:00','19:00:00'),
(29,1,'15:00:00','18:00:00'),
(30,1,'16:00:00','19:00:00')

--SELECT * FROM pr2.CourseDailySchedule

INSERT INTO pr2.CourseEnrollment (EnrollmentID,CourseID,StudentID,StatusID,GradeID) VALUES
(200,13,1,1,1),
(201,19,1,2,NULL),
(202,20,3,1,4),
(203,21,4,2,2),
(204,22,5,2,NULL),
(205,27,2,1,1),
(206,13,6,1,NULL)

--SELECT * FROM pr2.CourseEnrollment

DBCC CHECKIDENT ('pr2.CourseSchedule', RESEED, 12)
INSERT INTO pr2.CourseSchedule (CourseCode,CourseNumber,NumberOfSeats,Location,Semester) VALUES 
('CS', 612 ,50,'04-CST',1);

DBCC CHECKIDENT ('pr2.CourseSchedule', RESEED, 18)
INSERT INTO pr2.CourseSchedule (CourseCode,CourseNumber,NumberOfSeats,Location,Semester) VALUES 
('CS', 692 ,60,'04-CST',2),
('EE', 632 ,25,'05-NCC',3),
('EE', 662 ,35,'03-HC',4),
('CS', 702 ,45,'02-HL',5)

DBCC CHECKIDENT ('pr2.CourseSchedule', RESEED, 26)
INSERT INTO pr2.CourseSchedule (CourseCode,CourseNumber,NumberOfSeats,Location,Semester) VALUES 
('CS', 772 ,15,NULL,7);

DBCC CHECKIDENT ('pr2.CourseSchedule', RESEED, 28)
INSERT INTO pr2.CourseSchedule (CourseCode,CourseNumber,NumberOfSeats,Location,Semester) VALUES 
('MAE', 111 ,30,NULL,1),
('CE', 775 , 30 , NULL , 8)

--SELECT * FROM pr2.CourseSchedule

INSERT INTO pr2.DayOfWeek(Text) VALUES
('Sunday'),
('Monday'),
('Tuesday'),
('Wednesday'),
('Thursday'),
('Friday'),
('Saturday');

--SELECT * FROM pr2.DayOfWeek;

INSERT INTO pr2.EmployeeInfo (EmployeeID, PersonID , YearlyPay , HealthBenefits , VisionBenefits, DentalBenefits , JobInformation) VALUES
('01-PR', 7 , 23000.00 , 2 , 1 , 3 , 4),
('02-TA', 9 , 10000.00 , 1 , 5 , 1 , 6),
('03-TS', 8 , 50000.00 , 5 , 2 , 4 , 2),
('04-FA', 10 , 3000.00 , 4 , 6 , 2 , 1),
('05-AA', 12 , 40000.00 , 1 , 4 , 5 , 6),
('10-GI', 11 , 5000.00 , 2 , 4 , 1 , 3)

--SELECT * FROM pr2.EmployeeInfo

INSERT INTO pr2.Grades(Grade)VALUES
('A'),
('B'),
('C'),
('D');

--SELECT * FROM pr2.Grades

INSERT INTO pr2.JobInformation (JobDescription,JobRequirements,MinPay,MaxPay,UnionJob) VALUES
('Professor','Minimum Qualification is PhD and a minimum of 5 years teaching experience',2000.00,50000.00,'No'),
('Assistant Professor','Minimum Qualification is PhD and a minimum of 2 years teaching experience', 10000.00,80000.00,'Yes'),
('Visiting Professor','Minimum Qualification is PhD and a minimum of 2 years Industry experience',6000.00,60000.00,'No'),
('Lecturer','Minimum of a bachelor degree in an academic field of study',10000.00,90000.00,'Yes'),
('Research Professor','Minimum of a doctoral degree in an academic field of study and a minimum of 4 years research experience',7000.00,45000.00,'No'),
('Teaching Assistant','Minimum of a bachelor degree in an academic field of study and persuing doctoral degree',10000.00,95000.00,'No')

--SELECT * FROM pr2.JobInformation

--Students
INSERT INTO pr2.People (NTID ,FirstName, LastName, Password, DOB , SSN , HomeAddress , LocalAddress , IsActive) VALUES
('07-GA','Gomez','Addams','JASj23','19931204','374-AB-WE12', 1 , NULL, 'Yes'),
('08-MA','Morticia','Addams','ehreu12_ty', '19940112',NULL , 3 , 4, 'Yes'),
('09-PA','Pugsley','Addams',NULL, '19920215', NULL , 3 , 1, 'Yes'),
('10-WA','Wednesday','Addams','wed12nes34day_77', '19900618','F56-TH-4657' , 4 , 6, 'No'),
('11-UF','Uncle','Fester', NULL , '19920214','Q12-FH-5623', 2 , NULL, 'Yes'),
('12-GA','Grandmama','Addams', 'fhdfh&48' , '19800719','439-SD-1234', 5 , 3 , 'No')

--Professors/employees
INSERT INTO pr2.People (NTID ,FirstName, LastName, Password, DOB , SSN , HomeAddress , LocalAddress , IsActive) VALUES
('01-Sd','Scooby','Doo','Hello123','20080618 10:34:09 AM','102-02-1992', 1 , 2, 'Yes'),
('02-Sr','Shaggy','Rogers',NULL, '19930413 10:34:09 AM','1AB-01-1912',1 , 2, 'Yes'),
('03-Fj','Fred','Jones',NULL, '19920609 10:55:10 AM','113-0B-19LK' ,5 , 4, 'Yes'),
('04-Db','Daphne','Blake','Shaggy221', '19900218 09:34:09 AM','FHJ-59-5759' ,1 , 6, 'No'),
('05-Vd','Velma','Dinkley','11Velm12', '19921020 08:30:09 AM','HJC-36-8430',2 , NULL, 'Yes'),
('06-Yd','Yabba','Doo',NULL, '19900719 04:17:19 AM','475-47-SGFC', 5 , NULL, 'No')

--SELECT * FROM pr2.People

INSERT INTO pr2.Prerequisites (ParentCode , ParentNumber , ChildCode , ChildNumber) VALUES
('CE',787,'CS',692),
('CE',787,'CS',772),
('CS',784,'CS',702),
('CS',612,'CE',787),
('EE',632,'EE',662)

--SELECT * FROM pr2.Prerequisites

INSERT INTO pr2.ProjectorInfo(ProjectorText) VALUES
('BASIC/NO'),
('SMARTBOARD/NO'),
('BASIC/YES'),
('SMARTBOARD/YES');

--SELECT * FROM pr2.ProjectorInfo

INSERT INTO pr2.SemesterInfo(Semester,Year,FirstDay,LastDay)VALUES
(1,2012,'20120618','20121218'),
(2,2013,'20130116','20130516'),
(1,2013,'20130616','20131216'),
(2,2014,'20140116','20140516'),
(1,2014,'20140616','20141216'),
(2,2015,'20150116','20150516')

INSERT INTO pr2.SemesterInfo(Semester,Year,FirstDay,LastDay)VALUES
(1,2016,'20160618','20161218')

INSERT INTO pr2.SemesterInfo(Semester,Year,FirstDay,LastDay)VALUES
(2,2016,'20160116','20160518')

--SELECT * FROM pr2.SemesterInfo

INSERT INTO pr2.SemesterText(SemesterText) VALUES
('FALL'),
('SPRING'), 
('SUMMER')

--SELECT * FROM pr2.SemesterText

INSERT INTO pr2.StudentAreaOfStudy (AreaOfStudyID,StudentID,AreaID,IsMajor) VALUES
(100, 2 , '01-CE' , 'Yes'),
(101, 1 , '02-ME' , 'No'),
(102, 5 , '03-CE' , 'Yes'),
(103, 6 , '04-AP' , 'No'),
(104, 3 , '05-SE' , 'Yes'),
(105, 4 , '08-S' , 'No')

--SELECT * FROM pr2.StudentAreaOfStudy

INSERT INTO pr2.StudentGradingStatus (StudentGradingStatus) VALUES ('Graded');
INSERT INTO pr2.StudentGradingStatus (StudentGradingStatus) VALUES ('Ungraded');

--SELECT * FROM pr2.StudentGradingStatus

INSERT INTO pr2.StudentInfo (PersonID, StudentStatusID) VALUES
(3,4),
(4,3),
(6,3),
(1,1),
(5,2),
(2,4)

--SELECT * FROM pr2.StudentInfo

INSERT INTO pr2.StudentStatus (StudentStatus) VALUES 
('Full-Time'),
('Part-Time'),
('Voluntary Withdrawal'),
('Expelled');

--SELECT * FROM pr2.StudentStatus

INSERT INTO pr2.TeachingAssignment (EmployeeID,CourseScheduleID) VALUES
('01-PR',13),
('02-TA',19),
('03-TS',20),
('04-FA',21),
('05-AA',22),
('10-GI',27)

--SELECT * FROM pr2.TeachingAssignment

--***************
--Views (5 views)
--***************
------------------------------------------------------------------------------------------------------------------------------------------------------
---1. View displaying students enrolled in particular college 
------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE VIEW pr2.StudentEnrolledInCollege AS
SELECT	pr2.People.FirstName + ' ' + pr2.People.LastName AS StudentName , pr2.College.CollegeName AS CollegeName 
		FROM pr2.People INNER JOIN pr2.StudentInfo 
			 ON pr2.People.PersonID = pr2.StudentInfo.PersonID 
			 INNER JOIN pr2.StudentAreaOfStudy
			 ON pr2.StudentAreaOfStudy.StudentID = pr2.StudentInfo.StudentID
			 INNER JOIN pr2.AreaOfStudy
			 ON pr2.AreaOfStudy.AreaOfStudyID = pr2.StudentAreaOfStudy.AreaID
			 INNER JOIN pr2.College
			 ON  pr2.AreaOfStudy.CollegeID = pr2.College.CollegeID
			 WHERE pr2.People.IsActive = 'Yes'
			 
--SELECT * FROM pr2.StudentEnrolledInCollege
--SELECT * FROM pr2.StudentEnrolledInCollege WHERE StudentName = 'Pugsley Addams'
--SELECT * FROM pr2.StudentEnrolledInCollege WHERE CollegeName = 'College Of Engineering' 
--SELECT CollegeName , COUNT(*) AS NumberOfStudents 
--	   FROM pr2.StudentEnrolledInCollege 
--	        WHERE CollegeName = 'College Of Engineering'
--			GROUP BY CollegeName 

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--2.This view shows time table of all courses which will help students while selecting courses. 
--Schedule includes Course Title, Faculty, Start time, End Time, Day of week and Class Room
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE VIEW pr2.CourseTimeTable AS
			SELECT	pr2.CourseCatalogue.CourseTitle AS CourseTitle , 
					pr2.People.FirstName + ' ' + pr2.People.LastName AS Instructor,
					pr2.DayOfWeek.Text AS Day,
					LEFT(CONVERT(TIME,pr2.CourseDailySchedule.StartTime,100),8) AS StartTime,
					LEFT(CONVERT(TIME,pr2.CourseDailySchedule.EndTime,100),8)   AS EndTime,
					pr2.Buildings.BuildingName AS Building,
					pr2.ClassRoom.RoomNumber AS RoomNumber

					FROM	pr2.TeachingAssignment INNER JOIN pr2.EmployeeInfo
					ON      pr2.TeachingAssignment.EmployeeID = pr2.EmployeeInfo.EmployeeID
					INNER JOIN pr2.People
					ON		pr2.EmployeeInfo.PersonID = pr2.People.PersonID
					INNER JOIN pr2.CourseSchedule
					ON		pr2.TeachingAssignment.CourseScheduleID = pr2.CourseSchedule.CourseScheduleID
					INNER JOIN pr2.CourseDailySchedule
					ON		pr2.CourseDailySchedule.CourseID = pr2.CourseSchedule.CourseScheduleID
					INNER JOIN pr2.DayOfWeek
					ON		pr2.DayOfWeek.Id = pr2.CourseDailySchedule.DayOfWeek
					INNER JOIN pr2.CourseCatalogue
					ON		pr2.CourseCatalogue.CourseCode = pr2.CourseSchedule.CourseCode AND pr2.CourseCatalogue.CourseNumber = pr2.CourseSchedule.CourseNumber
					INNER JOIN pr2.ClassRoom
					ON		pr2.CourseSchedule.Location = pr2.ClassRoom.ClassRoomID
					INNER JOIN pr2.Buildings
					ON		pr2.ClassRoom.Building = pr2.Buildings.Id

--SELECT * FROM pr2.CourseTimeTable
--SELECT * FROM pr2.CourseTimeTable WHERE CourseTitle = 'Machine Learning' 

------------------------------------------------------------------------------------------------------------------------------------------------------------
--3. View displaying courses offered in various semesters.
--Output : Course Title, Semester, Year
------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE VIEW pr2.CoursesOffered AS
			SELECT pr2.CourseCatalogue.CourseTitle AS CourseTitle , pr2.SemesterText.SemesterText AS Semester , pr2.SemesterInfo.Year AS Year
				   FROM pr2.CourseCatalogue INNER JOIN pr2.CourseSchedule 
				   ON pr2.CourseCatalogue.CourseCode = pr2.CourseSchedule.CourseCode AND pr2.CourseCatalogue.CourseNumber = pr2.CourseSchedule.CourseNumber
				   INNER JOIN pr2.SemesterInfo
				   ON pr2.CourseSchedule.Semester = pr2.SemesterInfo.SemesterID 
				   INNER JOIN pr2.SemesterText
				   ON pr2.SemesterInfo.Semester = pr2.SemesterText.SemesterTextID 


--SELECT * FROM pr2.CoursesOffered
--SELECT * FROM pr2.CoursesOffered WHERE Semester = 'FALL' AND Year = '2016'

-----------------------------------------------------------------------------------------------------
--4. View displaying the faculty's name, job title, course taught and semester 
------------------------------------------------------------------------------------------------------

CREATE VIEW pr2.FacultyInfo AS
			SELECT pr2.People.FirstName + ' ' + pr2.People.LastName AS EmployeeName,
				   pr2.JobInformation.JobDescription AS JobTitle,
				   pr2.CourseCatalogue.CourseTitle AS CourseTitle,
				   pr2.SemesterText.SemesterText AS Semester 

				   FROM pr2.People INNER JOIN pr2.EmployeeInfo
				   ON	pr2.People.PersonID = pr2.EmployeeInfo.PersonID
				   INNER JOIN pr2.JobInformation
				   ON	pr2.EmployeeInfo.JobInformation = pr2.JobInformation.JobID
				   INNER JOIN pr2.TeachingAssignment
				   ON	pr2.TeachingAssignment.EmployeeID = pr2.EmployeeInfo.EmployeeID
				   INNER JOIN pr2.CourseSchedule
				   ON	pr2.CourseSchedule.CourseScheduleID = pr2.TeachingAssignment.CourseScheduleID
				   INNER JOIN pr2.CourseCatalogue
				   ON	pr2.CourseCatalogue.CourseCode = pr2.CourseSchedule.CourseCode 
				   AND	pr2.CourseCatalogue.CourseNumber = pr2.CourseSchedule.CourseNumber
				   INNER JOIN pr2.SemesterInfo
				   ON	pr2.CourseSchedule.Semester = pr2.SemesterInfo.SemesterID
				   INNER JOIN pr2.SemesterText
				   ON	pr2.SemesterText.SemesterTextID = pr2.SemesterInfo.Semester
				   WHERE pr2.People.IsActive = 'Yes'

--SELECT * FROM pr2.FacultyInfo

------------------------------------------------------------------------------------------------------------------------------------
---5. View Showing total Number of students enrolled in particular course
-------------------------------------------------------------------------------------------------------------------------------------
CREATE VIEW pr2.NumberOfStudents AS
			SELECT  pr2.CourseCatalogue.CourseTitle AS CourseTitle, COUNT(*) AS NumberOfStudents
					FROM	pr2.CourseCatalogue INNER JOIN pr2.CourseSchedule
					ON		pr2.CourseCatalogue.CourseCode = pr2.CourseSchedule.CourseCode 
							AND pr2.CourseCatalogue.CourseNumber = pr2.CourseSchedule.CourseNumber
							INNER JOIN pr2.CourseEnrollment
					ON		pr2.CourseEnrollment.CourseID = pr2.CourseSchedule.CourseScheduleID
					GROUP BY pr2.CourseCatalogue.CourseTitle

--SELECT * FROM pr2.NumberOfStudents

--***********************************************
--Function
--***********************************************
-----------------------------------------------------------------------------------------------------------------------------------------
--1. Function 1
--When student will enter NTID then function will return weekly schedule of student based on courses in which the student is enrolled in
-----------------------------------------------------------------------------------------------------------------------------------------

CREATE FUNCTION pr2.ScheduleForStudent (@NTID VARCHAR(20))
RETURNS @return TABLE(CourseTitle VARCHAR(100) ,Faculty VARCHAR(100), Day VARCHAR(100), StartTime TIME, EndTime TIME , Building VARCHAR(100) , RoomNumber VARCHAR(100))
BEGIN 

	DECLARE @StudentId INT
	
	SELECT @StudentId = (SELECT StudentID from pr2.StudentInfo where PersonID in (select PersonID from pr2.People where NTID = @NTID))
	INSERT INTO @return
	SELECT	pr2.CourseCatalogue.CourseTitle AS CourseTitle , 
		pr2.People.FirstName + ' ' + pr2.People.LastName AS Instructor,
		pr2.DayOfWeek.Text AS Day,
		LEFT(CONVERT(TIME,pr2.CourseDailySchedule.StartTime,100),8) AS StartTime,
		LEFT(CONVERT(TIME,pr2.CourseDailySchedule.EndTime,100),8)   AS EndTime,
		pr2.Buildings.BuildingName AS Building,
		pr2.ClassRoom.RoomNumber AS RoomNumber

		FROM	pr2.TeachingAssignment INNER JOIN pr2.EmployeeInfo
		ON      pr2.TeachingAssignment.EmployeeID = pr2.EmployeeInfo.EmployeeID
		INNER JOIN pr2.People
		ON		pr2.EmployeeInfo.PersonID = pr2.People.PersonID
		INNER JOIN pr2.CourseSchedule
		ON		pr2.TeachingAssignment.CourseScheduleID = pr2.CourseSchedule.CourseScheduleID
		INNER JOIN pr2.CourseEnrollment 
		ON		pr2.CourseSchedule.CourseScheduleID = pr2.CourseEnrollment.CourseID 
		INNER JOIN pr2.CourseDailySchedule
		ON		pr2.CourseDailySchedule.CourseID = pr2.CourseSchedule.CourseScheduleID
		INNER JOIN pr2.DayOfWeek
		ON		pr2.DayOfWeek.Id = pr2.CourseDailySchedule.DayOfWeek
		INNER JOIN pr2.CourseCatalogue
		ON		pr2.CourseCatalogue.CourseCode = pr2.CourseSchedule.CourseCode AND pr2.CourseCatalogue.CourseNumber = pr2.CourseSchedule.CourseNumber
		INNER JOIN pr2.ClassRoom
		ON		pr2.CourseSchedule.Location = pr2.ClassRoom.ClassRoomID
		INNER JOIN pr2.Buildings
		ON		pr2.ClassRoom.Building = pr2.Buildings.Id
		WHERE	pr2.CourseEnrollment.StudentID = @StudentId
		
	RETURN
END;

--SELECT * FROM pr2.ScheduleForStudent ('12-GA')


--*******************
--Procedures (4)
--*******************

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--2. Procedure 1 
--This procedure assigns classroom for particular course. For performing this, following things are taken into consideration:
--1.Class room is already assigned to this course: if yes show error saying The course already has a classroom assigned to it.
--2.Classroom should not be assigned to current course if that class room is assigned to some other course
--While performing this check procedure performs following operations :
--If there is a match of classroom for current input course and some other course then (this matching can return many entries so dummy table is created to check with all entries)
--1. if courses are offered in same semester
--2. If semesters are same then check the day of week from daily course schedule of current and matched course
--3. If both semester and day are matched then time is checked and if timings are clashing then show error else successfully update classroom
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE PROCEDURE pr2.AssignLocationForCourse
(
@CourseCode AS VARCHAR(20), 
@CourseNumber AS INT,
@Location AS VARCHAR(50)
)
AS
	IF EXISTS(SELECT * FROM pr2.CourseSchedule WHERE CourseCode = @CourseCode AND CourseNumber = @CourseNumber AND Location IS NOT NULL)
	BEGIN
		PRINT 'The course already has a classroom assigned to it.'
	END
	ELSE
	BEGIN
		DECLARE @DummyTable TABLE(Id INT IDENTITY(1,1),CourseScheduleId INT)
		DECLARE @error BIT
		SET @error = 0

		SET NOCOUNT ON

		DECLARE @CourseScheduleId INT
		DECLARE @CurrentCourseScheduleId INT
		DECLARE @Day VARCHAR(50)
		DECLARE @CurrentDay VARCHAR(50)
		DECLARE @EndTime TIME
		DECLARE @StartTime TIME
		DECLARE @CurrentStartTime TIME
		
		SELECT @CurrentCourseScheduleId = (SELECT CourseScheduleID FROM pr2.CourseSchedule WHERE CourseCode = @CourseCode AND CourseNumber = @CourseNumber)
		INSERT INTO @DummyTable SELECT CourseScheduleID FROM pr2.CourseSchedule WHERE Location = @Location and Semester in (SELECT Semester FROM pr2.CourseSchedule WHERE CourseScheduleID = @CurrentCourseScheduleId) 
		
		DECLARE FirstCursor CURSOR FOR SELECT CourseScheduleId FROM @DummyTable 
		OPEN FirstCursor 
		FETCH NEXT FROM FirstCursor INTO @CourseScheduleId 
		WHILE @@FETCH_STATUS = 0 AND @error = 0
		BEGIN 
			SELECT @Day = (SELECT DayOfWeek FROM pr2.CourseDailySchedule WHERE CourseID = @CourseScheduleId)
			SELECT @CurrentDay = (SELECT DayOfWeek FROM pr2.CourseDailySchedule WHERE CourseID = @CurrentCourseScheduleId)
			SELECT @StartTime = (SELECT StartTime FROM pr2.CourseDailySchedule WHERE CourseID = @CourseScheduleId)
			SELECT @EndTime = (SELECT EndTime FROM pr2.CourseDailySchedule WHERE CourseID = @CourseScheduleId)
			SELECT @CurrentStartTime = (SELECT StartTime FROM pr2.CourseDailySchedule WHERE CourseID = @CurrentCourseScheduleId)
		
			If ( @Day = @CurrentDay AND (@StartTime <= @CurrentStartTime OR @CurrentStartTime < @EndTime))
			BEGIN
					PRINT 'Classroom is assigned to other class for this class timing.'
					SET @error =1 
			END
			
			FETCH NEXT FROM FirstCursor INTO @CourseScheduleId 
		END 
		CLOSE FirstCursor 
		DEALLOCATE FirstCursor
		IF (@error = 0)
		BEGIN
					UPDATE pr2.CourseSchedule
					SET Location = @Location
					WHERE CourseCode = @CourseCode AND CourseNumber = @CourseNumber
					PRINT 'Class Room is successfully assigned.'
		END	
		
	END;

--Error : Classroom is assigned to other class for this class timing. (Only 1 other entry matching)
--EXEC pr2.AssignLocationForCourse 'CS',772,'05-NCC'
--Error : The course already has a classroom assigned to it.
--EXEC pr2.AssignLocationForCourse 'CS',612,'03-HC'
--Error : Classroom is assigned to other class for this class timing. (More than one matching entries)
--EXEC pr2.AssignLocationForCourse 'MAE',111,'04-CST'
--Success
--EXEC pr2.AssignLocationForCourse 'CE',775,'05-NCC'

----------------------------------------------------------------------------------------------------------------------------------------------------------------
--3.Procedure 2 
--If student wants to enroll for particular course and wants to check if he/she completed all prerequisite courses.
--This procedure is finding prerequisites of particular course and finding if the student is enrolled in any of the prerequisites. 
--The output of this procedure is a table showing prerequisite of particular course and grade of the student if that student is enrolled in prerequisite course.
--If some prerequisite grade is NULL then appropriate message is displayed 
-----------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE pr2.CoursePrerequisites (@NTID VARCHAR(20), @CourseCode VARCHAR(50), @CourseNumber INT)
AS
BEGIN
	
	DECLARE @StudentId INT
	
	SELECT @StudentId = (SELECT StudentID from pr2.StudentInfo where PersonID in (select PersonID from pr2.People where NTID = @NTID))
	
	DECLARE @PreReqTable TABLE(Id INT IDENTITY(1,1),CourseCode VARCHAR(50),CourseNumber INT, CourseTitle VARCHAR(100))

	SET NOCOUNT ON 

	INSERT INTO @PreReqTable 
	SELECT pr2.Prerequisites.ChildCode, pr2.Prerequisites.ChildNumber, pr2.CourseCatalogue.CourseTitle
	FROM pr2.Prerequisites INNER JOIN pr2.CourseCatalogue 
	ON pr2.Prerequisites.ChildCode = pr2.CourseCatalogue.CourseCode AND pr2.Prerequisites.ChildNumber = pr2.CourseCatalogue.CourseNumber
	WHERE pr2.Prerequisites.ParentCode = @CourseCode AND pr2.Prerequisites.ParentNumber = @CourseNumber

	DECLARE @CurrentCourseCode VARCHAR(50)
	DECLARE @CurrentCourseNumber INT
	DECLARE @CurrentCourseTitle VARCHAR(100)
	DECLARE @DummyTable TABLE(CourseTitle VARCHAR(100),Grade VARCHAR(5))

	DECLARE FirstCursor CURSOR FOR SELECT CourseCode,CourseNumber,CourseTitle FROM @PreReqTable
	OPEN FirstCursor 
	FETCH NEXT FROM FirstCursor INTO @CurrentCourseCode,@CurrentCourseNumber,@CurrentCourseTitle 
	WHILE @@FETCH_STATUS = 0 
	BEGIN 
			DECLARE @CourseId INT
			DECLARE @CurrentGrade VARCHAR(1)

			SELECT @CourseId = (SELECT CourseScheduleID FROM pr2.CourseSchedule WHERE CourseCode = @CurrentCourseCode AND CourseNumber = @CurrentCourseNumber)
			
			SELECT @CurrentGrade = (SELECT Grades.Grade FROM pr2.CourseEnrollment INNER JOIN pr2.Grades
									ON pr2.CourseEnrollment.GradeID = pr2.Grades.GradeID WHERE CourseID = @CourseId AND StudentID = @StudentId)
			INSERT INTO @DummyTable (CourseTitle,Grade) VALUES (@CurrentCourseTitle, @CurrentGrade)
			
			FETCH NEXT FROM FirstCursor INTO @CurrentCourseCode,@CurrentCourseNumber,@CurrentCourseTitle 
	END 
	CLOSE FirstCursor 
	DEALLOCATE FirstCursor
	IF(EXISTS(SELECT * FROM @DummyTable WHERE Grade IS NULL))
	BEGIN 
			SELECT * FROM @DummyTable
			PRINT 'You are not eligible for this course before completion of all prerequisites.'
	END

	ELSE
	BEGIN
			SELECT * FROM @DummyTable
			PRINT 'You are eligible for taking this course.'
	END
END

--Error : You are not eligible for this course before completion of all prerequisites.
--EXEC pr2.CoursePrerequisites '10-WA','CE',787
--Success : You are eligible for taking this course.
--EXEC pr2.CoursePrerequisites '07-GA','EE',632

---------------------------------------------------------------------------------------------------------------------------
--4.Procedure 3 
--If faculty needs to check performance of the class taught by him/her then this procedure solves the problem.
--Procedure returns student records in table format showing Student Names, Grades and Grading Status 
--If that faculty is not teaching that course then error message will be displayed
----------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE pr2.StudentsReport (@CourseCode VARCHAR(10),@CourseNumber INT ,@FacultyID INT)
AS
IF (NOT EXISTS (SELECT * FROM pr2.TeachingAssignment INNER JOIN pr2.EmployeeInfo 
				ON pr2.TeachingAssignment.EmployeeID = pr2.EmployeeInfo.EmployeeID
				INNER JOIN pr2.CourseSchedule
				ON pr2.CourseSchedule.CourseScheduleID = pr2.TeachingAssignment.CourseScheduleID
				WHERE pr2.EmployeeInfo.PersonID = @FacultyID AND pr2.CourseSchedule.CourseCode = @CourseCode AND pr2.CourseSchedule.CourseNumber = @CourseNumber))
BEGIN
		PRINT 'Faculty is not teaching this course.'
END
ELSE
BEGIN
	DECLARE @table TABLE (StudentName VARCHAR(100), CourseTitle VARCHAR (50) ,  Status VARCHAR(10) , Grade VARCHAR(1))
	INSERT INTO @table
		SELECT  pr2.People.FirstName + ' ' + pr2.People.LastName AS StudentName,
		pr2.CourseCatalogue.CourseTitle AS CourseTitle,
		pr2.StudentGradingStatus.StudentGradingStatus AS Status,
		pr2.Grades.Grade AS Grade

		FROM	pr2.CourseEnrollment INNER JOIN pr2.StudentInfo
		ON		pr2.StudentInfo.StudentID = pr2.CourseEnrollment.StudentID		
		INNER JOIN pr2.People
		ON		pr2.People.PersonID = pr2.StudentInfo.PersonID
		FULL OUTER JOIN pr2.Grades
		ON		pr2.CourseEnrollment.GradeID = pr2.Grades.GradeID 
		INNER JOIN pr2.StudentGradingStatus
		ON		pr2.CourseEnrollment.StatusID = pr2.StudentGradingStatus.StudentGradingStatusId 
		INNER JOIN pr2.CourseSchedule
		ON		pr2.CourseEnrollment.CourseID = pr2.CourseSchedule.CourseScheduleID 
		INNER JOIN pr2.CourseCatalogue
		ON		pr2.CourseCatalogue.CourseCode = pr2.CourseSchedule.CourseCode AND pr2.CourseCatalogue.CourseNumber = pr2.CourseSchedule.CourseNumber

		WHERE pr2.CourseSchedule.CourseCode = @CourseCode AND pr2.CourseSchedule.CourseNumber = @CourseNumber

	SELECT * FROM @table
END

--Error message
--EXEC pr2.StudentsReport @CourseCode = 'CS', @CourseNumber = 612 , @FacultyID =  9
--Success 
--EXEC pr2.StudentsReport @CourseCode = 'CS', @CourseNumber = 612 , @FacultyID =  7



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--5.Procedure 4
--The procedure pr2.EnrollStudent is used to enroll a student into a course 
--It first checks if the course is available by checking the Course Schedule table
--The second check is for if the student's records exist in the database
--The third check is for if the student is already enrolled for the same course
--The fourth check is for the student's status, if he's eligible to enroll
--After all the checks are passed, the student is enrolled by inserting the details in the pr2.EnrolledStudents table
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE pr2.EnrollStudent(@courseCode AS VARCHAR(20), @courseNumber AS INT, @semester AS INT, @studentId AS INT)
AS
BEGIN 
DECLARE @semesterName AS VARCHAR(50)
DECLARE @studentStatus AS INT
 IF NOT EXISTS(SELECT * FROM pr2.CourseSchedule WHERE CourseCode = @courseCode AND CourseNumber = @courseNumber AND Semester = @semester)
	BEGIN
	 SET @semesterName=(SELECT Semester FROM pr2.SemesterInfo WHERE SemesterId=@semester)
	 PRINT 'Error: This course is not available for the'+' '+@semesterName+' '+'semester'
	 RETURN
	END
ELSE IF NOT EXISTS(SELECT * FROM pr2.StudentInfo WHERE StudentId=@studentId)
	BEGIN
	  PRINT 'Error: The student details are incorrect'
	  RETURN
	END
ELSE IF EXISTS(SELECT * FROM pr2.CourseEnrollment WHERE StudentId=@studentId AND CourseId IN (SELECT CourseScheduleId FROM pr2.CourseSchedule WHERE CourseCode = @courseCode AND CourseNumber = @courseNumber AND Semester = @semester))
	BEGIN
	  PRINT 'Error: Student is already enrolled for this course'
	  RETURN
	END
ELSE 
	BEGIN
	  SET @studentStatus=(SELECT StudentStatus FROM pr2.StudentStatus WHERE StudentStatusID=@studentId)
	  IF @studentStatus = 5 OR @studentStatus = 6
		BEGIN
		PRINT 'Error: Student is ineligible to be enrolled for this course'
		END
	  ELSE 
		 BEGIN
			DECLARE @CourseId AS INT
			SET @CourseId=(SELECT CourseScheduleId FROM pr2.CourseSchedule WHERE CourseCode = @courseCode AND CourseNumber = @courseNumber AND Semester = @semester)
			INSERT INTO pr2.CourseEnrollment(CourseId,StudentId,StatusID,GradeID) 
			VALUES(@CourseId, @studentId, 2, NULL);
			PRINT 'Student has successfully been enrolled in the requested course'
		 END
	  RETURN
	END
END;

--Error Message 1
--EXEC pr2.EnrollStudent 'MA', 654, 1, 3;
--Error Message 2
--EXEC pr2.EnrollStudent 'MA', 654, 3, 11;
--Error Message 3
--EXEC pr2.EnrollStudent 'MA', 654, 3, 2;
--Error Message 4
--EXEC pr2.EnrollStudent 'MA', 654, 3, 1;
--Success Message(already executed so it will be error message 3 now)
--EXEC pr2.EnrollStudent 'MA', 654, 3, 3;






