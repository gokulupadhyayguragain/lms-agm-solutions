using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;
using System.Text;
using iTextSharp.text;
using iTextSharp.text.pdf;
using iTextSharp.text.html.simpleparser;

/// <summary>
/// PDF Report Generation Manager for AGM Solutions LMS
/// Generates academic reports, certificates, and transcripts
/// </summary>
public class PdfReportManager
{
    private static readonly string ConnectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
    
    #region Academic Reports

    /// <summary>
    /// Generate comprehensive student academic report
    /// </summary>
    public static PdfResult GenerateStudentReport(int studentId, string reportType = "comprehensive")
    {
        try
        {
            var studentData = GetStudentData(studentId);
            if (studentData == null)
                return new PdfResult { Success = false, Message = "Student not found." };

            var reportData = GetStudentReportData(studentId);
            string fileName = $"Student_Report_{studentData.StudentName.Replace(" ", "_")}_{DateTime.Now:yyyyMMdd}.pdf";
            string fullPath = Path.Combine(HttpContext.Current.Server.MapPath("~/Reports/"), fileName);

            // Ensure directory exists
            Directory.CreateDirectory(Path.GetDirectoryName(fullPath));

            using (var document = new Document(PageSize.A4, 40, 40, 60, 60))
            {
                using (var writer = PdfWriter.GetInstance(document, new FileStream(fullPath, FileMode.Create)))
                {
                    document.Open();

                    // Add header
                    AddReportHeader(document, "ACADEMIC PERFORMANCE REPORT", studentData);

                    // Add student information
                    AddStudentInformation(document, studentData);

                    // Add academic performance summary
                    AddAcademicSummary(document, reportData);

                    // Add course details
                    AddCourseDetails(document, reportData.Courses);

                    // Add quiz performance
                    AddQuizPerformance(document, reportData.QuizResults);

                    // Add assignment performance
                    AddAssignmentPerformance(document, reportData.AssignmentResults);

                    // Add recommendations
                    AddRecommendations(document, reportData);

                    // Add footer
                    AddReportFooter(document);

                    document.Close();
                }
            }

            return new PdfResult 
            { 
                Success = true, 
                Message = "Report generated successfully.",
                FileName = fileName,
                FilePath = fullPath
            };
        }
        catch (Exception ex)
        {
            return new PdfResult { Success = false, Message = $"Report generation failed: {ex.Message}" };
        }
    }

    /// <summary>
    /// Generate course performance report for lecturers
    /// </summary>
    public static PdfResult GenerateCourseReport(int courseId, int lecturerId)
    {
        try
        {
            var courseData = GetCourseData(courseId);
            if (courseData == null)
                return new PdfResult { Success = false, Message = "Course not found." };

            var reportData = GetCourseReportData(courseId);
            string fileName = $"Course_Report_{((dynamic)courseData).CourseCode}_{DateTime.Now:yyyyMMdd}.pdf";
            string fullPath = Path.Combine(HttpContext.Current.Server.MapPath("~/Reports/"), fileName);

            Directory.CreateDirectory(Path.GetDirectoryName(fullPath));

            using (var document = new Document(PageSize.A4, 40, 40, 60, 60))
            {
                using (var writer = PdfWriter.GetInstance(document, new FileStream(fullPath, FileMode.Create)))
                {
                    document.Open();

                    // Add header
                    AddReportHeader(document, "COURSE PERFORMANCE REPORT", null, null);

                    // Add course information
                    AddCourseInformation(document, courseData);

                    // Add enrollment statistics
                    AddEnrollmentStatistics(document, reportData);

                    // Add performance analytics
                    AddPerformanceAnalytics(document, reportData);

                    // Add student list with grades
                    AddStudentGradesList(document, ((dynamic)reportData).StudentGrades);

                    // Add recommendations for improvement
                    AddCourseRecommendations(document, reportData);

                    AddReportFooter(document);
                    document.Close();
                }
            }

            return new PdfResult 
            { 
                Success = true, 
                Message = "Course report generated successfully.",
                FileName = fileName,
                FilePath = fullPath
            };
        }
        catch (Exception ex)
        {
            return new PdfResult { Success = false, Message = $"Course report generation failed: {ex.Message}" };
        }
    }

    /// <summary>
    /// Generate official transcript
    /// </summary>
    public static PdfResult GenerateTranscript(int studentId)
    {
        try
        {
            var studentData = GetStudentData(studentId);
            if (studentData == null)
                return new PdfResult { Success = false, Message = "Student not found." };

            var transcriptData = GetTranscriptData(studentId);
            string fileName = $"Official_Transcript_{studentData.StudentName.Replace(" ", "_")}_{DateTime.Now:yyyyMMdd}.pdf";
            string fullPath = Path.Combine(HttpContext.Current.Server.MapPath("~/Reports/"), fileName);

            Directory.CreateDirectory(Path.GetDirectoryName(fullPath));

            using (var document = new Document(PageSize.A4, 40, 40, 60, 60))
            {
                using (var writer = PdfWriter.GetInstance(document, new FileStream(fullPath, FileMode.Create)))
                {
                    document.Open();

                    // Add official header with watermark
                    AddOfficialHeader(document, "OFFICIAL ACADEMIC TRANSCRIPT");

                    // Add student information
                    AddStudentInformation(document, studentData, true);

                    // Add academic record
                    AddAcademicRecord(document, transcriptData);

                    // Add GPA calculation
                    AddGPACalculation(document, transcriptData);

                    // Add official footer with signature
                    AddOfficialFooter(document, transcriptData);

                    document.Close();
                }
            }

            return new PdfResult 
            { 
                Success = true, 
                Message = "Official transcript generated successfully.",
                FileName = fileName,
                FilePath = fullPath
            };
        }
        catch (Exception ex)
        {
            return new PdfResult { Success = false, Message = $"Transcript generation failed: {ex.Message}" };
        }
    }

    #endregion

    #region PDF Content Methods

    private static void AddReportHeader(Document document, string reportTitle, StudentData student = null, CourseData course = null)
    {
        // University/Institution Header
        var headerTable = new PdfPTable(2) { WidthPercentage = 100 };
        headerTable.SetWidths(new float[] { 1, 3 });

        // Logo placeholder
        var logoCell = new PdfPCell(new Phrase("🎓", new Font(Font.FontFamily.HELVETICA, 24)))
        {
            Border = Rectangle.NO_BORDER,
            HorizontalAlignment = Element.ALIGN_CENTER,
            VerticalAlignment = Element.ALIGN_MIDDLE
        };
        headerTable.AddCell(logoCell);

        // Institution info
        var institutionInfo = new StringBuilder();
        institutionInfo.AppendLine("AGM SOLUTIONS");
        institutionInfo.AppendLine("Learning Management System");
        institutionInfo.AppendLine("Excellence in Education");

        var infoCell = new PdfPCell(new Phrase(institutionInfo.ToString(), new Font(Font.FontFamily.HELVETICA, 12)))
        {
            Border = Rectangle.NO_BORDER,
            HorizontalAlignment = Element.ALIGN_LEFT
        };
        headerTable.AddCell(infoCell);

        document.Add(headerTable);
        document.Add(new Paragraph(" "));

        // Report title
        var titleFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD);
        var title = new Paragraph(reportTitle, titleFont)
        {
            Alignment = Element.ALIGN_CENTER,
            SpacingAfter = 20
        };
        document.Add(title);

        // Report metadata
        var metadataTable = new PdfPTable(2) { WidthPercentage = 100 };
        metadataTable.AddCell(new PdfPCell(new Phrase("Generated Date:", FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 10))) { Border = Rectangle.NO_BORDER });
        metadataTable.AddCell(new PdfPCell(new Phrase(DateTime.Now.ToString("MMMM dd, yyyy"), FontFactory.GetFont(FontFactory.HELVETICA, 10))) { Border = Rectangle.NO_BORDER });
        
        if (student != null)
        {
            metadataTable.AddCell(new PdfPCell(new Phrase("Student:", FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 10))) { Border = Rectangle.NO_BORDER });
            metadataTable.AddCell(new PdfPCell(new Phrase(student.StudentName, FontFactory.GetFont(FontFactory.HELVETICA, 10))) { Border = Rectangle.NO_BORDER });
        }

        if (course != null)
        {
            metadataTable.AddCell(new PdfPCell(new Phrase("Course:", FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 10))) { Border = Rectangle.NO_BORDER });
            metadataTable.AddCell(new PdfPCell(new Phrase($"{course.CourseCode} - {course.CourseName}", FontFactory.GetFont(FontFactory.HELVETICA, 10))) { Border = Rectangle.NO_BORDER });
        }

        document.Add(metadataTable);
        document.Add(new Paragraph(" "));
        document.Add(new Paragraph("_______________________________________________________"));
        document.Add(new Paragraph(" "));
    }

    private static void AddStudentInformation(Document document, StudentData student, bool isOfficial = false)
    {
        var sectionTitle = new Paragraph("STUDENT INFORMATION", FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 14))
        {
            SpacingBefore = 10,
            SpacingAfter = 10
        };
        document.Add(sectionTitle);

        var infoTable = new PdfPTable(2) { WidthPercentage = 100 };
        infoTable.SetWidths(new float[] { 1, 2 });

        AddTableRow(infoTable, "Full Name:", student.StudentName);
        AddTableRow(infoTable, "Student ID:", student.StudentID.ToString());
        AddTableRow(infoTable, "Email Address:", student.Email);
        AddTableRow(infoTable, "Enrollment Date:", student.EnrollmentDate?.ToString("MMMM dd, yyyy") ?? "N/A");
        
        if (isOfficial)
        {
            AddTableRow(infoTable, "Date of Birth:", student.DateOfBirth?.ToString("MMMM dd, yyyy") ?? "N/A");
            AddTableRow(infoTable, "Student Status:", student.Status ?? "Active");
        }

        document.Add(infoTable);
        document.Add(new Paragraph(" "));
    }

    private static void AddAcademicSummary(Document document, StudentReportData reportData)
    {
        var sectionTitle = new Paragraph("ACADEMIC SUMMARY", FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 14))
        {
            SpacingBefore = 10,
            SpacingAfter = 10
        };
        document.Add(sectionTitle);

        var summaryTable = new PdfPTable(2) { WidthPercentage = 100 };

        AddTableRow(summaryTable, "Total Courses Enrolled:", reportData.TotalCourses.ToString());
        AddTableRow(summaryTable, "Courses Completed:", reportData.CompletedCourses.ToString());
        AddTableRow(summaryTable, "Overall GPA:", reportData.OverallGPA.ToString("F2"));
        AddTableRow(summaryTable, "Total Credits Earned:", reportData.TotalCredits.ToString());
        AddTableRow(summaryTable, "Quizzes Attempted:", reportData.TotalQuizzes.ToString());
        AddTableRow(summaryTable, "Average Quiz Score:", $"{reportData.AverageQuizScore:F1}%");
        AddTableRow(summaryTable, "Assignments Submitted:", reportData.TotalAssignments.ToString());
        AddTableRow(summaryTable, "Average Assignment Score:", $"{reportData.AverageAssignmentScore:F1}%");

        document.Add(summaryTable);
        document.Add(new Paragraph(" "));
    }

    private static void AddQuizPerformance(Document document, List<QuizResult> quizResults)
    {
        if (quizResults == null || !quizResults.Any()) return;

        var sectionTitle = new Paragraph("QUIZ PERFORMANCE", FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 14))
        {
            SpacingBefore = 10,
            SpacingAfter = 10
        };
        document.Add(sectionTitle);

        var quizTable = new PdfPTable(5) { WidthPercentage = 100 };
        quizTable.SetWidths(new float[] { 3, 2, 1, 1, 1 });

        // Header
        AddTableHeaderCell(quizTable, "Quiz Title");
        AddTableHeaderCell(quizTable, "Course");
        AddTableHeaderCell(quizTable, "Score");
        AddTableHeaderCell(quizTable, "Attempts");
        AddTableHeaderCell(quizTable, "Date");

        foreach (var quiz in quizResults.Take(10)) // Show top 10
        {
            quizTable.AddCell(new PdfPCell(new Phrase(quiz.QuizTitle, FontFactory.GetFont(FontFactory.HELVETICA, 9))));
            quizTable.AddCell(new PdfPCell(new Phrase(quiz.CourseName, FontFactory.GetFont(FontFactory.HELVETICA, 9))));
            quizTable.AddCell(new PdfPCell(new Phrase($"{quiz.Score:F1}%", FontFactory.GetFont(FontFactory.HELVETICA, 9))) { HorizontalAlignment = Element.ALIGN_CENTER });
            quizTable.AddCell(new PdfPCell(new Phrase(quiz.Attempts.ToString(), FontFactory.GetFont(FontFactory.HELVETICA, 9))) { HorizontalAlignment = Element.ALIGN_CENTER });
            quizTable.AddCell(new PdfPCell(new Phrase(quiz.DateTaken.ToString("MM/dd/yyyy"), FontFactory.GetFont(FontFactory.HELVETICA, 9))) { HorizontalAlignment = Element.ALIGN_CENTER });
        }

        document.Add(quizTable);
        document.Add(new Paragraph(" "));
    }

    private static void AddReportFooter(Document document)
    {
        document.Add(new Paragraph(" "));
        document.Add(new Paragraph("_______________________________________________________"));
        
        var footerTable = new PdfPTable(2) { WidthPercentage = 100 };
        
        var disclaimerText = "This report is generated automatically by AGM Solutions LMS. " +
                           "For any discrepancies or questions, please contact the academic office.";
        
        footerTable.AddCell(new PdfPCell(new Phrase(disclaimerText, FontFactory.GetFont(FontFactory.HELVETICA, 8)))
        {
            Border = Rectangle.NO_BORDER,
            HorizontalAlignment = Element.ALIGN_LEFT
        });
        
        footerTable.AddCell(new PdfPCell(new Phrase($"Page generated: {DateTime.Now:yyyy-MM-dd HH:mm}", FontFactory.GetFont(FontFactory.HELVETICA, 8)))
        {
            Border = Rectangle.NO_BORDER,
            HorizontalAlignment = Element.ALIGN_RIGHT
        });

        document.Add(footerTable);
    }

    #endregion

    #region Helper Methods

    private static void AddTableRow(PdfPTable table, string label, string value)
    {
        table.AddCell(new PdfPCell(new Phrase(label, FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 10)))
        {
            Border = Rectangle.NO_BORDER,
            PaddingBottom = 5
        });
        table.AddCell(new PdfPCell(new Phrase(value, FontFactory.GetFont(FontFactory.HELVETICA, 10)))
        {
            Border = Rectangle.NO_BORDER,
            PaddingBottom = 5
        });
    }

    private static void AddTableHeaderCell(PdfPTable table, string text)
    {
        table.AddCell(new PdfPCell(new Phrase(text, FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 10)))
        {
            BackgroundColor = BaseColor.LIGHT_GRAY,
            HorizontalAlignment = Element.ALIGN_CENTER,
            Padding = 5
        });
    }

    #endregion

    #region Data Retrieval Methods

    private static StudentData GetStudentData(int studentId)
    {
        using (var connection = new SqlConnection(ConnectionString))
        {
            connection.Open();
            string sql = @"
                SELECT UserID, FirstName + ' ' + LastName AS StudentName, Email, 
                       DateOfBirth, CreatedDate AS EnrollmentDate, Status
                FROM Users 
                WHERE UserID = @StudentID AND Role = 'Student'";

            using (var cmd = new SqlCommand(sql, connection))
            {
                cmd.Parameters.AddWithValue("@StudentID", studentId);
                using (var reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        return new StudentData
                        {
                            StudentID = reader.GetInt32(reader.GetOrdinal("UserID")),
                            StudentName = reader.GetString(reader.GetOrdinal("StudentName")),
                            Email = reader.GetString(reader.GetOrdinal("Email")),
                            DateOfBirth = reader.IsDBNull(reader.GetOrdinal("DateOfBirth")) ? (DateTime?)null : reader.GetDateTime(reader.GetOrdinal("DateOfBirth")),
                            EnrollmentDate = reader.IsDBNull(reader.GetOrdinal("EnrollmentDate")) ? (DateTime?)null : reader.GetDateTime(reader.GetOrdinal("EnrollmentDate")),
                            Status = reader.IsDBNull(reader.GetOrdinal("Status")) ? "Active" : reader.GetString(reader.GetOrdinal("Status"))
                        };
                    }
                }
            }
        }
        return null;
    }

    private static StudentReportData GetStudentReportData(int studentId)
    {
        var reportData = new StudentReportData();
        
        using (var connection = new SqlConnection(ConnectionString))
        {
            connection.Open();

            // Get basic statistics
            string statsSql = @"
                SELECT 
                    COUNT(DISTINCT e.CourseID) AS TotalCourses,
                    COUNT(DISTINCT CASE WHEN g.Grade >= 60 THEN e.CourseID END) AS CompletedCourses,
                    AVG(CAST(g.Grade AS FLOAT)) AS OverallGPA,
                    SUM(COALESCE(c.Credits, 3)) AS TotalCredits
                FROM Enrollments e
                LEFT JOIN Grades g ON e.EnrollmentID = g.StudentID AND g.StudentID = @StudentID
                LEFT JOIN Courses c ON e.CourseID = c.CourseID
                WHERE e.StudentID = @StudentID";

            using (var cmd = new SqlCommand(statsSql, connection))
            {
                cmd.Parameters.AddWithValue("@StudentID", studentId);
                using (var reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        reportData.TotalCourses = reader.IsDBNull(reader.GetOrdinal("TotalCourses")) ? 0 : reader.GetInt32(reader.GetOrdinal("TotalCourses"));
                        reportData.CompletedCourses = reader.IsDBNull(reader.GetOrdinal("CompletedCourses")) ? 0 : reader.GetInt32(reader.GetOrdinal("CompletedCourses"));
                        reportData.OverallGPA = reader.IsDBNull(reader.GetOrdinal("OverallGPA")) ? 0.0 : reader.GetDouble(reader.GetOrdinal("OverallGPA"));
                        reportData.TotalCredits = reader.IsDBNull(reader.GetOrdinal("TotalCredits")) ? 0 : reader.GetInt32(reader.GetOrdinal("TotalCredits"));
                    }
                }
            }

            // Get quiz data
            string quizSql = @"
                SELECT COUNT(*) AS TotalQuizzes, AVG(CAST(Score AS FLOAT)) AS AverageScore
                FROM QuizResults 
                WHERE StudentID = @StudentID";

            using (var cmd = new SqlCommand(quizSql, connection))
            {
                cmd.Parameters.AddWithValue("@StudentID", studentId);
                using (var reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        reportData.TotalQuizzes = reader.IsDBNull(reader.GetOrdinal("TotalQuizzes")) ? 0 : reader.GetInt32(reader.GetOrdinal("TotalQuizzes"));
                        reportData.AverageQuizScore = reader.IsDBNull(reader.GetOrdinal("AverageScore")) ? 0.0 : reader.GetDouble(reader.GetOrdinal("AverageScore"));
                    }
                }
            }
        }

        return reportData;
    }

    #endregion

    #region Support Classes

    public class PdfResult
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public string FileName { get; set; }
        public string FilePath { get; set; }
    }

    public class StudentData
    {
        public int StudentID { get; set; }
        public string StudentName { get; set; }
        public string Email { get; set; }
        public DateTime? DateOfBirth { get; set; }
        public DateTime? EnrollmentDate { get; set; }
        public string Status { get; set; }
    }

    public class StudentReportData
    {
        public int TotalCourses { get; set; }
        public int CompletedCourses { get; set; }
        public double OverallGPA { get; set; }
        public int TotalCredits { get; set; }
        public int TotalQuizzes { get; set; }
        public double AverageQuizScore { get; set; }
        public int TotalAssignments { get; set; }
        public double AverageAssignmentScore { get; set; }
        public List<CourseGrade> Courses { get; set; } = new List<CourseGrade>();
        public List<QuizResult> QuizResults { get; set; } = new List<QuizResult>();
        public List<AssignmentResult> AssignmentResults { get; set; } = new List<AssignmentResult>();
    }

    public class CourseData
    {
        public int CourseID { get; set; }
        public string CourseName { get; set; }
        public string CourseCode { get; set; }
        public string Description { get; set; }
        public int Credits { get; set; }
    }

    public class QuizResult
    {
        public string QuizTitle { get; set; }
        public string CourseName { get; set; }
        public double Score { get; set; }
        public int Attempts { get; set; }
        public DateTime DateTaken { get; set; }
    }

    public class AssignmentResult
    {
        public string AssignmentTitle { get; set; }
        public string CourseName { get; set; }
        public double Score { get; set; }
        public DateTime DateSubmitted { get; set; }
        public string Status { get; set; }
    }

    public class CourseGrade
    {
        public string CourseCode { get; set; }
        public string CourseName { get; set; }
        public double Grade { get; set; }
        public string LetterGrade { get; set; }
        public int Credits { get; set; }
    }

    #endregion

    #region Private Helper Methods

    private static void AddCourseDetails(Document document, object courses)
    {
        // TODO: Implement course details section
    }

    private static void AddAssignmentPerformance(Document document, object assignmentResults)
    {
        // TODO: Implement assignment performance section
    }

    private static void AddRecommendations(Document document, object reportData)
    {
        // TODO: Implement recommendations section
    }

    private static object GetCourseData(int courseId)
    {
        // TODO: Implement course data retrieval
        return new { CourseCode = "TEMP" };
    }

    private static object GetCourseReportData(int courseId)
    {
        // TODO: Implement course report data retrieval
        return new { StudentGrades = new object[0] };
    }

    private static void AddCourseInformation(Document document, object courseData)
    {
        // TODO: Implement course information section
    }

    private static void AddEnrollmentStatistics(Document document, object courseData)
    {
        // TODO: Implement enrollment statistics section
    }

    private static void AddPerformanceAnalytics(Document document, object courseData)
    {
        // TODO: Implement performance analytics section
    }

    private static void AddStudentGradesList(Document document, object courseData)
    {
        // TODO: Implement student grades list section
    }

    private static void AddCourseRecommendations(Document document, object courseData)
    {
        // TODO: Implement course recommendations section
    }

    private static object GetTranscriptData(int studentId)
    {
        // TODO: Implement transcript data retrieval
        return null;
    }

    private static void AddOfficialHeader(Document document, object headerText)
    {
        // TODO: Implement official header section
    }

    private static void AddAcademicRecord(Document document, object transcriptData)
    {
        // TODO: Implement academic record section
    }

    private static void AddGPACalculation(Document document, object transcriptData)
    {
        // TODO: Implement GPA calculation section
    }

    private static void AddOfficialFooter(Document document, object transcriptData)
    {
        // TODO: Implement official footer section
    }

    #endregion
}
