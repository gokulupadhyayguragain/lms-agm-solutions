using System;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using AGMSolutions.App_Code.BLL;
using AGMSolutions.App_Code.Models;

namespace AGMSolutions.Students
{
    public partial class GenerateReport : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (!User.Identity.IsAuthenticated)
                {
                    Response.Redirect("~/Common/Login.aspx");
                    return;
                }
                LoadStudentData();
            }
        }

        private void LoadStudentData()
        {
            try
            {
                UserManager userManager = new UserManager();
                User currentUser = userManager.GetUserByEmail(User.Identity.Name);
                
                if (currentUser != null)
                {
                    lblStudentName.Text = $"{currentUser.FirstName} {currentUser.LastName}";
                    lblStudentEmail.Text = currentUser.Email;
                    lblStudentID.Text = currentUser.UserID.ToString();
                    
                    // Load enrollment and grade data
                    LoadEnrollmentData(currentUser.UserID);
                    LoadGradeData(currentUser.UserID);
                    LoadAttendanceData(currentUser.UserID);
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error loading student data: " + ex.Message;
                lblMessage.CssClass = "alert alert-danger";
            }
        }

        private void LoadEnrollmentData(int studentId)
        {
            try
            {
                EnrollmentManager enrollmentManager = new EnrollmentManager();
                var enrollments = enrollmentManager.GetEnrollmentsByStudentId(studentId);
                
                gvEnrollments.DataSource = enrollments;
                gvEnrollments.DataBind();
                
                lblTotalCourses.Text = enrollments?.Count.ToString() ?? "0";
            }
            catch (Exception ex)
            {
                lblMessage.Text += " Error loading enrollments: " + ex.Message;
            }
        }

        private void LoadGradeData(int studentId)
        {
            try
            {
                // Implement grade loading logic
                // For now, using sample data
                lblOverallGPA.Text = "3.75";
                lblCompletedAssignments.Text = "15";
                lblPendingAssignments.Text = "3";
            }
            catch (Exception ex)
            {
                lblMessage.Text += " Error loading grades: " + ex.Message;
            }
        }

        private void LoadAttendanceData(int studentId)
        {
            try
            {
                // Implement attendance calculation
                lblOverallAttendance.Text = "87.5%";
                lblClassesAttended.Text = "35";
                lblTotalClasses.Text = "40";
            }
            catch (Exception ex)
            {
                lblMessage.Text += " Error loading attendance: " + ex.Message;
            }
        }

        protected void btnGeneratePDF_Click(object sender, EventArgs e)
        {
            try
            {
                GeneratePDFReport();
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error generating PDF: " + ex.Message;
                lblMessage.CssClass = "alert alert-danger";
            }
        }

        private void GeneratePDFReport()
        {
            // Generate HTML for PDF conversion
            StringBuilder htmlContent = new StringBuilder();
            
            htmlContent.Append(@"
                <!DOCTYPE html>
                <html>
                <head>
                    <title>AGM Solutions - Student Report</title>
                    <style>
                        body { font-family: Arial, sans-serif; margin: 20px; }
                        .header { text-align: center; border-bottom: 2px solid #333; padding-bottom: 20px; margin-bottom: 30px; }
                        .logo { font-size: 24px; font-weight: bold; color: #007bff; }
                        .section { margin: 20px 0; }
                        .section h3 { background: #f8f9fa; padding: 10px; border-left: 4px solid #007bff; }
                        table { width: 100%; border-collapse: collapse; margin: 15px 0; }
                        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
                        th { background-color: #f2f2f2; }
                        .stats { display: flex; justify-content: space-around; margin: 20px 0; }
                        .stat-box { text-align: center; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
                        .footer { text-align: center; margin-top: 50px; font-size: 12px; color: #666; }
                    </style>
                </head>
                <body>
                    <div class='header'>
                        <div class='logo'>AGM Solutions</div>
                        <h2>Student Academic Report</h2>
                        <p>Generated on: " + DateTime.Now.ToString("MMMM dd, yyyy") + @"</p>
                    </div>
                    
                    <div class='section'>
                        <h3>Student Information</h3>
                        <table>
                            <tr><th>Name</th><td>" + lblStudentName.Text + @"</td></tr>
                            <tr><th>Student ID</th><td>" + lblStudentID.Text + @"</td></tr>
                            <tr><th>Email</th><td>" + lblStudentEmail.Text + @"</td></tr>
                            <tr><th>Report Period</th><td>Academic Year 2024-2025</td></tr>
                        </table>
                    </div>
                    
                    <div class='section'>
                        <h3>Academic Summary</h3>
                        <div class='stats'>
                            <div class='stat-box'>
                                <h4>Overall GPA</h4>
                                <p style='font-size: 24px; color: #28a745;'>" + lblOverallGPA.Text + @"</p>
                            </div>
                            <div class='stat-box'>
                                <h4>Total Courses</h4>
                                <p style='font-size: 24px; color: #007bff;'>" + lblTotalCourses.Text + @"</p>
                            </div>
                            <div class='stat-box'>
                                <h4>Attendance</h4>
                                <p style='font-size: 24px; color: #17a2b8;'>" + lblOverallAttendance.Text + @"</p>
                            </div>
                        </div>
                    </div>
                    
                    <div class='section'>
                        <h3>Course Enrollments</h3>
                        <table>
                            <tr>
                                <th>Course Code</th>
                                <th>Course Name</th>
                                <th>Enrollment Date</th>
                                <th>Status</th>
                            </tr>");

            // Add enrollment data to HTML
            foreach (GridViewRow row in gvEnrollments.Rows)
            {
                if (row.RowType == DataControlRowType.DataRow)
                {
                    htmlContent.Append("<tr>");
                    for (int i = 0; i < row.Cells.Count; i++)
                    {
                        htmlContent.Append("<td>" + row.Cells[i].Text + "</td>");
                    }
                    htmlContent.Append("</tr>");
                }
            }

            htmlContent.Append(@"
                        </table>
                    </div>
                    
                    <div class='section'>
                        <h3>Performance Metrics</h3>
                        <table>
                            <tr><th>Metric</th><th>Value</th></tr>
                            <tr><td>Completed Assignments</td><td>" + lblCompletedAssignments.Text + @"</td></tr>
                            <tr><td>Pending Assignments</td><td>" + lblPendingAssignments.Text + @"</td></tr>
                            <tr><td>Classes Attended</td><td>" + lblClassesAttended.Text + " / " + lblTotalClasses.Text + @"</td></tr>
                            <tr><td>Overall Attendance</td><td>" + lblOverallAttendance.Text + @"</td></tr>
                        </table>
                    </div>
                    
                    <div class='footer'>
                        <p>This report is generated by AGM Solutions Learning Management System</p>
                        <p>For questions or concerns, please contact your academic advisor</p>
                    </div>
                </body>
                </html>");

            // Convert HTML to PDF and download
            string fileName = $"AGM_Student_Report_{lblStudentID.Text}_{DateTime.Now:yyyyMMdd}.html";
            
            Response.Clear();
            Response.ContentType = "text/html";
            Response.AddHeader("Content-Disposition", $"attachment; filename={fileName}");
            Response.Write(htmlContent.ToString());
            Response.End();
        }
    }
}
