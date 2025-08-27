using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web;
using AGMSolutions.App_Code.Models;

namespace AGMSolutions.App_Code.BLL
{
    public class ReportingManager
    {
        private string connectionString;

        public ReportingManager()
        {
            connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
        }

        // Get comprehensive dashboard statistics
        public DashboardStats GetDashboardStats(int? userId = null, string userRole = null)
        {
            DashboardStats stats = new DashboardStats();

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    if (userRole == "Admin")
                    {
                        stats = GetAdminDashboardStats(conn);
                    }
                    else if (userRole == "Lecturer" && userId.HasValue)
                    {
                        stats = GetLecturerDashboardStats(conn, userId.Value);
                    }
                    else if (userRole == "Student" && userId.HasValue)
                    {
                        stats = GetStudentDashboardStats(conn, userId.Value);
                    }
                }
            }
            catch (Exception ex)
            {
                LogActivity(userId, "Get Dashboard Stats Error", $"Error getting dashboard stats: {ex.Message}");
                throw new Exception("Error retrieving dashboard statistics. Please try again.");
            }

            return stats;
        }

        // Admin dashboard statistics
        private DashboardStats GetAdminDashboardStats(SqlConnection conn)
        {
            DashboardStats stats = new DashboardStats();

            // Total users by role
            string userStatsQuery = @"
                SELECT ut.RoleName, COUNT(u.UserID) as Count
                FROM Users u
                INNER JOIN UserTypes ut ON u.UserTypeID = ut.UserTypeID
                WHERE u.IsActive = 1
                GROUP BY ut.RoleName";

            SqlCommand cmd = new SqlCommand(userStatsQuery, conn);
            SqlDataReader reader = cmd.ExecuteReader();

            while (reader.Read())
            {
                string role = reader["RoleName"].ToString();
                int count = (int)reader["Count"];

                switch (role)
                {
                    case "Student":
                        stats.TotalStudents = count;
                        break;
                    case "Lecturer":
                        stats.TotalLecturers = count;
                        break;
                    case "Admin":
                        stats.TotalAdmins = count;
                        break;
                }
            }
            reader.Close();

            // Course statistics
            cmd.CommandText = "SELECT COUNT(*) FROM Courses WHERE IsActive = 1";
            stats.TotalCourses = (int)cmd.ExecuteScalar();

            cmd.CommandText = "SELECT COUNT(*) FROM Enrollments WHERE IsActive = 1";
            stats.TotalEnrollments = (int)cmd.ExecuteScalar();

            // Quiz statistics
            cmd.CommandText = "SELECT COUNT(*) FROM Quizzes WHERE IsActive = 1";
            stats.TotalQuizzes = (int)cmd.ExecuteScalar();

            cmd.CommandText = "SELECT COUNT(*) FROM QuizAttempts WHERE IsCompleted = 1";
            stats.TotalQuizAttempts = (int)cmd.ExecuteScalar();

            // Assignment statistics
            cmd.CommandText = "SELECT COUNT(*) FROM Assignments WHERE IsActive = 1";
            stats.TotalAssignments = (int)cmd.ExecuteScalar();

            cmd.CommandText = "SELECT COUNT(*) FROM AssignmentSubmissions";
            stats.TotalAssignmentSubmissions = (int)cmd.ExecuteScalar();

            // Activity in last 7 days
            cmd.CommandText = @"
                SELECT COUNT(*) FROM ActivityLogs 
                WHERE ActivityDate >= DATEADD(day, -7, GETDATE())";
            stats.ActivityLast7Days = (int)cmd.ExecuteScalar();

            // Recent activity trends (last 30 days by day)
            cmd.CommandText = @"
                SELECT CAST(ActivityDate AS DATE) as ActivityDay, COUNT(*) as Count
                FROM ActivityLogs 
                WHERE ActivityDate >= DATEADD(day, -30, GETDATE())
                GROUP BY CAST(ActivityDate AS DATE)
                ORDER BY ActivityDay";

            reader = cmd.ExecuteReader();
            stats.ActivityTrends = new Dictionary<DateTime, int>();

            while (reader.Read())
            {
                DateTime day = (DateTime)reader["ActivityDay"];
                int count = (int)reader["Count"];
                stats.ActivityTrends[day] = count;
            }
            reader.Close();

            return stats;
        }

        // Lecturer dashboard statistics
        private DashboardStats GetLecturerDashboardStats(SqlConnection conn, int lecturerId)
        {
            DashboardStats stats = new DashboardStats();

            // Courses taught
            string coursesQuery = "SELECT COUNT(*) FROM Courses WHERE LecturerID = @LecturerID AND IsActive = 1";
            SqlCommand cmd = new SqlCommand(coursesQuery, conn);
            cmd.Parameters.AddWithValue("@LecturerID", lecturerId);
            stats.TotalCourses = (int)cmd.ExecuteScalar();

            // Students in lecturer's courses
            cmd.CommandText = @"
                SELECT COUNT(DISTINCT e.StudentID) 
                FROM Enrollments e 
                INNER JOIN Courses c ON e.CourseID = c.CourseID 
                WHERE c.LecturerID = @LecturerID AND e.IsActive = 1 AND c.IsActive = 1";
            stats.TotalStudents = (int)cmd.ExecuteScalar();

            // Quizzes created
            cmd.CommandText = @"
                SELECT COUNT(*) FROM Quizzes q 
                INNER JOIN Courses c ON q.CourseID = c.CourseID 
                WHERE c.LecturerID = @LecturerID AND q.IsActive = 1";
            stats.TotalQuizzes = (int)cmd.ExecuteScalar();

            // Assignments created
            cmd.CommandText = @"
                SELECT COUNT(*) FROM Assignments a 
                INNER JOIN Courses c ON a.CourseID = c.CourseID 
                WHERE c.LecturerID = @LecturerID AND a.IsActive = 1";
            stats.TotalAssignments = (int)cmd.ExecuteScalar();

            // Pending grading (assignments and quizzes)
            cmd.CommandText = @"
                SELECT COUNT(*) FROM AssignmentSubmissions asub
                INNER JOIN Assignments a ON asub.AssignmentID = a.AssignmentID
                INNER JOIN Courses c ON a.CourseID = c.CourseID
                WHERE c.LecturerID = @LecturerID AND asub.Grade IS NULL";
            stats.PendingGrading = (int)cmd.ExecuteScalar();

            // Recent activity in lecturer's courses
            cmd.CommandText = @"
                SELECT COUNT(*) FROM ActivityLogs al
                WHERE al.ActivityDate >= DATEADD(day, -7, GETDATE())
                AND al.UserID IN (
                    SELECT DISTINCT e.StudentID 
                    FROM Enrollments e 
                    INNER JOIN Courses c ON e.CourseID = c.CourseID 
                    WHERE c.LecturerID = @LecturerID AND e.IsActive = 1
                )";
            stats.ActivityLast7Days = (int)cmd.ExecuteScalar();

            return stats;
        }

        // Student dashboard statistics
        private DashboardStats GetStudentDashboardStats(SqlConnection conn, int studentId)
        {
            DashboardStats stats = new DashboardStats();

            // Enrolled courses
            string enrolledQuery = @"
                SELECT COUNT(*) FROM Enrollments 
                WHERE StudentID = @StudentID AND IsActive = 1";
            SqlCommand cmd = new SqlCommand(enrolledQuery, conn);
            cmd.Parameters.AddWithValue("@StudentID", studentId);
            stats.TotalCourses = (int)cmd.ExecuteScalar();

            // Completed quizzes
            cmd.CommandText = @"
                SELECT COUNT(DISTINCT qa.QuizID) FROM QuizAttempts qa
                INNER JOIN Quizzes q ON qa.QuizID = q.QuizID
                INNER JOIN Courses c ON q.CourseID = c.CourseID
                INNER JOIN Enrollments e ON c.CourseID = e.CourseID
                WHERE e.StudentID = @StudentID AND qa.IsCompleted = 1 AND e.IsActive = 1";
            stats.CompletedQuizzes = (int)cmd.ExecuteScalar();

            // Total quiz attempts
            cmd.CommandText = @"
                SELECT COUNT(*) FROM QuizAttempts qa
                INNER JOIN Quizzes q ON qa.QuizID = q.QuizID
                INNER JOIN Courses c ON q.CourseID = c.CourseID
                INNER JOIN Enrollments e ON c.CourseID = e.CourseID
                WHERE e.StudentID = @StudentID AND qa.IsCompleted = 1 AND e.IsActive = 1";
            stats.TotalQuizAttempts = (int)cmd.ExecuteScalar();

            // Submitted assignments
            cmd.CommandText = @"
                SELECT COUNT(*) FROM AssignmentSubmissions asub
                INNER JOIN Assignments a ON asub.AssignmentID = a.AssignmentID
                INNER JOIN Courses c ON a.CourseID = c.CourseID
                INNER JOIN Enrollments e ON c.CourseID = e.CourseID
                WHERE e.StudentID = @StudentID AND e.IsActive = 1";
            stats.TotalAssignmentSubmissions = (int)cmd.ExecuteScalar();

            // Pending assignments
            cmd.CommandText = @"
                SELECT COUNT(*) FROM Assignments a
                INNER JOIN Courses c ON a.CourseID = c.CourseID
                INNER JOIN Enrollments e ON c.CourseID = e.CourseID
                WHERE e.StudentID = @StudentID AND e.IsActive = 1 AND a.IsActive = 1
                AND a.AssignmentID NOT IN (
                    SELECT AssignmentID FROM AssignmentSubmissions 
                    WHERE StudentID = @StudentID
                )";
            stats.PendingAssignments = (int)cmd.ExecuteScalar();

            // Average grade
            cmd.CommandText = @"
                SELECT AVG(CAST(Percentage AS DECIMAL(5,2))) FROM Grades 
                WHERE StudentID = @StudentID";
            object avgGrade = cmd.ExecuteScalar();
            stats.AverageGrade = avgGrade != DBNull.Value ? (decimal?)avgGrade : null;

            return stats;
        }

        // Get student performance report
        public StudentPerformanceReport GetStudentPerformanceReport(int studentId, int? courseId = null)
        {
            StudentPerformanceReport report = new StudentPerformanceReport();

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Student basic info
                    string studentQuery = @"
                        SELECT u.FirstName, u.LastName, u.Email, u.DateCreated,
                               ut.RoleName
                        FROM Users u
                        INNER JOIN UserTypes ut ON u.UserTypeID = ut.UserTypeID
                        WHERE u.UserID = @StudentID";

                    SqlCommand cmd = new SqlCommand(studentQuery, conn);
                    cmd.Parameters.AddWithValue("@StudentID", studentId);

                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        report.StudentName = $"{reader["FirstName"]} {reader["LastName"]}";
                        report.StudentEmail = reader["Email"].ToString();
                        report.EnrollmentDate = (DateTime)reader["DateCreated"];
                    }
                    reader.Close();

                    // Course performance
                    string coursePerformanceQuery = @"
                        SELECT c.CourseID, c.CourseName, c.CourseCode,
                               AVG(CAST(g.Percentage AS DECIMAL(5,2))) as AverageGrade,
                               COUNT(DISTINCT qa.QuizID) as QuizzesCompleted,
                               COUNT(DISTINCT asub.AssignmentID) as AssignmentsSubmitted,
                               COUNT(DISTINCT att.AttendanceID) as AttendanceCount
                        FROM Courses c
                        INNER JOIN Enrollments e ON c.CourseID = e.CourseID
                        LEFT JOIN Grades g ON c.CourseID = g.CourseID AND g.StudentID = @StudentID
                        LEFT JOIN QuizAttempts qa ON qa.StudentID = @StudentID 
                            AND qa.QuizID IN (SELECT QuizID FROM Quizzes WHERE CourseID = c.CourseID)
                            AND qa.IsCompleted = 1
                        LEFT JOIN AssignmentSubmissions asub ON asub.StudentID = @StudentID
                            AND asub.AssignmentID IN (SELECT AssignmentID FROM Assignments WHERE CourseID = c.CourseID)
                        LEFT JOIN Attendance att ON att.StudentID = @StudentID 
                            AND att.CourseID = c.CourseID
                        WHERE e.StudentID = @StudentID AND e.IsActive = 1";

                    if (courseId.HasValue)
                    {
                        coursePerformanceQuery += " AND c.CourseID = @CourseID";
                    }

                    coursePerformanceQuery += @"
                        GROUP BY c.CourseID, c.CourseName, c.CourseCode
                        ORDER BY c.CourseName";

                    cmd.CommandText = coursePerformanceQuery;
                    if (courseId.HasValue)
                    {
                        cmd.Parameters.AddWithValue("@CourseID", courseId.Value);
                    }

                    reader = cmd.ExecuteReader();
                    report.CoursePerformances = new List<CoursePerformance>();

                    while (reader.Read())
                    {
                        CoursePerformance performance = new CoursePerformance
                        {
                            CourseID = (int)reader["CourseID"],
                            CourseName = reader["CourseName"].ToString(),
                            CourseCode = reader["CourseCode"].ToString(),
                            AverageGrade = reader["AverageGrade"] as decimal?,
                            QuizzesCompleted = reader["QuizzesCompleted"] as int? ?? 0,
                            AssignmentsSubmitted = reader["AssignmentsSubmitted"] as int? ?? 0,
                            AttendanceCount = reader["AttendanceCount"] as int? ?? 0
                        };

                        report.CoursePerformances.Add(performance);
                    }
                    reader.Close();

                    // Recent quiz scores
                    cmd.CommandText = @"
                        SELECT TOP 10 q.Title, qa.Score, qa.TotalMarks, qa.Percentage, 
                               qa.SubmissionDate, c.CourseName
                        FROM QuizAttempts qa
                        INNER JOIN Quizzes q ON qa.QuizID = q.QuizID
                        INNER JOIN Courses c ON q.CourseID = c.CourseID
                        WHERE qa.StudentID = @StudentID AND qa.IsCompleted = 1
                        ORDER BY qa.SubmissionDate DESC";

                    reader = cmd.ExecuteReader();
                    report.RecentQuizScores = new List<QuizScore>();

                    while (reader.Read())
                    {
                        QuizScore score = new QuizScore
                        {
                            QuizTitle = reader["Title"].ToString(),
                            Score = reader["Score"] as int? ?? 0,
                            TotalMarks = reader["TotalMarks"] as int? ?? 0,
                            Percentage = reader["Percentage"] as decimal? ?? 0,
                            CompletionDate = reader["SubmissionDate"] as DateTime?,
                            CourseName = reader["CourseName"].ToString()
                        };

                        report.RecentQuizScores.Add(score);
                    }
                    reader.Close();

                    // Assignment grades
                    cmd.CommandText = @"
                        SELECT TOP 10 a.Title, asub.Grade, a.MaxGrade, asub.GradeDate, 
                               c.CourseName, asub.Feedback
                        FROM AssignmentSubmissions asub
                        INNER JOIN Assignments a ON asub.AssignmentID = a.AssignmentID
                        INNER JOIN Courses c ON a.CourseID = c.CourseID
                        WHERE asub.StudentID = @StudentID AND asub.Grade IS NOT NULL
                        ORDER BY asub.GradeDate DESC";

                    reader = cmd.ExecuteReader();
                    report.RecentAssignmentGrades = new List<AssignmentGrade>();

                    while (reader.Read())
                    {
                        AssignmentGrade grade = new AssignmentGrade
                        {
                            AssignmentTitle = reader["Title"].ToString(),
                            Grade = reader["Grade"] as decimal? ?? 0,
                            MaxGrade = reader["MaxGrade"] as int? ?? 100,
                            GradeDate = reader["GradeDate"] as DateTime?,
                            CourseName = reader["CourseName"].ToString(),
                            Feedback = reader["Feedback"]?.ToString()
                        };

                        report.RecentAssignmentGrades.Add(grade);
                    }
                    reader.Close();
                }
            }
            catch (Exception ex)
            {
                LogActivity(studentId, "Get Performance Report Error", $"Error getting performance report: {ex.Message}");
                throw new Exception("Error generating performance report. Please try again.");
            }

            return report;
        }

        // Get course analytics for lecturer
        public CourseAnalytics GetCourseAnalytics(int courseId, int lecturerId)
        {
            CourseAnalytics analytics = new CourseAnalytics();

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Verify lecturer access to course
                    string accessQuery = "SELECT COUNT(*) FROM Courses WHERE CourseID = @CourseID AND LecturerID = @LecturerID";
                    SqlCommand cmd = new SqlCommand(accessQuery, conn);
                    cmd.Parameters.AddWithValue("@CourseID", courseId);
                    cmd.Parameters.AddWithValue("@LecturerID", lecturerId);

                    if ((int)cmd.ExecuteScalar() == 0)
                    {
                        throw new UnauthorizedAccessException("You don't have access to this course.");
                    }

                    // Course basic info
                    cmd.CommandText = @"
                        SELECT CourseName, CourseCode, Description, Credits, 
                               (SELECT COUNT(*) FROM Enrollments WHERE CourseID = @CourseID AND IsActive = 1) as EnrolledStudents
                        FROM Courses WHERE CourseID = @CourseID";

                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        analytics.CourseName = reader["CourseName"].ToString();
                        analytics.CourseCode = reader["CourseCode"].ToString();
                        analytics.Description = reader["Description"]?.ToString();
                        analytics.Credits = reader["Credits"] as int? ?? 0;
                        analytics.EnrolledStudents = reader["EnrolledStudents"] as int? ?? 0;
                    }
                    reader.Close();

                    // Quiz analytics
                    cmd.CommandText = @"
                        SELECT q.QuizID, q.Title, 
                               COUNT(qa.AttemptID) as TotalAttempts,
                               COUNT(CASE WHEN qa.IsCompleted = 1 THEN 1 END) as CompletedAttempts,
                               AVG(CASE WHEN qa.IsCompleted = 1 THEN CAST(qa.Percentage AS DECIMAL(5,2)) END) as AverageScore
                        FROM Quizzes q
                        LEFT JOIN QuizAttempts qa ON q.QuizID = qa.QuizID
                        WHERE q.CourseID = @CourseID AND q.IsActive = 1
                        GROUP BY q.QuizID, q.Title
                        ORDER BY q.Title";

                    reader = cmd.ExecuteReader();
                    analytics.QuizAnalytics = new List<QuizAnalytic>();

                    while (reader.Read())
                    {
                        QuizAnalytic quizAnalytic = new QuizAnalytic
                        {
                            QuizID = (int)reader["QuizID"],
                            QuizTitle = reader["Title"].ToString(),
                            TotalAttempts = reader["TotalAttempts"] as int? ?? 0,
                            CompletedAttempts = reader["CompletedAttempts"] as int? ?? 0,
                            AverageScore = reader["AverageScore"] as decimal? ?? 0
                        };

                        analytics.QuizAnalytics.Add(quizAnalytic);
                    }
                    reader.Close();

                    // Assignment analytics
                    cmd.CommandText = @"
                        SELECT a.AssignmentID, a.Title,
                               COUNT(asub.SubmissionID) as TotalSubmissions,
                               COUNT(CASE WHEN asub.Grade IS NOT NULL THEN 1 END) as GradedSubmissions,
                               AVG(CASE WHEN asub.Grade IS NOT NULL THEN asub.Grade END) as AverageGrade
                        FROM Assignments a
                        LEFT JOIN AssignmentSubmissions asub ON a.AssignmentID = asub.AssignmentID
                        WHERE a.CourseID = @CourseID AND a.IsActive = 1
                        GROUP BY a.AssignmentID, a.Title
                        ORDER BY a.Title";

                    reader = cmd.ExecuteReader();
                    analytics.AssignmentAnalytics = new List<AssignmentAnalytic>();

                    while (reader.Read())
                    {
                        AssignmentAnalytic assignmentAnalytic = new AssignmentAnalytic
                        {
                            AssignmentID = (int)reader["AssignmentID"],
                            AssignmentTitle = reader["Title"].ToString(),
                            TotalSubmissions = reader["TotalSubmissions"] as int? ?? 0,
                            GradedSubmissions = reader["GradedSubmissions"] as int? ?? 0,
                            AverageGrade = reader["AverageGrade"] as decimal? ?? 0
                        };

                        analytics.AssignmentAnalytics.Add(assignmentAnalytic);
                    }
                    reader.Close();

                    // Student performance overview
                    cmd.CommandText = @"
                        SELECT u.UserID, u.FirstName + ' ' + u.LastName as StudentName,
                               AVG(CASE WHEN g.Percentage IS NOT NULL THEN CAST(g.Percentage AS DECIMAL(5,2)) END) as AverageGrade,
                               COUNT(DISTINCT qa.QuizID) as QuizzesCompleted,
                               COUNT(DISTINCT asub.AssignmentID) as AssignmentsSubmitted
                        FROM Users u
                        INNER JOIN Enrollments e ON u.UserID = e.StudentID
                        LEFT JOIN Grades g ON u.UserID = g.StudentID AND g.CourseID = @CourseID
                        LEFT JOIN QuizAttempts qa ON u.UserID = qa.StudentID 
                            AND qa.QuizID IN (SELECT QuizID FROM Quizzes WHERE CourseID = @CourseID)
                            AND qa.IsCompleted = 1
                        LEFT JOIN AssignmentSubmissions asub ON u.UserID = asub.StudentID
                            AND asub.AssignmentID IN (SELECT AssignmentID FROM Assignments WHERE CourseID = @CourseID)
                        WHERE e.CourseID = @CourseID AND e.IsActive = 1
                        GROUP BY u.UserID, u.FirstName, u.LastName
                        ORDER BY AverageGrade DESC";

                    reader = cmd.ExecuteReader();
                    analytics.StudentPerformances = new List<StudentPerformanceOverview>();

                    while (reader.Read())
                    {
                        StudentPerformanceOverview performance = new StudentPerformanceOverview
                        {
                            StudentID = (int)reader["UserID"],
                            StudentName = reader["StudentName"].ToString(),
                            AverageGrade = reader["AverageGrade"] as decimal?,
                            QuizzesCompleted = reader["QuizzesCompleted"] as int? ?? 0,
                            AssignmentsSubmitted = reader["AssignmentsSubmitted"] as int? ?? 0
                        };

                        analytics.StudentPerformances.Add(performance);
                    }
                    reader.Close();
                }
            }
            catch (Exception ex)
            {
                LogActivity(lecturerId, "Get Course Analytics Error", $"Error getting course analytics: {ex.Message}");
                throw;
            }

            return analytics;
        }

        // Get system usage statistics
        public SystemUsageStats GetSystemUsageStats(DateTime startDate, DateTime endDate)
        {
            SystemUsageStats stats = new SystemUsageStats();

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Daily activity counts
                    string dailyActivityQuery = @"
                        SELECT CAST(ActivityDate AS DATE) as ActivityDay, COUNT(*) as ActivityCount
                        FROM ActivityLogs 
                        WHERE ActivityDate >= @StartDate AND ActivityDate <= @EndDate
                        GROUP BY CAST(ActivityDate AS DATE)
                        ORDER BY ActivityDay";

                    SqlCommand cmd = new SqlCommand(dailyActivityQuery, conn);
                    cmd.Parameters.AddWithValue("@StartDate", startDate);
                    cmd.Parameters.AddWithValue("@EndDate", endDate);

                    SqlDataReader reader = cmd.ExecuteReader();
                    stats.DailyActivityCounts = new Dictionary<DateTime, int>();

                    while (reader.Read())
                    {
                        DateTime day = (DateTime)reader["ActivityDay"];
                        int count = (int)reader["ActivityCount"];
                        stats.DailyActivityCounts[day] = count;
                    }
                    reader.Close();

                    // Activity by type
                    cmd.CommandText = @"
                        SELECT Activity, COUNT(*) as Count
                        FROM ActivityLogs 
                        WHERE ActivityDate >= @StartDate AND ActivityDate <= @EndDate
                        GROUP BY Activity
                        ORDER BY Count DESC";

                    reader = cmd.ExecuteReader();
                    stats.ActivityByType = new Dictionary<string, int>();

                    while (reader.Read())
                    {
                        string activity = reader["Activity"].ToString();
                        int count = (int)reader["Count"];
                        stats.ActivityByType[activity] = count;
                    }
                    reader.Close();

                    // User activity
                    cmd.CommandText = @"
                        SELECT u.FirstName + ' ' + u.LastName as UserName, 
                               ut.RoleName, COUNT(al.ActivityID) as ActivityCount
                        FROM ActivityLogs al
                        INNER JOIN Users u ON al.UserID = u.UserID
                        INNER JOIN UserTypes ut ON u.UserTypeID = ut.UserTypeID
                        WHERE al.ActivityDate >= @StartDate AND al.ActivityDate <= @EndDate
                        GROUP BY u.UserID, u.FirstName, u.LastName, ut.RoleName
                        ORDER BY ActivityCount DESC";

                    reader = cmd.ExecuteReader();
                    stats.UserActivity = new List<UserActivityStat>();

                    while (reader.Read())
                    {
                        UserActivityStat userStat = new UserActivityStat
                        {
                            UserName = reader["UserName"].ToString(),
                            UserRole = reader["RoleName"].ToString(),
                            ActivityCount = (int)reader["ActivityCount"]
                        };

                        stats.UserActivity.Add(userStat);
                    }
                    reader.Close();
                }
            }
            catch (Exception ex)
            {
                LogActivity(null, "Get Usage Stats Error", $"Error getting usage statistics: {ex.Message}");
                throw new Exception("Error retrieving usage statistics. Please try again.");
            }

            return stats;
        }

        // Private helper method
        private void LogActivity(int? userId, string activity, string details)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        INSERT INTO ActivityLogs (UserID, Activity, Details, IPAddress, UserAgent, ActivityDate)
                        VALUES (@UserID, @Activity, @Details, @IPAddress, @UserAgent, @ActivityDate)";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@UserID", (object)userId ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Activity", activity);
                    cmd.Parameters.AddWithValue("@Details", details);
                    cmd.Parameters.AddWithValue("@IPAddress", GetClientIP());
                    cmd.Parameters.AddWithValue("@UserAgent", GetUserAgent());
                    cmd.Parameters.AddWithValue("@ActivityDate", DateTime.Now);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch
            {
                // Silent fail for logging
            }
        }

        private string GetClientIP()
        {
            try
            {
                return HttpContext.Current?.Request?.UserHostAddress ?? "Unknown";
            }
            catch { return "Unknown"; }
        }

        private string GetUserAgent()
        {
            try
            {
                return HttpContext.Current?.Request?.UserAgent ?? "Unknown";
            }
            catch { return "Unknown"; }
        }
    }

    // Supporting classes for reporting
    public class DashboardStats
    {
        public int TotalStudents { get; set; }
        public int TotalLecturers { get; set; }
        public int TotalAdmins { get; set; }
        public int TotalCourses { get; set; }
        public int TotalEnrollments { get; set; }
        public int TotalQuizzes { get; set; }
        public int TotalQuizAttempts { get; set; }
        public int TotalAssignments { get; set; }
        public int TotalAssignmentSubmissions { get; set; }
        public int ActivityLast7Days { get; set; }
        public int PendingGrading { get; set; }
        public int PendingAssignments { get; set; }
        public int CompletedQuizzes { get; set; }
        public decimal? AverageGrade { get; set; }
        public Dictionary<DateTime, int> ActivityTrends { get; set; }
    }

    public class StudentPerformanceReport
    {
        public string StudentName { get; set; }
        public string StudentEmail { get; set; }
        public DateTime EnrollmentDate { get; set; }
        public List<CoursePerformance> CoursePerformances { get; set; }
        public List<QuizScore> RecentQuizScores { get; set; }
        public List<AssignmentGrade> RecentAssignmentGrades { get; set; }
    }

    public class CoursePerformance
    {
        public int CourseID { get; set; }
        public string CourseName { get; set; }
        public string CourseCode { get; set; }
        public decimal? AverageGrade { get; set; }
        public int QuizzesCompleted { get; set; }
        public int AssignmentsSubmitted { get; set; }
        public int AttendanceCount { get; set; }
    }

    public class QuizScore
    {
        public string QuizTitle { get; set; }
        public int Score { get; set; }
        public int TotalMarks { get; set; }
        public decimal Percentage { get; set; }
        public DateTime? CompletionDate { get; set; }
        public string CourseName { get; set; }
    }

    public class AssignmentGrade
    {
        public string AssignmentTitle { get; set; }
        public decimal Grade { get; set; }
        public int MaxGrade { get; set; }
        public DateTime? GradeDate { get; set; }
        public string CourseName { get; set; }
        public string Feedback { get; set; }
    }

    public class CourseAnalytics
    {
        public string CourseName { get; set; }
        public string CourseCode { get; set; }
        public string Description { get; set; }
        public int Credits { get; set; }
        public int EnrolledStudents { get; set; }
        public List<QuizAnalytic> QuizAnalytics { get; set; }
        public List<AssignmentAnalytic> AssignmentAnalytics { get; set; }
        public List<StudentPerformanceOverview> StudentPerformances { get; set; }
    }

    public class QuizAnalytic
    {
        public int QuizID { get; set; }
        public string QuizTitle { get; set; }
        public int TotalAttempts { get; set; }
        public int CompletedAttempts { get; set; }
        public decimal AverageScore { get; set; }
    }

    public class AssignmentAnalytic
    {
        public int AssignmentID { get; set; }
        public string AssignmentTitle { get; set; }
        public int TotalSubmissions { get; set; }
        public int GradedSubmissions { get; set; }
        public decimal AverageGrade { get; set; }
    }

    public class StudentPerformanceOverview
    {
        public int StudentID { get; set; }
        public string StudentName { get; set; }
        public decimal? AverageGrade { get; set; }
        public int QuizzesCompleted { get; set; }
        public int AssignmentsSubmitted { get; set; }
    }

    public class SystemUsageStats
    {
        public Dictionary<DateTime, int> DailyActivityCounts { get; set; }
        public Dictionary<string, int> ActivityByType { get; set; }
        public List<UserActivityStat> UserActivity { get; set; }
    }

    public class UserActivityStat
    {
        public string UserName { get; set; }
        public string UserRole { get; set; }
        public int ActivityCount { get; set; }
    }
}
