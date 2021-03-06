MySql

CREATE DATABASE Parking;


CREATE TABLE Parking.BeforeCellphones(
	beforeCellphone nvarchar(10) NOT NULL,
	PRIMARY KEY (beforeCellphone)
);

CREATE TABLE Parking.BeforeTelephones(
	beforeTelephone nvarchar(10) NOT NULL,
	PRIMARY KEY (beforeTelephone)
);

CREATE TABLE Parking.PERSONS(
	personId nvarchar(9) NOT NULL,
	personFirstName nvarchar(20) NOT NULL,
	personLastName nvarchar(20) NOT NULL,
	personBeforeTelephone nvarchar(10) NULL,
	personTelephone nvarchar(30) NULL,
	personBeforeCellphone nvarchar(10) NULL,
	personCellphone nvarchar(30) NULL,
	personCode int NOT NULL,
	PRIMARY KEY (personId)
);

CREATE TABLE Parking.APPROVALTYPES(
	approvalCode nvarchar(10) NOT NULL,
	approvalName nvarchar(20) NOT NULL,
	PRIMARY KEY (approvalCode)
);

CREATE TABLE Parking.APPROVALS(
	approvalCode nvarchar(10) NOT NULL,
	approvalFrom datetime NOT NULL,
	approvalUntil datetime NOT NULL,
	approvalPersonId nvarchar(9) NOT NULL,
	approvalNumber int NOT NULL,
    PRIMARY KEY (approvalNumber),
    FOREIGN KEY (approvalCode) REFERENCES APPROVALTYPES (approvalCode),
    FOREIGN KEY (approvalPersonId) REFERENCES PERSONS (personId)
);

CREATE TABLE Parking.COURSES(
	courseCode nvarchar(50) NOT NULL,
	courseName nvarchar(50) NOT NULL,
    PRIMARY KEY (courseCode)
);

CREATE TABLE Parking.FACULTYS(
	facultyCode nvarchar(50) NOT NULL,
	facultyName nvarchar(50) NOT NULL,
	facultyHead nvarchar(50) NOT NULL,
    PRIMARY KEY (facultyCode)
);

CREATE TABLE Parking.STUDENTS(
	studentId nvarchar(9) NOT NULL,
	studentFacultyCode nvarchar(50) NOT NULL,
	studentYear int NOT NULL,
	studentType int NOT NULL,
    PRIMARY KEY (studentId),
    FOREIGN KEY (studentId) REFERENCES PERSONS (personId),
    FOREIGN KEY (studentFacultyCode) REFERENCES FACULTYS (facultyCode)
);

CREATE TABLE Parking.TEACHERS(
	teacherId nvarchar(9) NOT NULL,
	teacherFacultyCode nvarchar(50) NOT NULL,
	teacherStage int NOT NULL,
    PRIMARY KEY (teacherId),
    FOREIGN KEY (teacherId) REFERENCES PERSONS (personId),
    FOREIGN KEY (teacherFacultyCode) REFERENCES FACULTYS (facultyCode)
);

CREATE TABLE Parking.VEHICLES(
	vehicleNumber nvarchar(50) NOT NULL,
	vehicleManufacturer nvarchar(50) NOT NULL,
	vehicleColor nvarchar(50) NOT NULL,
	vehicleOwnerId nvarchar(9) NOT NULL,
    PRIMARY KEY (vehicleNumber),
    FOREIGN KEY (vehicleOwnerId) REFERENCES PERSONS (personId)
);



DELIMITER $$
CREATE PROCEDURE Parking.AddApproval(IN approvalCode varchar(10), IN approvalFrom datetime, IN approvalUntil datetime, IN approvalPersonId varchar(9))
BEGIN
	INSERT INTO Approvals (approvalCode, approvalFrom, approvalUntil, approvalPersonId) VALUES (approvalCode, approvalFrom, approvalUntil, approvalPersonId); SELECT * FROM Approvals WHERE approvalNumber = SCOPE_IDENTITY();
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.AddApprovalType(IN approvalCode varchar(10), IN approvalName varchar(20))
BEGIN
	INSERT INTO ApprovalTypes (approvalCode, approvalName) VALUES (approvalCode, approvalName);
	SELECT * from ApprovalTypes;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.AddCellphone(IN beforeCellphone varchar(10))
BEGIN
	INSERT INTO BeforeCellphones (beforeCellphone) VALUES (beforeCellphone);
	SELECT beforeCellphone from BeforeCellphones where BeforeCellphones.beforeCellphone=beforeCellphone;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.AddCourse(IN courseCode varchar(50), IN courseName varchar(50))
BEGIN
	INSERT INTO Courses (courseCode, courseName) VALUES (courseCode, courseName);
	SELECT * from Courses where Courses.courseCode=courseCode;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.AddFaculty(IN facultyCode varchar(50), IN facultyName varchar(50), IN facultyHead varchar(50))
BEGIN
	INSERT INTO Facultys (facultyCode, facultyName, facultyHead) VALUES (facultyCode, facultyName, facultyHead);
	SELECT * from Facultys where Facultys.facultyCode=facultyCode;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.AddStudent(IN personId varchar(9), IN personFirstName varchar(20), IN personLastName varchar(20), IN personBeforeTelephone varchar(10), IN personTelephone varchar(30), IN personBeforeCellphone varchar(10), IN personCellphone varchar(30), IN personCode int, IN studentId varchar(9), IN studentFacultyCode varchar(50), IN studentYear int, IN studentType int)
BEGIN
	DECLARE exit handler for sqlexception
	  BEGIN
		GET DIAGNOSTICS CONDITION 1
		@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
		SELECT @p1 as RETURNED_SQLSTATE  , @p2 as MESSAGE_TEXT;
		ROLLBACK;
	END;
 
	DECLARE exit handler for sqlwarning
	  BEGIN
		GET DIAGNOSTICS CONDITION 1
		@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
		SELECT @p1 as RETURNED_SQLSTATE  , @p2 as MESSAGE_TEXT;
		ROLLBACK;
	END;
	
	START TRANSACTION;
		INSERT INTO Persons (personId, personFirstName, personLastName, personBeforeTelephone, personTelephone, personBeforeCellphone, personCellphone, personCode) VALUES (personId, personFirstName, personLastName, personBeforeTelephone, personTelephone, personBeforeCellphone, personCellphone, personCode);
		INSERT INTO Students (studentId, studentType, studentYear, studentFacultyCode) VALUES (studentId, studentType, studentYear, studentFacultyCode);
		SELECT Persons.personId, Persons.personFirstName, Persons.personLastName, Persons.personBeforeTelephone, Persons.personTelephone, Persons.personBeforeCellphone, Persons.personCellphone, Persons.personCode, Students.studentId, Students.studentFacultyCode, Students.studentYear, Students.studentType From Persons INNER JOIN Students ON Persons.personId=Students.studentId where Students.studentId=studentId;
	COMMIT;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.AddTeacher(IN personId varchar(9), IN personFirstName varchar(20), IN personLastName varchar(20), IN personBeforeTelephone varchar(10), IN personTelephone varchar(30), IN personBeforeCellphone varchar(10), IN personCellphone varchar(30), IN personCode int, IN teacherId varchar(9), IN teacherFacultyCode varchar(50), IN teacherStage int)
BEGIN
	DECLARE exit handler for sqlexception
	  BEGIN
		GET DIAGNOSTICS CONDITION 1
		@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
		SELECT @p1 as RETURNED_SQLSTATE  , @p2 as MESSAGE_TEXT;
		ROLLBACK;
	END;
 
	DECLARE exit handler for sqlwarning
	  BEGIN
		GET DIAGNOSTICS CONDITION 1
		@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
		SELECT @p1 as RETURNED_SQLSTATE  , @p2 as MESSAGE_TEXT;
		ROLLBACK;
	END;
	
	START TRANSACTION;
		INSERT INTO Persons (personId, personFirstName, personLastName, personBeforeTelephone, personTelephone, personBeforeCellphone, personCellphone, personCode) VALUES (personId, personFirstName, personLastName, personBeforeTelephone, personTelephone, personBeforeCellphone, personCellphone, personCode);
		INSERT INTO Teachers (teacherId, teacherFacultyCode, teacherStage) VALUES (teacherId, teacherFacultyCode, teacherStage);
		SELECT Persons.personId, Persons.personFirstName, Persons.personLastName, Persons.personBeforeTelephone, Persons.personTelephone, Persons.personBeforeCellphone, Persons.personCellphone, Persons.personCode, Teachers.teacherId, Teachers.teacherFacultyCode, Teachers.teacherStage From Persons INNER JOIN Teachers ON Persons.personId=Teachers.teacherId where Teachers.teacherId=teacherId;
	COMMIT;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.AddTelephone(IN beforeTelephone varchar(10))
BEGIN
	INSERT INTO BeforeTelephones (beforeTelephone) VALUES (beforeTelephone);
	SELECT beforeTelephone from BeforeTelephones where BeforeTelephones.beforeTelephone=beforeTelephone;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.AddVehicle(IN vehicleNumber varchar(50), IN vehicleManufacturer varchar(50), IN vehicleColor varchar(50), IN vehicleOwnerId varchar(9))
BEGIN
	INSERT INTO Vehicles (vehicleNumber, vehicleManufacturer, vehicleColor, vehicleOwnerId) VALUES (vehicleNumber, vehicleManufacturer, vehicleColor, vehicleOwnerId);
	SELECT Vehicles.vehicleNumber, Vehicles.vehicleManufacturer, Vehicles.vehicleColor, Vehicles.vehicleOwnerId, Persons.personFirstName, Persons.personLastName From Vehicles INNER JOIN Persons ON Vehicles.vehicleOwnerId=Persons.personId and Vehicles.vehicleNumber=vehicleNumber;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.checkIfIdExists(IN personId varchar(9))
BEGIN
	SELECT COUNT(1) FROM Persons WHERE Persons.personId = personId;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.DeleteApprovalByNumber(IN approvalNumber int)
BEGIN
	DELETE FROM Approvals WHERE Approvals.approvalNumber=approvalNumber;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.DeleteApprovalByPerson(IN approvalPersonId varchar(9))
BEGIN
	DELETE FROM Approvals WHERE Approvals.approvalPersonId=approvalPersonId;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.DeleteApprovalType(IN approvalCode varchar(10))
BEGIN
	DELETE FROM ApprovalTypes WHERE ApprovalTypes.approvalCode=approvalCode;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.DeleteCellphone(IN beforeCellphone varchar(10))
BEGIN
	DELETE FROM BeforeCellphones WHERE BeforeCellphones.beforeCellphone=beforeCellphone;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.DeleteCourse(IN courseCode varchar(50))
BEGIN
	DELETE FROM Courses WHERE Courses.courseCode=courseCode;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.DeleteFaculty(IN facultyCode varchar(50))
BEGIN
	DELETE FROM Facultys WHERE Facultys.facultyCode=facultyCode;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.DeletePerson(IN personId varchar(9))
BEGIN
	DELETE FROM Persons WHERE Persons.personId=personId;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.DeleteStudent(IN studentId varchar(9))
BEGIN
	DECLARE exit handler for sqlexception
	  BEGIN
		GET DIAGNOSTICS CONDITION 1
		@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
		SELECT @p1 as RETURNED_SQLSTATE  , @p2 as MESSAGE_TEXT;
		ROLLBACK;
	END;
 
	DECLARE exit handler for sqlwarning
	  BEGIN
		GET DIAGNOSTICS CONDITION 1
		@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
		SELECT @p1 as RETURNED_SQLSTATE  , @p2 as MESSAGE_TEXT;
		ROLLBACK;
	END;
	
	START TRANSACTION;
		DELETE FROM Students WHERE Students.studentId=studentId;
		DELETE FROM Persons WHERE Persons.personId=studentId;
	COMMIT;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.DeleteTeacher(IN teacherId varchar(9))
BEGIN
	DECLARE exit handler for sqlexception
	  BEGIN
		GET DIAGNOSTICS CONDITION 1
		@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
		SELECT @p1 as RETURNED_SQLSTATE  , @p2 as MESSAGE_TEXT;
		ROLLBACK;
	END;
 
	DECLARE exit handler for sqlwarning
	  BEGIN
		GET DIAGNOSTICS CONDITION 1
		@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
		SELECT @p1 as RETURNED_SQLSTATE  , @p2 as MESSAGE_TEXT;
		ROLLBACK;
	END;
	
	START TRANSACTION;
		DELETE FROM Teachers WHERE Teachers.teacherId=teacherId;
		DELETE FROM Persons WHERE Persons.personId=teacherId;
	COMMIT;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.DeleteTelephone(IN beforeTelephone varchar(10))
BEGIN
	DELETE FROM BeforeTelephones WHERE BeforeTelephones.beforeTelephone=beforeTelephone;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.DeleteVehicleByNumber(IN vehicleNumber varchar(50))
BEGIN
	DELETE FROM Vehicles WHERE Vehicles.vehicleNumber=vehicleNumber;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.DeleteVehicleByOwnerId(IN vehicleOwnerId varchar(9))
BEGIN
	DELETE FROM Vehicles WHERE Vehicles.vehicleOwnerId=vehicleOwnerId;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.GetAllApprovals()
BEGIN
	SELECT * from Approvals;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.GetAllApprovalTypes()
BEGIN
	SELECT * from ApprovalTypes;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.GetAllCellphones()
BEGIN
	SELECT beforeCellphone from BeforeCellphones;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.GetAllCourses()
BEGIN
	SELECT * from Courses;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.GetAllFaculties()
BEGIN
	SELECT * from Facultys;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.GetAllPersons()
BEGIN
	SELECT * from Persons;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.GetAllPersonsId()
BEGIN
	SELECT personId from Persons;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.GetAllStudents()
BEGIN
	SELECT Persons.personId, Persons.personFirstName, Persons.personLastName, Persons.personBeforeTelephone, Persons.personTelephone, Persons.personBeforeCellphone, Persons.personCellphone, Persons.personCode, Students.studentId, Students.studentFacultyCode, Students.studentYear, Students.studentType From Persons INNER JOIN Students ON Persons.personId=Students.studentId;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.GetAllTeachers()
BEGIN
	SELECT Persons.personId, Persons.personFirstName, Persons.personLastName, Persons.personBeforeTelephone, Persons.personTelephone, Persons.personBeforeCellphone, Persons.personCellphone, Persons.personCode, Teachers.teacherId, Teachers.teacherFacultyCode, Teachers.teacherStage From Persons INNER JOIN Teachers ON Persons.personId=Teachers.teacherId;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.GetAllTelephones()
BEGIN
	SELECT beforeTelephone from BeforeTelephones;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.GetAllVehicleNumbers()
BEGIN
	SELECT vehicleNumber from Vehicles;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.GetAllVehicles()
BEGIN
	SELECT Vehicles.vehicleNumber, Vehicles.vehicleManufacturer, Vehicles.vehicleColor, Vehicles.vehicleOwnerId, Persons.personFirstName, Persons.personLastName From Vehicles INNER JOIN Persons ON Vehicles.vehicleOwnerId=Persons.personId;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.GetOneApprovalByCode(IN approvalCode varchar(10))
BEGIN
	SELECT * from Approvals where Approvals.approvalCode=approvalCode;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.GetOneApprovalByNumber(IN approvalNumber int)
BEGIN
	SELECT * from Approvals where approvalNumber=approvalNumber;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.GetOneApprovalByPersonId(IN approvalPersonId varchar(9))
BEGIN
	SELECT * from Approvals where Approvals.approvalPersonId=@approvalPersonId;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.GetOneApprovalTypeByCode(IN approvalCode varchar(10))
BEGIN
	SELECT * from ApprovalTypes where ApprovalTypes.approvalCode=approvalCode;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.GetOneApprovalTypeByName(IN approvalName varchar(20))
BEGIN
	SELECT approvalCode, approvalName from ApprovalTypes where ApprovalTypes.approvalName=approvalName;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.GetOneBeforeCellphone(IN beforeCellphone varchar(10))
BEGIN
	SELECT beforeCellphone from BeforeCellphones where BeforeCellphones.beforeCellphone=beforeCellphone;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.GetOneBeforeTelephone(IN beforeTelephone varchar(10))
BEGIN
	SELECT beforeTelephone from BeforeTelephones where BeforeTelephones.beforeTelephone=beforeTelephone;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.GetOneCourseByCode(IN courseCode varchar(50))
BEGIN
	SELECT * from Courses where Courses.courseCode=courseCode;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.GetOneCourseByName(IN courseName varchar(50))
BEGIN
	SELECT * from Courses where Courses.courseName=courseName;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.GetOneFacultyByCode(IN facultyCode varchar(50))
BEGIN
	SELECT * from Facultys where Facultys.facultyCode=facultyCode;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.GetOneFacultyByHead(IN facultyHead varchar(50))
BEGIN
	SELECT * from Facultys where Facultys.facultyHead=facultyHead;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.GetOneFacultyByName(IN facultyName varchar(50))
BEGIN
	SELECT * from Facultys where Facultys.facultyName=facultyName;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.GetOnePersonById(IN personId varchar(9))
BEGIN
	SELECT * from Persons where Persons.personId=personId;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.GetOneStudentById(IN studentId varchar(9))
BEGIN
	SELECT Persons.personId, Persons.personFirstName, Persons.personLastName, Persons.personBeforeTelephone, Persons.personTelephone, Persons.personBeforeCellphone, Persons.personCellphone, Persons.personCode, Students.studentId, Students.studentFacultyCode, Students.studentYear, Students.studentType From Persons INNER JOIN Students ON Persons.personId=Students.studentId where Students.studentId=studentId;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.GetOneTeacherById(IN teacherId varchar(9))
BEGIN
	SELECT Persons.personId, Persons.personFirstName, Persons.personLastName, Persons.personBeforeTelephone, Persons.personTelephone, Persons.personBeforeCellphone, Persons.personCellphone, Persons.personCode, Teachers.teacherId, Teachers.teacherFacultyCode, Teachers.teacherStage From Persons INNER JOIN Teachers ON Persons.personId=Teachers.teacherId where Teachers.teacherId=teacherId;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.GetOneVehicleByNumber(IN vehicleNumber varchar(50))
BEGIN
	SELECT Vehicles.vehicleNumber, Vehicles.vehicleManufacturer, Vehicles.vehicleColor, Vehicles.vehicleOwnerId, Persons.personFirstName, Persons.personLastName From Vehicles INNER JOIN Persons ON Vehicles.vehicleOwnerId=Persons.personId and Vehicles.vehicleNumber=vehicleNumber;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.GetOneVehicleByOwnerId(IN vehicleOwnerId varchar(9))
BEGIN
	SELECT Vehicles.vehicleNumber, Vehicles.vehicleManufacturer, Vehicles.vehicleColor, Vehicles.vehicleOwnerId, Persons.personFirstName, Persons.personLastName From Vehicles INNER JOIN Persons ON Vehicles.vehicleOwnerId=Persons.personId and Vehicles.vehicleOwnerId=vehicleOwnerId;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.UpdateApproval(IN approvalCode varchar(10), IN approvalFrom datetime, IN approvalUntil datetime, IN approvalPersonId varchar(9), IN approvalNumber int)
BEGIN
	UPDATE Approvals SET Approvals.approvalCode = approvalCode, Approvals.approvalFrom = @approvalFrom, Approvals.approvalUntil = approvalUntil, Approvals.approvalPersonId = approvalPersonId, Approvals.approvalNumber = approvalNumber where Approvals.approvalPersonId = approvalPersonId;
	SELECT * from Approvals where Approvals.approvalNumber=approvalNumber;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.UpdateApprovalType(IN approvalCode varchar(10), IN approvalName varchar(20))
BEGIN
	UPDATE ApprovalTypes SET ApprovalTypes.approvalCode = approvalCode, ApprovalTypes.approvalName = approvalName where ApprovalTypes.approvalCode=approvalCode;
	SELECT * from ApprovalTypes;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.UpdateCellphone(IN beforeCellphone varchar(10))
BEGIN
	UPDATE BeforeCellphones SET BeforeCellphones.beforeCellphone = beforeCellphone where BeforeCellphones.beforeCellphone=beforeCellphone;
	SELECT beforeCellphone from BeforeCellphones where BeforeCellphones.beforeCellphone=beforeCellphone;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.UpdateCourse(IN courseCode varchar(50), IN courseName varchar(50))
BEGIN
	UPDATE Courses SET Courses.courseCode = courseCode, Courses.courseName = courseName where Courses.courseCode=courseCode;
	SELECT * from Courses where Courses.courseCode=courseCode;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.UpdateFaculty(IN facultyCode varchar(50), IN facultyName varchar(50), IN facultyHead varchar(50))
BEGIN
	UPDATE Facultys SET Facultys.facultyCode = facultyCode, Facultys.facultyName = facultyName, Facultys.facultyHead = facultyHead where Facultys.facultyCode=facultyCode;
	SELECT * from Facultys where Facultys.facultyCode=facultyCode;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.UpdateStudent(IN personId varchar(9), IN personFirstName varchar(20), IN personLastName varchar(20), IN personBeforeTelephone varchar(10), IN personTelephone varchar(30), IN personBeforeCellphone varchar(10), IN personCellphone varchar(30), IN personCode int, IN studentId varchar(9), IN studentFacultyCode varchar(50), IN studentYear int, IN studentType int)
BEGIN
	DECLARE exit handler for sqlexception
	  BEGIN
		GET DIAGNOSTICS CONDITION 1
		@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
		SELECT @p1 as RETURNED_SQLSTATE  , @p2 as MESSAGE_TEXT;
		ROLLBACK;
	END;
 
	DECLARE exit handler for sqlwarning
	  BEGIN
		GET DIAGNOSTICS CONDITION 1
		@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
		SELECT @p1 as RETURNED_SQLSTATE  , @p2 as MESSAGE_TEXT;
		ROLLBACK;
	END;
	
	START TRANSACTION;
		UPDATE Persons SET Persons.personId = personId, Persons.personFirstName = personFirstName, Persons.personLastName = personLastName, Persons.personBeforeTelephone = personBeforeTelephone, Persons.personTelephone = personTelephone, Persons.personBeforeCellphone = personBeforeCellphone, Persons.personCellphone = personCellphone, Persons.personCode = personCode WHERE Persons.personId = personId;
		UPDATE Students SET Students.studentId = studentId, Students.studentType = studentType, Students.studentYear = studentYear, Students.studentFacultyCode = studentFacultyCode WHERE Students.studentId = studentId;
		SELECT Persons.personId, Persons.personFirstName, Persons.personLastName, Persons.personBeforeTelephone, Persons.personTelephone, Persons.personBeforeCellphone, Persons.personCellphone, Persons.personCode, Students.studentId, Students.studentFacultyCode, Students.studentYear, Students.studentType From Persons INNER JOIN Students ON Persons.personId=Students.studentId where Students.studentId=studentId;
	COMMIT;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.UpdateTeacher(IN personId varchar(9), IN personFirstName varchar(20), IN personLastName varchar(20), IN personBeforeTelephone varchar(10), IN personTelephone varchar(30), IN personBeforeCellphone varchar(10), IN personCellphone varchar(30), IN personCode int, IN teacherId varchar(9), IN teacherFacultyCode varchar(50), IN teacherStage int)
BEGIN
	DECLARE exit handler for sqlexception
	  BEGIN
		GET DIAGNOSTICS CONDITION 1
		@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
		SELECT @p1 as RETURNED_SQLSTATE  , @p2 as MESSAGE_TEXT;
		ROLLBACK;
	END;
 
	DECLARE exit handler for sqlwarning
	  BEGIN
		GET DIAGNOSTICS CONDITION 1
		@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
		SELECT @p1 as RETURNED_SQLSTATE  , @p2 as MESSAGE_TEXT;
		ROLLBACK;
	END;
	
	START TRANSACTION;
		UPDATE Persons SET Persons.personId = personId, Persons.personFirstName = personFirstName, Persons.personLastName = personLastName, Persons.personBeforeTelephone = personBeforeTelephone, Persons.personTelephone = personTelephone, Persons.personBeforeCellphone = personBeforeCellphone, Persons.personCellphone = personCellphone, Persons.personCode = personCode WHERE Persons.personId = personId;
		UPDATE Teachers SET Teachers.teacherId = teacherId, Teachers.teacherFacultyCode = teacherFacultyCode, Teachers.teacherStage = teacherStage WHERE Teachers.teacherId = teacherId;
		SELECT Persons.personId, Persons.personFirstName, Persons.personLastName, Persons.personBeforeTelephone, Persons.personTelephone, Persons.personBeforeCellphone, Persons.personCellphone, Persons.personCode, Teachers.teacherId, Teachers.teacherFacultyCode, Teachers.teacherStage From Persons INNER JOIN Teachers ON Persons.personId=Teachers.teacherId where Teachers.teacherId=teacherId;
	COMMIT;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.UpdateTelephone(IN beforeTelephone varchar(10))
BEGIN
	UPDATE BeforeTelephones SET BeforeTelephones.beforeTelephone = beforeTelephone where BeforeTelephones.beforeTelephone=beforeTelephone;
	SELECT beforeTelephone from BeforeTelephones where BeforeTelephones.beforeTelephone=beforeTelephone;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Parking.UpdateVehicle(IN vehicleNumber varchar(50), IN vehicleManufacturer varchar(50), IN vehicleColor varchar(50), IN vehicleOwnerId varchar(9))
BEGIN
	UPDATE Vehicles SET Vehicles.vehicleNumber = vehicleNumber, Vehicles.vehicleManufacturer = vehicleManufacturer, Vehicles.vehicleColor = vehicleColor, Vehicles.vehicleOwnerId = vehicleOwnerId where Vehicles.vehicleNumber=vehicleNumber or Vehicles.vehicleOwnerId = vehicleOwnerId;
	SELECT Vehicles.vehicleNumber, Vehicles.vehicleManufacturer, Vehicles.vehicleColor, Vehicles.vehicleOwnerId, Persons.personFirstName, Persons.personLastName From Vehicles INNER JOIN Persons ON Vehicles.vehicleOwnerId=Persons.personId and Vehicles.vehicleNumber=vehicleNumber;
END$$
DELIMITER ;






//-------------------------------------------------------------------------------------------------------------------------//
Sql

CREATE DATABASE Parking

CREATE TABLE BeforeCellphones(
	beforeCellphone nvarchar(10) primary key
);

CREATE TABLE BeforeTelephones(
	beforeTelephone nvarchar(10) primary key
);

CREATE TABLE PERSONS(
	personId nvarchar(9) primary key,
	personFirstName nvarchar(20) NOT NULL,
	personLastName nvarchar(20) NOT NULL,
	personBeforeTelephone nvarchar(10) NULL,
	personTelephone nvarchar(30) NULL,
	personBeforeCellphone nvarchar(10) NULL,
	personCellphone nvarchar(30) NULL,
	personCode int NOT NULL
);

CREATE TABLE APPROVALTYPES(
	approvalCode nvarchar(10) primary key,
	approvalName nvarchar(20) NOT NULL
);

CREATE TABLE APPROVALS(
	approvalCode nvarchar(10) NOT NULL FOREIGN KEY REFERENCES APPROVALTYPES(approvalCode),
	approvalFrom datetime NOT NULL,
	approvalUntil datetime NOT NULL,
	approvalPersonId nvarchar(9) NOT NULL FOREIGN KEY REFERENCES PERSONS(personId),
	approvalNumber int primary key
);

CREATE TABLE COURSES(
	courseCode nvarchar(50) primary key,
	courseName nvarchar(50) NOT NULL
);

CREATE TABLE FACULTYS(
	facultyCode nvarchar(50) primary key,
	facultyName nvarchar(50) NOT NULL,
	facultyHead nvarchar(50) NOT NULL
);

CREATE TABLE STUDENTS(
	studentId nvarchar(9) NOT NULL,
	studentFacultyCode nvarchar(50) NOT NULL FOREIGN KEY REFERENCES FACULTYS(facultyCode),
	studentYear int NOT NULL,
	studentType int NOT NULL,
	CONSTRAINT PK_Students PRIMARY KEY (studentId),
	CONSTRAINT PK_Students2 FOREIGN KEY (studentId) REFERENCES PERSONS(personId)
);

CREATE TABLE TEACHERS(
	teacherId nvarchar(9) NOT NULL,
	teacherFacultyCode nvarchar(50) NOT NULL FOREIGN KEY REFERENCES FACULTYS(facultyCode),
	teacherStage int NOT NULL,
	CONSTRAINT PK_Teachers PRIMARY KEY (teacherId),
	CONSTRAINT PK_Teachers2 FOREIGN KEY (teacherId) REFERENCES PERSONS(personId)
);

CREATE TABLE VEHICLES(
	vehicleNumber nvarchar(50) primary key,
	vehicleManufacturer nvarchar(50) NOT NULL,
	vehicleColor nvarchar(50) NOT NULL,
	vehicleOwnerId nvarchar(9) NOT NULL FOREIGN KEY REFERENCES PERSONS(personId)
);
	
	
CREATE PROCEDURE [dbo].[AddApproval] @approvalCode nvarchar(10), @approvalFrom datetime, @approvalUntil datetime, @approvalPersonId nvarchar(9)
AS
INSERT INTO Approvals (approvalCode, approvalFrom, approvalUntil, approvalPersonId) VALUES (@approvalCode, @approvalFrom, @approvalUntil, @approvalPersonId); SELECT * FROM Approvals WHERE approvalNumber = SCOPE_IDENTITY();


CREATE PROCEDURE [dbo].[AddApprovalType] @approvalCode nvarchar(10), @approvalName nvarchar(20)
AS
INSERT INTO ApprovalTypes (approvalCode, approvalName) VALUES (@approvalCode, @approvalName);
SELECT * from ApprovalTypes;


CREATE PROCEDURE [dbo].[AddCellphone] @beforeCellphone nvarchar(10)
AS
INSERT INTO BeforeCellphones (beforeCellphone) VALUES (@beforeCellphone);
SELECT beforeCellphone from BeforeCellphones where beforeCellphone=@beforeCellphone;


CREATE PROCEDURE [dbo].[AddCourse] @courseCode nvarchar(50), @courseName nvarchar(50)
AS
INSERT INTO Courses (courseCode, courseName) VALUES (@courseCode, @courseName);
SELECT * from Courses where courseCode=@courseCode;


CREATE PROCEDURE [dbo].[AddFaculty] @facultyCode nvarchar(50), @facultyName nvarchar(50), @facultyHead nvarchar(50)
AS
INSERT INTO Facultys (facultyCode, facultyName, facultyHead) VALUES (@facultyCode, @facultyName, @facultyHead);
SELECT * from Facultys where facultyCode=@facultyCode;


CREATE PROCEDURE [dbo].[AddStudent] (@personId nvarchar(9), @personFirstName nvarchar(20), @personLastName nvarchar(20), @personBeforeTelephone nvarchar(10), @personTelephone nvarchar(30), @personBeforeCellphone nvarchar(10), @personCellphone nvarchar(30), @personCode int, @studentId nvarchar(9), @studentFacultyCode nvarchar(50), @studentYear int, @studentType int)
AS
set transaction isolation level Read Uncommitted
	begin try
		begin transaction
			INSERT INTO Persons (personId, personFirstName, personLastName, personBeforeTelephone, personTelephone, personBeforeCellphone, personCellphone, personCode) VALUES (@personId, @personFirstName, @personLastName, @personBeforeTelephone, @personTelephone, @personBeforeCellphone, @personCellphone, @personCode);
			INSERT INTO Students (studentId, studentType, studentYear, studentFacultyCode) VALUES (@studentId, @studentType, @studentYear, @studentFacultyCode);
			SELECT Persons.personId, Persons.personFirstName, Persons.personLastName, Persons.personBeforeTelephone, Persons.personTelephone, Persons.personBeforeCellphone, Persons.personCellphone, Persons.personCode, Students.studentId, Students.studentFacultyCode, Students.studentYear, Students.studentType From Persons INNER JOIN Students ON Persons.personId=Students.studentId where Students.studentId=@studentId;
		commit transaction
	end try
	begin catch
		rollback transaction
	end catch


CREATE PROCEDURE [dbo].[AddTeacher] (@personId nvarchar(9), @personFirstName nvarchar(20), @personLastName nvarchar(20), @personBeforeTelephone nvarchar(10), @personTelephone nvarchar(30), @personBeforeCellphone nvarchar(10), @personCellphone nvarchar(30), @personCode int, @teacherId nvarchar(9), @teacherFacultyCode nvarchar(50), @teacherStage int)
AS
set transaction isolation level Read Uncommitted
	begin try
		begin transaction
			INSERT INTO Persons (personId, personFirstName, personLastName, personBeforeTelephone, personTelephone, personBeforeCellphone, personCellphone, personCode) VALUES (@personId, @personFirstName, @personLastName, @personBeforeTelephone, @personTelephone, @personBeforeCellphone, @personCellphone, @personCode);
			INSERT INTO Teachers (teacherId, teacherFacultyCode, teacherStage) VALUES (@teacherId, @teacherFacultyCode, @teacherStage);
			SELECT Persons.personId, Persons.personFirstName, Persons.personLastName, Persons.personBeforeTelephone, Persons.personTelephone, Persons.personBeforeCellphone, Persons.personCellphone, Persons.personCode, Teachers.teacherId, Teachers.teacherFacultyCode, Teachers.teacherStage From Persons INNER JOIN Teachers ON Persons.personId=Teachers.teacherId where Teachers.teacherId=@teacherId;
		commit transaction
	end try
	begin catch
		rollback transaction
	end catch


CREATE PROCEDURE [dbo].[AddTelephone] @beforeTelephone nvarchar(10)
AS
INSERT INTO BeforeTelephones (beforeTelephone) VALUES (@beforeTelephone);
SELECT beforeTelephone from BeforeTelephones where beforeTelephone=@beforeTelephone;


CREATE PROCEDURE [dbo].[AddVehicle] @vehicleNumber nvarchar(50), @vehicleManufacturer nvarchar(50), @vehicleColor nvarchar(50), @vehicleOwnerId nvarchar(9)
AS
INSERT INTO Vehicles (vehicleNumber, vehicleManufacturer, vehicleColor, vehicleOwnerId) VALUES (@vehicleNumber, @vehicleManufacturer, @vehicleColor, @vehicleOwnerId);
SELECT Vehicles.vehicleNumber, Vehicles.vehicleManufacturer, Vehicles.vehicleColor, Vehicles.vehicleOwnerId, Persons.personFirstName, Persons.personLastName From Vehicles INNER JOIN Persons ON Vehicles.vehicleOwnerId=Persons.personId and Vehicles.vehicleNumber=@vehicleNumber;


CREATE PROCEDURE [dbo].[checkIfIdExists] @personId nvarchar(9)
AS
SELECT COUNT(1) FROM Persons WHERE personId = @personId;


CREATE PROCEDURE [dbo].[DeleteApprovalByNumber] @approvalNumber int
AS
DELETE FROM Approvals WHERE approvalNumber=@approvalNumber;


CREATE PROCEDURE [dbo].[DeleteApprovalByPerson] @approvalPersonId nvarchar(9)
AS
DELETE FROM Approvals WHERE approvalPersonId=@approvalPersonId;


CREATE PROCEDURE [dbo].[DeleteApprovalType] @approvalCode nvarchar(10)
AS
DELETE FROM ApprovalTypes WHERE approvalCode=@approvalCode;


CREATE PROCEDURE [dbo].[DeleteCellphone] @beforeCellphone nvarchar(10)
AS
DELETE FROM BeforeCellphones WHERE beforeCellphone=@beforeCellphone;


CREATE PROCEDURE [dbo].[DeleteCourse] @courseCode nvarchar(50)
AS
DELETE FROM Courses WHERE courseCode=@courseCode;


CREATE PROCEDURE [dbo].[DeleteFaculty] @facultyCode nvarchar(50)
AS
DELETE FROM Facultys WHERE facultyCode=@facultyCode;


CREATE PROCEDURE [dbo].[DeletePerson] @personId nvarchar(9)
AS
DELETE FROM Persons WHERE personId=@personId;


CREATE PROCEDURE [dbo].[DeleteStudent] @studentId nvarchar(9)
AS
set transaction isolation level Read Uncommitted
	begin try
		begin transaction
			DELETE FROM Students WHERE studentId=@studentId;
			DELETE FROM Persons WHERE personId=@studentId;
		commit transaction
	end try
	begin catch
		rollback transaction
	end catch


CREATE PROCEDURE [dbo].[DeleteTeacher] @teacherId nvarchar(9)
AS
set transaction isolation level Read Uncommitted
	begin try
		begin transaction
			DELETE FROM Teachers WHERE teacherId=@teacherId;
			DELETE FROM Persons WHERE personId=@teacherId;
		commit transaction
	end try
	begin catch
		rollback transaction
	end catch


CREATE PROCEDURE [dbo].[DeleteTelephone] @beforeTelephone nvarchar(10)
AS
DELETE FROM BeforeTelephones WHERE beforeTelephone=@beforeTelephone;


CREATE PROCEDURE [dbo].[DeleteVehicleByNumber] @vehicleNumber nvarchar(50)
AS
DELETE FROM Vehicles WHERE vehicleNumber=@vehicleNumber;


CREATE PROCEDURE [dbo].[DeleteVehicleByOwnerId] @vehicleOwnerId nvarchar(9)
AS
DELETE FROM Vehicles WHERE vehicleOwnerId=@vehicleOwnerId;


CREATE PROCEDURE [dbo].[GetAllApprovals]
AS
SELECT * from Approvals;


CREATE PROCEDURE [dbo].[GetAllApprovalTypes]
AS
SELECT * from ApprovalTypes;


CREATE PROCEDURE [dbo].[GetAllCellphones]
AS
SELECT beforeCellphone from BeforeCellphones;


CREATE PROCEDURE [dbo].[GetAllCourses]
AS
SELECT * from Courses;


CREATE PROCEDURE [dbo].[GetAllFaculties]
AS
SELECT * from Facultys;


CREATE PROCEDURE [dbo].[GetAllPersons]
AS
SELECT * from Persons;


CREATE PROCEDURE [dbo].[GetAllPersonsId]
AS
SELECT personId from Persons;


CREATE PROCEDURE [dbo].[GetAllStudents]
AS
SELECT Persons.personId, Persons.personFirstName, Persons.personLastName, Persons.personBeforeTelephone, Persons.personTelephone, Persons.personBeforeCellphone, Persons.personCellphone, Persons.personCode, Students.studentId, Students.studentFacultyCode, Students.studentYear, Students.studentType From Persons INNER JOIN Students ON Persons.personId=Students.studentId;


CREATE PROCEDURE [dbo].[GetAllTeachers]
AS
SELECT Persons.personId, Persons.personFirstName, Persons.personLastName, Persons.personBeforeTelephone, Persons.personTelephone, Persons.personBeforeCellphone, Persons.personCellphone, Persons.personCode, Teachers.teacherId, Teachers.teacherFacultyCode, Teachers.teacherStage From Persons INNER JOIN Teachers ON Persons.personId=Teachers.teacherId;


CREATE PROCEDURE [dbo].[GetAllTelephones]
AS
SELECT beforeTelephone from BeforeTelephones;


CREATE PROCEDURE [dbo].[GetAllVehicleNumbers]
AS
SELECT vehicleNumber from Vehicles;


CREATE PROCEDURE [dbo].[GetAllVehicles]
AS
SELECT Vehicles.vehicleNumber, Vehicles.vehicleManufacturer, Vehicles.vehicleColor, Vehicles.vehicleOwnerId, Persons.personFirstName, Persons.personLastName From Vehicles INNER JOIN Persons ON Vehicles.vehicleOwnerId=Persons.personId;


CREATE PROCEDURE [dbo].[GetOneApprovalByCode] @approvalCode nvarchar(10)
AS
SELECT * from Approvals where approvalCode=@approvalCode;


CREATE PROCEDURE [dbo].[GetOneApprovalByNumber] @approvalNumber int
AS
SELECT * from Approvals where approvalNumber=@approvalNumber;


CREATE PROCEDURE [dbo].[GetOneApprovalByPersonId] @approvalPersonId nvarchar(9)
AS
SELECT * from Approvals where approvalPersonId=@approvalPersonId;


CREATE PROCEDURE [dbo].[GetOneApprovalTypeByCode] @approvalCode nvarchar(10)
AS
SELECT * from ApprovalTypes where approvalCode=@approvalCode;


CREATE PROCEDURE [dbo].[GetOneApprovalTypeByName] @approvalName nvarchar(20)
AS
SELECT approvalCode, approvalName from ApprovalTypes where approvalName=@approvalName;


CREATE PROCEDURE [dbo].[GetOneBeforeCellphone] @beforeCellphone nvarchar(10)
AS
SELECT beforeCellphone from BeforeCellphones where beforeCellphone=@beforeCellphone;


CREATE PROCEDURE [dbo].[GetOneBeforeTelephone] @beforeTelephone nvarchar(10)
AS
SELECT beforeTelephone from BeforeTelephones where beforeTelephone=@beforeTelephone;


CREATE PROCEDURE [dbo].[GetOneCourseByCode] @courseCode nvarchar(50)
AS
SELECT * from Courses where courseCode=@courseCode;


CREATE PROCEDURE [dbo].[GetOneCourseByName] @courseName nvarchar(50)
AS
SELECT * from Courses where courseName=@courseName;


CREATE PROCEDURE [dbo].[GetOneFacultyByCode] @facultyCode nvarchar(50)
AS
SELECT * from Facultys where facultyCode=@facultyCode;


CREATE PROCEDURE [dbo].[GetOneFacultyByHead] @facultyHead nvarchar(50)
AS
SELECT * from Facultys where facultyHead=@facultyHead;


CREATE PROCEDURE [dbo].[GetOneFacultyByName] @facultyName nvarchar(50)
AS
SELECT * from Facultys where facultyName=@facultyName;


CREATE PROCEDURE [dbo].[GetOnePersonById] @personId nvarchar(9)
AS
SELECT * from Persons where personId=@personId;


CREATE PROCEDURE [dbo].[GetOneStudentById] @studentId nvarchar(9)
AS
SELECT Persons.personId, Persons.personFirstName, Persons.personLastName, Persons.personBeforeTelephone, Persons.personTelephone, Persons.personBeforeCellphone, Persons.personCellphone, Persons.personCode, Students.studentId, Students.studentFacultyCode, Students.studentYear, Students.studentType From Persons INNER JOIN Students ON Persons.personId=Students.studentId where Students.studentId=@studentId;


CREATE PROCEDURE [dbo].[GetOneTeacherById] @teacherId nvarchar(9)
AS
SELECT Persons.personId, Persons.personFirstName, Persons.personLastName, Persons.personBeforeTelephone, Persons.personTelephone, Persons.personBeforeCellphone, Persons.personCellphone, Persons.personCode, Teachers.teacherId, Teachers.teacherFacultyCode, Teachers.teacherStage From Persons INNER JOIN Teachers ON Persons.personId=Teachers.teacherId where Teachers.teacherId=@teacherId;


CREATE PROCEDURE [dbo].[GetOneVehicleByNumber] @vehicleNumber nvarchar(50)
AS
SELECT Vehicles.vehicleNumber, Vehicles.vehicleManufacturer, Vehicles.vehicleColor, Vehicles.vehicleOwnerId, Persons.personFirstName, Persons.personLastName From Vehicles INNER JOIN Persons ON Vehicles.vehicleOwnerId=Persons.personId and Vehicles.vehicleNumber=@vehicleNumber;


CREATE PROCEDURE [dbo].[GetOneVehicleByOwnerId] @vehicleOwnerId nvarchar(9)
AS
SELECT Vehicles.vehicleNumber, Vehicles.vehicleManufacturer, Vehicles.vehicleColor, Vehicles.vehicleOwnerId, Persons.personFirstName, Persons.personLastName From Vehicles INNER JOIN Persons ON Vehicles.vehicleOwnerId=Persons.personId and Vehicles.vehicleOwnerId=@vehicleOwnerId;


CREATE PROCEDURE [dbo].[UpdateApproval] @approvalCode nvarchar(10), @approvalFrom datetime, @approvalUntil datetime, @approvalPersonId nvarchar(9), @approvalNumber int
AS
UPDATE Approvals SET approvalCode = @approvalCode, approvalFrom = @approvalFrom, approvalUntil = @approvalUntil, approvalPersonId = @approvalPersonId, approvalNumber = @approvalNumber where approvalPersonId = @approvalPersonId;
SELECT * from Approvals where approvalNumber=@approvalNumber;


CREATE PROCEDURE [dbo].[UpdateApprovalType] @approvalCode nvarchar(10), @approvalName nvarchar(20)
AS
UPDATE ApprovalTypes SET approvalCode = @approvalCode, approvalName = @approvalName where approvalCode=@approvalCode
SELECT * from ApprovalTypes;


CREATE PROCEDURE [dbo].[UpdateCellphone] @beforeCellphone nvarchar(10)
AS
UPDATE BeforeCellphones SET beforeCellphone = @beforeCellphone where beforeCellphone=@beforeCellphone;
SELECT beforeCellphone from BeforeCellphones where beforeCellphone=@beforeCellphone;


CREATE PROCEDURE [dbo].[UpdateCourse] @courseCode nvarchar(50), @courseName nvarchar(50)
AS
UPDATE Courses SET courseCode = @courseCode, courseName = @courseName where courseCode=@courseCode;
SELECT * from Courses where courseCode=@courseCode;


CREATE PROCEDURE [dbo].[UpdateFaculty] @facultyCode nvarchar(50), @facultyName nvarchar(50), @facultyHead nvarchar(50)
AS
UPDATE Facultys SET facultyCode = @facultyCode, facultyName = @facultyName, facultyHead = @facultyHead where facultyCode=@facultyCode;
SELECT * from Facultys where facultyCode=@facultyCode;


CREATE PROCEDURE [dbo].[UpdateStudent] (@personId nvarchar(9), @personFirstName nvarchar(20), @personLastName nvarchar(20), @personBeforeTelephone nvarchar(10), @personTelephone nvarchar(30), @personBeforeCellphone nvarchar(10), @personCellphone nvarchar(30), @personCode int, @studentId nvarchar(9), @studentFacultyCode nvarchar(50), @studentYear int, @studentType int)
AS
set transaction isolation level Read Uncommitted
	begin try
		begin transaction
			UPDATE Persons SET personId = @personId, personFirstName = @personFirstName, personLastName = @personLastName, personBeforeTelephone = @personBeforeTelephone, personTelephone = @personTelephone, personBeforeCellphone = @personBeforeCellphone, personCellphone = @personCellphone, personCode = @personCode WHERE personId = @personId;
			UPDATE Students SET studentId = @studentId, studentType = @studentType, studentYear = @studentYear, studentFacultyCode = @studentFacultyCode WHERE studentId = @studentId;
			SELECT Persons.personId, Persons.personFirstName, Persons.personLastName, Persons.personBeforeTelephone, Persons.personTelephone, Persons.personBeforeCellphone, Persons.personCellphone, Persons.personCode, Students.studentId, Students.studentFacultyCode, Students.studentYear, Students.studentType From Persons INNER JOIN Students ON Persons.personId=Students.studentId where Students.studentId=@studentId;
		commit transaction
	end try
	begin catch
		rollback transaction
	end catch


CREATE PROCEDURE [dbo].[UpdateTeacher] (@personId nvarchar(9), @personFirstName nvarchar(20), @personLastName nvarchar(20), @personBeforeTelephone nvarchar(10), @personTelephone nvarchar(30), @personBeforeCellphone nvarchar(10), @personCellphone nvarchar(30), @personCode int, @teacherId nvarchar(9), @teacherFacultyCode nvarchar(50), @teacherStage int)
AS
set transaction isolation level Read Uncommitted
	begin try
		begin transaction
			UPDATE Persons SET personId = @personId, personFirstName = @personFirstName, personLastName = @personLastName, personBeforeTelephone = @personBeforeTelephone, personTelephone = @personTelephone, personBeforeCellphone = @personBeforeCellphone, personCellphone = @personCellphone, personCode = @personCode WHERE personId = @personId;
			UPDATE Teachers SET teacherId = @teacherId, teacherFacultyCode = @teacherFacultyCode, teacherStage = @teacherStage WHERE teacherId = @teacherId;
			SELECT Persons.personId, Persons.personFirstName, Persons.personLastName, Persons.personBeforeTelephone, Persons.personTelephone, Persons.personBeforeCellphone, Persons.personCellphone, Persons.personCode, Teachers.teacherId, Teachers.teacherFacultyCode, Teachers.teacherStage From Persons INNER JOIN Teachers ON Persons.personId=Teachers.teacherId where Teachers.teacherId=@teacherId;
		commit transaction
	end try
	begin catch
		rollback transaction
	end catch


CREATE PROCEDURE [dbo].[UpdateTelephone] @beforeTelephone nvarchar(10)
AS
UPDATE BeforeTelephones SET beforeTelephone = @beforeTelephone where beforeTelephone=@beforeTelephone;
SELECT beforeTelephone from BeforeTelephones where beforeTelephone=@beforeTelephone;


CREATE PROCEDURE [dbo].[UpdateVehicle] @vehicleNumber nvarchar(50), @vehicleManufacturer nvarchar(50), @vehicleColor nvarchar(50), @vehicleOwnerId nvarchar(9)
AS
UPDATE Vehicles SET vehicleNumber = @vehicleNumber, vehicleManufacturer = @vehicleManufacturer, vehicleColor = @vehicleColor, vehicleOwnerId = @vehicleOwnerId where vehicleNumber=@vehicleNumber or vehicleOwnerId = @vehicleOwnerId;
SELECT Vehicles.vehicleNumber, Vehicles.vehicleManufacturer, Vehicles.vehicleColor, Vehicles.vehicleOwnerId, Persons.personFirstName, Persons.personLastName From Vehicles INNER JOIN Persons ON Vehicles.vehicleOwnerId=Persons.personId and Vehicles.vehicleNumber=@vehicleNumber;