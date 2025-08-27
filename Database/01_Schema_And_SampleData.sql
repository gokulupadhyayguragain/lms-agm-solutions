-- ================================================================================
-- AGM Solutions LMS - Complete Database Schema & Initial Data Setup
-- File: AGM_LMS_Schema_And_Data.sql
-- Purpose: Complete DDL/DML script for database creation and initial data
-- ================================================================================

-- Drop and recreate database for clean setup
USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'AGMSolutions')
BEGIN
    ALTER DATABASE AGMSolutions SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE AGMSolutions;
END
GO

CREATE DATABASE AGMSolutions;
GO

USE AGMSolutions;
GO

-- ================================================================================
-- TABLE CREATION (DDL)
-- ================================================================================

-- 1. Roles Table
CREATE TABLE Roles (
    RoleID INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(255),
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- 2. Users Table
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(100) NOT NULL,
    MiddleName NVARCHAR(100),
    LastName NVARCHAR(100) NOT NULL,
    Username NVARCHAR(50) UNIQUE NOT NULL,
    Email NVARCHAR(255) UNIQUE NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    Salt NVARCHAR(255) NOT NULL,
    PhoneNumber NVARCHAR(20),
    CountryCode NVARCHAR(5),
    Gender NVARCHAR(10),
    DateOfBirth DATE,
    ProfilePicture NVARCHAR(500),
    UserTypeID INT NOT NULL,
    IsEmailConfirmed BIT DEFAULT 0,
    EmailConfirmationToken NVARCHAR(255),
    TokenExpiry DATETIME,
    PasswordResetToken NVARCHAR(255),
    PasswordResetExpiry DATETIME,
    IsActive BIT DEFAULT 1,
    RegistrationDate DATETIME DEFAULT GETDATE(),
    LastLoginDate DATETIME,
    CreatedBy INT,
    ModifiedBy INT,
    ModifiedDate DATETIME,
    FOREIGN KEY (UserTypeID) REFERENCES Roles(RoleID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID),
    FOREIGN KEY (ModifiedBy) REFERENCES Users(UserID)
);

-- 3. Courses Table
CREATE TABLE Courses (
    CourseID INT IDENTITY(1,1) PRIMARY KEY,
    CourseName NVARCHAR(255) NOT NULL,
    CourseCode NVARCHAR(50) UNIQUE NOT NULL,
    Description NTEXT,
    LecturerID INT,
    Credits INT DEFAULT 3,
    Duration NVARCHAR(50), -- e.g., "12 weeks", "1 semester"
    IsActive BIT DEFAULT 1,
    CreationDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME,
    FOREIGN KEY (LecturerID) REFERENCES Users(UserID)
);

-- 4. Subjects Table (for lecturer specializations)
CREATE TABLE Subjects (
    SubjectID INT IDENTITY(1,1) PRIMARY KEY,
    SubjectName NVARCHAR(255) NOT NULL UNIQUE,
    SubjectCode NVARCHAR(50) UNIQUE NOT NULL,
    Description NTEXT,
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- 5. LecturerSubjects Table (many-to-many for lecturer subject assignments)
CREATE TABLE LecturerSubjects (
    LecturerSubjectID INT IDENTITY(1,1) PRIMARY KEY,
    LecturerID INT NOT NULL,
    SubjectID INT NOT NULL,
    AssignedDate DATETIME DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1,
    FOREIGN KEY (LecturerID) REFERENCES Users(UserID),
    FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID),
    CONSTRAINT UC_LecturerSubject UNIQUE (LecturerID, SubjectID)
);

-- 6. Enrollments Table
CREATE TABLE Enrollments (
    EnrollmentID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    EnrollmentDate DATETIME DEFAULT GETDATE(),
    CompletionDate DATETIME,
    IsActive BIT DEFAULT 1,
    Grade NVARCHAR(5), -- A+, A, B+, etc.
    GradePoints DECIMAL(3,2), -- 4.00, 3.75, etc.
    FOREIGN KEY (StudentID) REFERENCES Users(UserID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    CONSTRAINT UC_StudentCourse UNIQUE (StudentID, CourseID)
);

-- 7. Quizzes Table
CREATE TABLE Quizzes (
    QuizID INT IDENTITY(1,1) PRIMARY KEY,
    CourseID INT NOT NULL,
    SubjectCode NVARCHAR(50),
    Title NVARCHAR(255) NOT NULL,
    Description NTEXT,
    TimeLimit INT NOT NULL, -- in minutes
    AttemptsAllowed INT DEFAULT 3,
    TotalMarks INT NOT NULL,
    PassingMarks INT,
    QuizType NVARCHAR(50) DEFAULT 'MIXED', -- MCQ, DRAGDROP, DROPDOWN, MIXED
    IsActive BIT DEFAULT 1,
    IsProctored BIT DEFAULT 0,
    AllowFullScreen BIT DEFAULT 1,
    AllowTabSwitching BIT DEFAULT 0,
    MaxTabSwitchWarnings INT DEFAULT 3,
    DateCreated DATETIME DEFAULT GETDATE(),
    CreatedBy INT,
    ModifiedDate DATETIME,
    ModifiedBy INT,
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID),
    FOREIGN KEY (ModifiedBy) REFERENCES Users(UserID)
);

-- 8. QuizQuestions Table
CREATE TABLE QuizQuestions (
    QuestionID INT IDENTITY(1,1) PRIMARY KEY,
    QuizID INT NOT NULL,
    QuestionOrder INT NOT NULL,
    QuestionText NTEXT NOT NULL,
    QuestionType NVARCHAR(20) NOT NULL, -- MCQ, DRAGDROP, DROPDOWN
    OptionsJson NTEXT NOT NULL, -- JSON format for options
    CorrectAnswerJson NTEXT NOT NULL, -- JSON format for correct answers
    Points INT DEFAULT 1,
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (QuizID) REFERENCES Quizzes(QuizID)
);

-- 9. QuizAttempts Table
CREATE TABLE QuizAttempts (
    AttemptID INT IDENTITY(1,1) PRIMARY KEY,
    QuizID INT NOT NULL,
    StudentID INT NOT NULL,
    AttemptNumber INT NOT NULL,
    StartTime DATETIME DEFAULT GETDATE(),
    EndTime DATETIME,
    Score DECIMAL(5,2),
    TotalMarks INT,
    Percentage DECIMAL(5,2),
    IsCompleted BIT DEFAULT 0,
    TimeSpent INT, -- in minutes
    AnswersJson NTEXT, -- JSON format for student answers
    TabSwitchCount INT DEFAULT 0,
    WarningCount INT DEFAULT 0,
    IsSubmitted BIT DEFAULT 0,
    SubmissionDate DATETIME,
    FOREIGN KEY (QuizID) REFERENCES Quizzes(QuizID),
    FOREIGN KEY (StudentID) REFERENCES Users(UserID)
);

-- 10. Assignments Table
CREATE TABLE Assignments (
    AssignmentID INT IDENTITY(1,1) PRIMARY KEY,
    CourseID INT NOT NULL,
    Title NVARCHAR(255) NOT NULL,
    Description NTEXT,
    Instructions NTEXT,
    MaxMarks INT NOT NULL,
    DueDate DATETIME NOT NULL,
    SubmissionStartDate DATETIME DEFAULT GETDATE(),
    SubmissionEndDate DATETIME,
    AllowLateSubmission BIT DEFAULT 0,
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME DEFAULT GETDATE(),
    CreatedBy INT,
    ModifiedDate DATETIME,
    ModifiedBy INT,
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID),
    FOREIGN KEY (ModifiedBy) REFERENCES Users(UserID)
);

-- 11. AssignmentFiles Table (for assignment resources)
CREATE TABLE AssignmentFiles (
    FileID INT IDENTITY(1,1) PRIMARY KEY,
    AssignmentID INT NOT NULL,
    FileName NVARCHAR(255) NOT NULL,
    FilePath NVARCHAR(500) NOT NULL,
    FileSize BIGINT,
    FileType NVARCHAR(50),
    UploadedDate DATETIME DEFAULT GETDATE(),
    UploadedBy INT,
    FOREIGN KEY (AssignmentID) REFERENCES Assignments(AssignmentID),
    FOREIGN KEY (UploadedBy) REFERENCES Users(UserID)
);

-- 12. AssignmentSubmissions Table
CREATE TABLE AssignmentSubmissions (
    SubmissionID INT IDENTITY(1,1) PRIMARY KEY,
    AssignmentID INT NOT NULL,
    StudentID INT NOT NULL,
    SubmissionText NTEXT,
    SubmissionDate DATETIME DEFAULT GETDATE(),
    IsLateSubmission BIT DEFAULT 0,
    Score DECIMAL(5,2),
    MaxScore INT,
    Percentage DECIMAL(5,2),
    Feedback NTEXT,
    GradedDate DATETIME,
    GradedBy INT,
    IsGraded BIT DEFAULT 0,
    FOREIGN KEY (AssignmentID) REFERENCES Assignments(AssignmentID),
    FOREIGN KEY (StudentID) REFERENCES Users(UserID),
    FOREIGN KEY (GradedBy) REFERENCES Users(UserID),
    CONSTRAINT UC_AssignmentSubmission UNIQUE (AssignmentID, StudentID)
);

-- 13. SubmissionFiles Table (for student submission files)
CREATE TABLE SubmissionFiles (
    FileID INT IDENTITY(1,1) PRIMARY KEY,
    SubmissionID INT NOT NULL,
    FileName NVARCHAR(255) NOT NULL,
    FilePath NVARCHAR(500) NOT NULL,
    FileSize BIGINT,
    FileType NVARCHAR(50),
    UploadedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (SubmissionID) REFERENCES AssignmentSubmissions(SubmissionID)
);

-- 14. Attendance Table
CREATE TABLE Attendance (
    AttendanceID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    AttendanceDate DATE NOT NULL,
    Status NVARCHAR(20) NOT NULL, -- Present, Absent, Late, Excused
    Remarks NVARCHAR(255),
    MarkedBy INT,
    MarkedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (StudentID) REFERENCES Users(UserID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    FOREIGN KEY (MarkedBy) REFERENCES Users(UserID),
    CONSTRAINT UC_StudentCourseDate UNIQUE (StudentID, CourseID, AttendanceDate)
);

-- 15. Certificates Table
CREATE TABLE Certificates (
    CertificateID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    CertificateNumber NVARCHAR(50) UNIQUE NOT NULL,
    IssueDate DATETIME DEFAULT GETDATE(),
    CompletionDate DATETIME,
    Grade NVARCHAR(5),
    CertificateTemplate NVARCHAR(255),
    IsActive BIT DEFAULT 1,
    FOREIGN KEY (StudentID) REFERENCES Users(UserID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

-- 16. ChatMessages Table
CREATE TABLE ChatMessages (
    MessageID INT IDENTITY(1,1) PRIMARY KEY,
    SenderID INT NOT NULL,
    ReceiverID INT NOT NULL,
    MessageText NVARCHAR(400) NOT NULL, -- 200 words limit
    ImagePath NVARCHAR(500),
    SentDate DATETIME DEFAULT GETDATE(),
    IsRead BIT DEFAULT 0,
    IsDeleted BIT DEFAULT 0,
    FOREIGN KEY (SenderID) REFERENCES Users(UserID),
    FOREIGN KEY (ReceiverID) REFERENCES Users(UserID)
);

-- 17. Friends Table (for student peer-to-peer communication)
CREATE TABLE Friends (
    FriendshipID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID1 INT NOT NULL,
    StudentID2 INT NOT NULL,
    Status NVARCHAR(20) DEFAULT 'Pending', -- Pending, Accepted, Blocked
    RequestDate DATETIME DEFAULT GETDATE(),
    AcceptedDate DATETIME,
    FOREIGN KEY (StudentID1) REFERENCES Users(UserID),
    FOREIGN KEY (StudentID2) REFERENCES Users(UserID),
    CONSTRAINT UC_Friendship UNIQUE (StudentID1, StudentID2)
);

-- 18. StudentGroups Table
CREATE TABLE StudentGroups (
    GroupID INT IDENTITY(1,1) PRIMARY KEY,
    GroupName NVARCHAR(255) NOT NULL,
    CourseID INT NOT NULL,
    CreatedBy INT NOT NULL,
    Description NTEXT,
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);

-- 19. GroupMembers Table
CREATE TABLE GroupMembers (
    GroupMemberID INT IDENTITY(1,1) PRIMARY KEY,
    GroupID INT NOT NULL,
    StudentID INT NOT NULL,
    JoinedDate DATETIME DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1,
    FOREIGN KEY (GroupID) REFERENCES StudentGroups(GroupID),
    FOREIGN KEY (StudentID) REFERENCES Users(UserID),
    CONSTRAINT UC_GroupMember UNIQUE (GroupID, StudentID)
);

-- 20. Notices Table
CREATE TABLE Notices (
    NoticeID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(255) NOT NULL,
    Content NTEXT NOT NULL,
    SenderID INT NOT NULL,
    CourseID INT,
    GroupID INT,
    Priority NVARCHAR(20) DEFAULT 'Normal', -- Low, Normal, High, Urgent
    IsGlobal BIT DEFAULT 0,
    ExpiryDate DATETIME,
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (SenderID) REFERENCES Users(UserID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    FOREIGN KEY (GroupID) REFERENCES StudentGroups(GroupID)
);

-- 21. NoticeRecipients Table
CREATE TABLE NoticeRecipients (
    RecipientID INT IDENTITY(1,1) PRIMARY KEY,
    NoticeID INT NOT NULL,
    UserID INT NOT NULL,
    IsRead BIT DEFAULT 0,
    ReadDate DATETIME,
    FOREIGN KEY (NoticeID) REFERENCES Notices(NoticeID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CONSTRAINT UC_NoticeRecipient UNIQUE (NoticeID, UserID)
);

-- 22. Calendar Events Table
CREATE TABLE CalendarEvents (
    EventID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(255) NOT NULL,
    Description NTEXT,
    EventType NVARCHAR(50) NOT NULL, -- Quiz, Assignment, Class, Meeting, Announcement
    StartDateTime DATETIME NOT NULL,
    EndDateTime DATETIME,
    CourseID INT,
    CreatedBy INT NOT NULL,
    IsAllDay BIT DEFAULT 0,
    IsRecurring BIT DEFAULT 0,
    RecurrencePattern NVARCHAR(100), -- Daily, Weekly, Monthly
    Color NVARCHAR(7) DEFAULT '#007bff', -- Hex color code
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);

-- 23. SystemSettings Table
CREATE TABLE SystemSettings (
    SettingID INT IDENTITY(1,1) PRIMARY KEY,
    SettingKey NVARCHAR(100) UNIQUE NOT NULL,
    SettingValue NTEXT,
    Description NVARCHAR(500),
    Category NVARCHAR(50) DEFAULT 'General',
    IsEditable BIT DEFAULT 1,
    ModifiedDate DATETIME DEFAULT GETDATE(),
    ModifiedBy INT,
    FOREIGN KEY (ModifiedBy) REFERENCES Users(UserID)
);

-- 24. ActivityLog Table
CREATE TABLE ActivityLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT,
    Action NVARCHAR(255) NOT NULL,
    Description NVARCHAR(500),
    IPAddress NVARCHAR(45),
    UserAgent NVARCHAR(500),
    LogDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- 25. Grades Table (comprehensive grading system)
CREATE TABLE Grades (
    GradeID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    AssignmentID INT,
    QuizID INT,
    GradeType NVARCHAR(20) NOT NULL, -- Assignment, Quiz, Final, Midterm
    Score DECIMAL(5,2) NOT NULL,
    MaxScore DECIMAL(5,2) NOT NULL,
    Percentage DECIMAL(5,2),
    LetterGrade NVARCHAR(5),
    GradePoints DECIMAL(3,2),
    Comments NTEXT,
    GradedDate DATETIME DEFAULT GETDATE(),
    GradedBy INT NOT NULL,
    IsFinalized BIT DEFAULT 0,
    FOREIGN KEY (StudentID) REFERENCES Users(UserID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    FOREIGN KEY (AssignmentID) REFERENCES Assignments(AssignmentID),
    FOREIGN KEY (QuizID) REFERENCES Quizzes(QuizID),
    FOREIGN KEY (GradedBy) REFERENCES Users(UserID)
);

-- ================================================================================
-- INDEXES FOR PERFORMANCE
-- ================================================================================

-- User indexes
CREATE INDEX IX_Users_Email ON Users(Email);
CREATE INDEX IX_Users_Username ON Users(Username);
CREATE INDEX IX_Users_UserTypeID ON Users(UserTypeID);
CREATE INDEX IX_Users_IsActive ON Users(IsActive);

-- Course indexes
CREATE INDEX IX_Courses_LecturerID ON Courses(LecturerID);
CREATE INDEX IX_Courses_IsActive ON Courses(IsActive);

-- Enrollment indexes
CREATE INDEX IX_Enrollments_StudentID ON Enrollments(StudentID);
CREATE INDEX IX_Enrollments_CourseID ON Enrollments(CourseID);
CREATE INDEX IX_Enrollments_IsActive ON Enrollments(IsActive);

-- Quiz indexes
CREATE INDEX IX_Quizzes_CourseID ON Quizzes(CourseID);
CREATE INDEX IX_QuizAttempts_QuizID ON QuizAttempts(QuizID);
CREATE INDEX IX_QuizAttempts_StudentID ON QuizAttempts(StudentID);

-- Assignment indexes
CREATE INDEX IX_Assignments_CourseID ON Assignments(CourseID);
CREATE INDEX IX_AssignmentSubmissions_AssignmentID ON AssignmentSubmissions(AssignmentID);
CREATE INDEX IX_AssignmentSubmissions_StudentID ON AssignmentSubmissions(StudentID);

-- Chat indexes
CREATE INDEX IX_ChatMessages_SenderID ON ChatMessages(SenderID);
CREATE INDEX IX_ChatMessages_ReceiverID ON ChatMessages(ReceiverID);
CREATE INDEX IX_ChatMessages_SentDate ON ChatMessages(SentDate);

-- ================================================================================
-- INITIAL DATA POPULATION (DML)
-- ================================================================================

-- Insert Roles
INSERT INTO Roles (RoleName, Description) VALUES 
('Student', 'Students who enroll in courses and take quizzes'),
('Lecturer', 'Lecturers who teach courses and manage students'),
('Admin', 'System administrators with full access');

-- Insert System Settings
INSERT INTO SystemSettings (SettingKey, SettingValue, Description, Category) VALUES 
('EmailSMTPServer', 'smtp.gmail.com', 'SMTP server for email notifications', 'Email'),
('EmailSMTPPort', '587', 'SMTP port for email', 'Email'),
('EmailUsername', 'gokulupadhayaya19@gmail.com', 'System email username', 'Email'),
('EmailDisplayName', 'AGM Solutions LMS', 'Display name for system emails', 'Email'),
('MaxFileUploadSize', '10485760', 'Maximum file upload size in bytes (10MB)', 'Files'),
('AllowedFileTypes', '.pdf,.doc,.docx,.jpg,.jpeg,.png,.gif', 'Allowed file extensions', 'Files'),
('DefaultTheme', 'blue', 'Default application theme', 'UI'),
('SessionTimeout', '60', 'Session timeout in minutes', 'Security'),
('MaxLoginAttempts', '5', 'Maximum login attempts before lockout', 'Security'),
('PasswordMinLength', '8', 'Minimum password length', 'Security'),
('RequirePasswordComplexity', '1', 'Require complex passwords (1=yes, 0=no)', 'Security'),
('EnableTwoFactorAuth', '0', 'Enable two-factor authentication', 'Security'),
('SystemMaintenanceMode', '0', 'System maintenance mode (1=on, 0=off)', 'System'),
('ApplicationVersion', '1.0.0', 'Current application version', 'System'),
('SupportEmail', 'support@agmsolutions.com', 'Support contact email', 'Support');

-- Insert Subjects
INSERT INTO Subjects (SubjectName, SubjectCode, Description) VALUES 
('Computer Science', 'CS', 'Computer Science and Programming'),
('Mathematics', 'MATH', 'Mathematics and Statistics'),
('Physics', 'PHY', 'Physics and Applied Sciences'),
('Chemistry', 'CHEM', 'Chemistry and Chemical Sciences'),
('Biology', 'BIO', 'Biology and Life Sciences'),
('English', 'ENG', 'English Language and Literature'),
('Business Administration', 'BUS', 'Business and Management'),
('Economics', 'ECON', 'Economics and Finance'),
('Psychology', 'PSY', 'Psychology and Behavioral Sciences'),
('Engineering', 'ENGR', 'Engineering and Technology');

-- Insert Initial Admin User (with proper hashing - you should use your actual hash/salt)
INSERT INTO Users (FirstName, MiddleName, LastName, Username, Email, PasswordHash, Salt, 
                   UserTypeID, IsEmailConfirmed, IsActive, RegistrationDate)
VALUES ('System', '', 'Administrator', 'admin', 'admin@agmsolutions.com', 
        'hashed_password_here', 'salt_here', 3, 1, 1, GETDATE());

-- Get the admin user ID for subsequent operations
DECLARE @AdminID INT = SCOPE_IDENTITY();

-- Update admin user to be created by itself
UPDATE Users SET CreatedBy = @AdminID WHERE UserID = @AdminID;

PRINT 'Database schema and initial data setup completed successfully.';
GO
    UserTypeID int NOT NULL,
    IsActive bit DEFAULT 1,
    IsEmailConfirmed bit DEFAULT 0,
    EmailConfirmationToken nvarchar(255),
    EmailConfirmationExpiry datetime2,
    PasswordResetToken nvarchar(255),
    PasswordResetExpiry datetime2,
    LastLoginDate datetime2,
    RegistrationDate datetime2 DEFAULT GETDATE(),
    CreatedBy int,
    ModifiedDate datetime2 DEFAULT GETDATE(),
    FOREIGN KEY (UserTypeID) REFERENCES Roles(RoleID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);

-- ========================================
-- ACADEMIC STRUCTURE TABLES
-- ========================================

-- Create Subjects table
CREATE TABLE Subjects (
    SubjectID int IDENTITY(1,1) PRIMARY KEY,
    SubjectCode nvarchar(20) NOT NULL UNIQUE,
    SubjectName nvarchar(200) NOT NULL,
    Description ntext,
    Credits int DEFAULT 3,
    IsActive bit DEFAULT 1,
    CreatedDate datetime2 DEFAULT GETDATE(),
    CreatedBy int,
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);

-- Create Courses table
CREATE TABLE Courses (
    CourseID int IDENTITY(1,1) PRIMARY KEY,
    CourseName nvarchar(200) NOT NULL,
    CourseCode nvarchar(20) NOT NULL UNIQUE,
    Description ntext,
    SubjectID int NOT NULL,
    LecturerID int,
    StartDate date,
    EndDate date,
    MaxStudents int DEFAULT 50,
    IsActive bit DEFAULT 1,
    CreationDate datetime2 DEFAULT GETDATE(),
    CreatedBy int,
    FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID),
    FOREIGN KEY (LecturerID) REFERENCES Users(UserID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);

-- Create LecturerSubjects table (Many-to-Many: Max 5 subjects per lecturer)
CREATE TABLE LecturerSubjects (
    LecturerSubjectID int IDENTITY(1,1) PRIMARY KEY,
    LecturerID int NOT NULL,
    SubjectID int NOT NULL,
    AssignedDate datetime2 DEFAULT GETDATE(),
    IsActive bit DEFAULT 1,
    AssignedBy int,
    FOREIGN KEY (LecturerID) REFERENCES Users(UserID),
    FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID),
    FOREIGN KEY (AssignedBy) REFERENCES Users(UserID),
    UNIQUE(LecturerID, SubjectID)
);

-- Create Enrollments table
CREATE TABLE Enrollments (
    EnrollmentID int IDENTITY(1,1) PRIMARY KEY,
    StudentID int NOT NULL,
    CourseID int NOT NULL,
    EnrollmentDate datetime2 DEFAULT GETDATE(),
    Status nvarchar(20) DEFAULT 'Active', -- Active, Completed, Dropped, Unenrolled
    CompletionDate datetime2,
    FinalGrade nvarchar(5),
    IsActive bit DEFAULT 1,
    FOREIGN KEY (StudentID) REFERENCES Users(UserID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    UNIQUE(StudentID, CourseID)
);

-- ========================================
-- QUIZ SYSTEM TABLES
-- ========================================

-- Create Quizzes table
CREATE TABLE Quizzes (
    QuizID int IDENTITY(1,1) PRIMARY KEY,
    CourseID int NOT NULL,
    SubjectCode nvarchar(20),
    Title nvarchar(200) NOT NULL,
    Description ntext,
    TimeLimit int DEFAULT 30, -- minutes
    TotalMarks decimal(10,2),
    AttemptsAllowed int DEFAULT 1,
    QuizType nvarchar(20) DEFAULT 'MIXED', -- MCQ, MIXED, etc.
    IsActive bit DEFAULT 1,
    StartDate datetime2,
    EndDate datetime2,
    IsProctored bit DEFAULT 0,
    ProctoringSettings ntext, -- JSON for proctoring configuration
    CreatedBy int NOT NULL,
    DateCreated datetime2 DEFAULT GETDATE(),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);

-- Create Questions table
CREATE TABLE Questions (
    QuestionID int IDENTITY(1,1) PRIMARY KEY,
    QuizID int NOT NULL,
    QuestionText ntext NOT NULL,
    QuestionType nvarchar(20) NOT NULL, -- MCQ, DRAGDROP, DROPDOWN
    Options ntext, -- JSON format for options
    CorrectAnswer ntext, -- JSON for single/multiple answers
    Points decimal(10,2) DEFAULT 1,
    QuestionOrder int,
    QuestionCode nvarchar(50), -- Q_ID from JSON
    IsActive bit DEFAULT 1,
    FOREIGN KEY (QuizID) REFERENCES Quizzes(QuizID)
);

-- Create QuizAttempts table
CREATE TABLE QuizAttempts (
    AttemptID int IDENTITY(1,1) PRIMARY KEY,
    QuizID int NOT NULL,
    StudentID int NOT NULL,
    AttemptNumber int DEFAULT 1,
    StartTime datetime2 DEFAULT GETDATE(),
    EndTime datetime2,
    TotalMarks decimal(10,2),
    ObtainedMarks decimal(10,2),
    Percentage decimal(5,2),
    Status nvarchar(20) DEFAULT 'In Progress', -- In Progress, Completed, Timed Out, Submitted
    IsSubmitted bit DEFAULT 0,
    ProctoringEvents ntext, -- JSON for proctoring violations
    FOREIGN KEY (QuizID) REFERENCES Quizzes(QuizID),
    FOREIGN KEY (StudentID) REFERENCES Users(UserID)
);

-- Create QuizAnswers table
CREATE TABLE QuizAnswers (
    AnswerID int IDENTITY(1,1) PRIMARY KEY,
    AttemptID int NOT NULL,
    QuestionID int NOT NULL,
    StudentAnswer ntext,
    IsCorrect bit,
    MarksAwarded decimal(10,2),
    AnsweredAt datetime2 DEFAULT GETDATE(),
    FOREIGN KEY (AttemptID) REFERENCES QuizAttempts(AttemptID),
    FOREIGN KEY (QuestionID) REFERENCES Questions(QuestionID),
    UNIQUE(AttemptID, QuestionID)
);

-- ========================================
-- ASSIGNMENT SYSTEM TABLES
-- ========================================

-- Create Assignments table
CREATE TABLE Assignments (
    AssignmentID int IDENTITY(1,1) PRIMARY KEY,
    CourseID int NOT NULL,
    Title nvarchar(200) NOT NULL,
    Description ntext,
    FilePath nvarchar(500),
    DueDate datetime2 NOT NULL,
    MaxMarks decimal(10,2) DEFAULT 100,
    IsActive bit DEFAULT 1,
    OpenDate datetime2 DEFAULT GETDATE(),
    CloseDate datetime2,
    CreatedBy int NOT NULL,
    CreatedDate datetime2 DEFAULT GETDATE(),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);

-- Create Submissions table
CREATE TABLE Submissions (
    SubmissionID int IDENTITY(1,1) PRIMARY KEY,
    AssignmentID int NOT NULL,
    StudentID int NOT NULL,
    FilePath nvarchar(500),
    SubmissionText ntext,
    SubmissionDate datetime2 DEFAULT GETDATE(),
    IsLate bit DEFAULT 0,
    Feedback ntext,
    MarksObtained decimal(10,2),
    Grade nvarchar(5),
    GradedBy int,
    GradedDate datetime2,
    FOREIGN KEY (AssignmentID) REFERENCES Assignments(AssignmentID),
    FOREIGN KEY (StudentID) REFERENCES Users(UserID),
    FOREIGN KEY (GradedBy) REFERENCES Users(UserID),
    UNIQUE(AssignmentID, StudentID)
);

-- ========================================
-- COMMUNICATION SYSTEM TABLES
-- ========================================

-- Create Groups table
CREATE TABLE Groups (
    GroupID int IDENTITY(1,1) PRIMARY KEY,
    GroupName nvarchar(100) NOT NULL,
    Description ntext,
    CourseID int,
    CreatedBy int NOT NULL,
    IsActive bit DEFAULT 1,
    CreatedDate datetime2 DEFAULT GETDATE(),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);

-- Create GroupMembers table
CREATE TABLE GroupMembers (
    GroupMemberID int IDENTITY(1,1) PRIMARY KEY,
    GroupID int NOT NULL,
    StudentID int NOT NULL,
    JoinedDate datetime2 DEFAULT GETDATE(),
    IsActive bit DEFAULT 1,
    FOREIGN KEY (GroupID) REFERENCES Groups(GroupID),
    FOREIGN KEY (StudentID) REFERENCES Users(UserID),
    UNIQUE(GroupID, StudentID)
);

-- Create ChatMessages table
CREATE TABLE ChatMessages (
    MessageID int IDENTITY(1,1) PRIMARY KEY,
    FromUserID int NOT NULL,
    ToUserID int,
    GroupID int,
    CourseID int,
    MessageText nvarchar(max) NOT NULL,
    ImagePath nvarchar(500),
    WordCount int DEFAULT 0,
    IsRead bit DEFAULT 0,
    SentDate datetime2 DEFAULT GETDATE(),
    MessageType nvarchar(20) DEFAULT 'Text', -- Text, Image, Notice
    FOREIGN KEY (FromUserID) REFERENCES Users(UserID),
    FOREIGN KEY (ToUserID) REFERENCES Users(UserID),
    FOREIGN KEY (GroupID) REFERENCES Groups(GroupID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

-- ========================================
-- ACADEMIC TRACKING TABLES
-- ========================================

-- Create Attendance table
CREATE TABLE Attendance (
    AttendanceID int IDENTITY(1,1) PRIMARY KEY,
    StudentID int NOT NULL,
    CourseID int NOT NULL,
    AttendanceDate date NOT NULL,
    Status nvarchar(20) DEFAULT 'Present', -- Present, Absent, Late
    Remarks nvarchar(255),
    MarkedBy int NOT NULL,
    MarkedDate datetime2 DEFAULT GETDATE(),
    FOREIGN KEY (StudentID) REFERENCES Users(UserID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    FOREIGN KEY (MarkedBy) REFERENCES Users(UserID),
    UNIQUE(StudentID, CourseID, AttendanceDate)
);

-- Create Grades table
CREATE TABLE Grades (
    GradeID int IDENTITY(1,1) PRIMARY KEY,
    StudentID int NOT NULL,
    CourseID int NOT NULL,
    AssessmentType nvarchar(50), -- Quiz, Assignment, Exam, Final
    AssessmentID int, -- QuizID or AssignmentID
    AssessmentName nvarchar(200),
    MaxMarks decimal(10,2),
    ObtainedMarks decimal(10,2),
    Percentage decimal(5,2),
    Grade nvarchar(5),
    GradeDate datetime2 DEFAULT GETDATE(),
    GradedBy int NOT NULL,
    FOREIGN KEY (StudentID) REFERENCES Users(UserID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    FOREIGN KEY (GradedBy) REFERENCES Users(UserID)
);

-- ========================================
-- CALENDAR & EVENTS TABLES
-- ========================================

-- Create Events table
CREATE TABLE Events (
    EventID int IDENTITY(1,1) PRIMARY KEY,
    Title nvarchar(200) NOT NULL,
    Description ntext,
    EventDate datetime2 NOT NULL,
    EndDate datetime2,
    EventType nvarchar(50), -- Quiz, Assignment, Class, Exam, Notice
    CourseID int,
    CreatedBy int NOT NULL,
    IsActive bit DEFAULT 1,
    CreatedDate datetime2 DEFAULT GETDATE(),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);

-- Create Timetable table
CREATE TABLE Timetable (
    TimetableID int IDENTITY(1,1) PRIMARY KEY,
    CourseID int NOT NULL,
    DayOfWeek int NOT NULL, -- 1=Monday, 7=Sunday
    StartTime time NOT NULL,
    EndTime time NOT NULL,
    Classroom nvarchar(100),
    IsActive bit DEFAULT 1,
    CreatedBy int NOT NULL,
    CreatedDate datetime2 DEFAULT GETDATE(),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);

-- ========================================
-- CERTIFICATES & REPORTS TABLES
-- ========================================

-- Create Certificates table
CREATE TABLE Certificates (
    CertificateID int IDENTITY(1,1) PRIMARY KEY,
    StudentID int NOT NULL,
    CourseID int NOT NULL,
    CertificateNumber nvarchar(100) NOT NULL UNIQUE,
    CertificatePath nvarchar(500),
    IssuedDate datetime2 DEFAULT GETDATE(),
    IssuedBy int NOT NULL,
    FOREIGN KEY (StudentID) REFERENCES Users(UserID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    FOREIGN KEY (IssuedBy) REFERENCES Users(UserID),
    UNIQUE(StudentID, CourseID)
);

-- ========================================
-- SYSTEM CONFIGURATION TABLES
-- ========================================

-- Create SystemSettings table
CREATE TABLE SystemSettings (
    SettingID int IDENTITY(1,1) PRIMARY KEY,
    SettingKey nvarchar(100) NOT NULL UNIQUE,
    SettingValue nvarchar(max),
    Description nvarchar(255),
    Category nvarchar(50),
    ModifiedBy int,
    ModifiedDate datetime2 DEFAULT GETDATE(),
    FOREIGN KEY (ModifiedBy) REFERENCES Users(UserID)
);

-- Create ActivityLog table
CREATE TABLE ActivityLog (
    LogID int IDENTITY(1,1) PRIMARY KEY,
    UserID int,
    Action nvarchar(100) NOT NULL,
    TableName nvarchar(50),
    RecordID int,
    OldValues ntext,
    NewValues ntext,
    IPAddress nvarchar(45),
    UserAgent nvarchar(500),
    LogDate datetime2 DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Create UserSessions table
CREATE TABLE UserSessions (
    SessionID int IDENTITY(1,1) PRIMARY KEY,
    UserID int NOT NULL,
    SessionToken nvarchar(255) NOT NULL UNIQUE,
    LoginTime datetime2 DEFAULT GETDATE(),
    LastActivity datetime2 DEFAULT GETDATE(),
    LogoutTime datetime2,
    IPAddress nvarchar(45),
    UserAgent nvarchar(500),
    IsActive bit DEFAULT 1,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- ========================================
-- INDEXES FOR PERFORMANCE
-- ========================================

-- User-related indexes
CREATE INDEX IX_Users_Email ON Users(Email);
CREATE INDEX IX_Users_Username ON Users(Username);
CREATE INDEX IX_Users_UserTypeID ON Users(UserTypeID);
CREATE INDEX IX_Users_IsActive ON Users(IsActive);

-- Course-related indexes
CREATE INDEX IX_Courses_LecturerID ON Courses(LecturerID);
CREATE INDEX IX_Courses_SubjectID ON Courses(SubjectID);
CREATE INDEX IX_Enrollments_StudentID ON Enrollments(StudentID);
CREATE INDEX IX_Enrollments_CourseID ON Enrollments(CourseID);

-- Quiz-related indexes
CREATE INDEX IX_Quizzes_CourseID ON Quizzes(CourseID);
CREATE INDEX IX_Questions_QuizID ON Questions(QuizID);
CREATE INDEX IX_QuizAttempts_StudentID ON QuizAttempts(StudentID);
CREATE INDEX IX_QuizAttempts_QuizID ON QuizAttempts(QuizID);

-- Communication indexes
CREATE INDEX IX_ChatMessages_FromUserID ON ChatMessages(FromUserID);
CREATE INDEX IX_ChatMessages_ToUserID ON ChatMessages(ToUserID);
CREATE INDEX IX_ChatMessages_SentDate ON ChatMessages(SentDate);

-- ========================================
-- INITIAL DATA INSERTION
-- ========================================

-- Insert default roles
INSERT INTO Roles (RoleName, Description) VALUES 
('Student', 'Student role with access to courses, quizzes, and assignments'),
('Lecturer', 'Lecturer role with access to create and manage courses'),
('Admin', 'Administrator role with full system access');

-- Insert system settings
INSERT INTO SystemSettings (SettingKey, SettingValue, Description, Category) VALUES 
('SMTP_Server', 'smtp.gmail.com', 'SMTP server for email notifications', 'Email'),
('SMTP_Port', '587', 'SMTP port for email notifications', 'Email'),
('SMTP_Username', 'gokulupadhayaya19@gmail.com', 'SMTP username for email notifications', 'Email'),
('SMTP_Password', 'ywev ekdw txju fudd', 'SMTP password for email notifications', 'Email'),
('SMTP_EnableSSL', 'true', 'Enable SSL for SMTP connection', 'Email'),
('Application_Name', 'AGM Solutions LMS', 'Application display name', 'General'),
('Max_Login_Attempts', '5', 'Maximum login attempts before account lockout', 'Security'),
('Session_Timeout', '30', 'Session timeout in minutes', 'Security'),
('File_Upload_MaxSize', '10485760', 'Maximum file upload size in bytes (10MB)', 'System'),
('Chat_Message_MaxWords', '200', 'Maximum words per chat message', 'Communication'),
('Lecturer_Max_Subjects', '5', 'Maximum subjects a lecturer can teach', 'Academic');

-- Insert default admin user
DECLARE @AdminRoleID int = (SELECT RoleID FROM Roles WHERE RoleName = 'Admin');
INSERT INTO Users (FirstName, LastName, Email, Username, PasswordHash, Salt, UserTypeID, IsActive, IsEmailConfirmed, RegistrationDate)
VALUES ('System', 'Administrator', 'admin@agmsolutions.com', 'admin', 
        '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'admin_salt',
        @AdminRoleID, 1, 1, GETDATE());

-- Insert sample subjects
INSERT INTO Subjects (SubjectCode, SubjectName, Description, Credits, CreatedBy) VALUES 
('CS101', 'Computer Science Fundamentals', 'Introduction to Computer Science concepts', 3, 1),
('MATH101', 'Mathematics', 'Basic Mathematics and Algebra', 3, 1),
('ENG101', 'English Language', 'English Language and Communication Skills', 3, 1),
('PHYS101', 'Physics', 'Basic Physics Principles', 4, 1),
('CHEM101', 'Chemistry', 'Introduction to Chemistry', 4, 1);

PRINT 'AGM Solutions LMS Database Schema and Initial Data Created Successfully!';
PRINT 'Database: AGMSolutions';
PRINT 'Total Tables Created: 25';
PRINT 'Initial Roles: 3 (Student, Lecturer, Admin)';
PRINT 'Initial Subjects: 5';
PRINT 'Default Admin User: admin@agmsolutions.com (Password needs to be set)';
