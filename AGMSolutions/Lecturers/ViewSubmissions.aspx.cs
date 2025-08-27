using AGMSolutions.App_Code.BLL;
using AGMSolutions.App_Code.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace AGMSolutions.Lecturers
{
    public partial class ViewSubmissions : System.Web.UI.Page
    {
        private AssignmentManager _assignmentManager;
        private SubmissionManager _submissionManager;
        private CourseManager _courseManager;
        private UserManager _userManager;

        protected int CurrentAssignmentId
        {
            get
            {
                if (ViewState["CurrentAssignmentId"] == null && !string.IsNullOrEmpty(Request.QueryString["assignmentId"]))
                {
                    int assignmentId;
                    if (int.TryParse(Request.QueryString["assignmentId"], out assignmentId))
                    {
                        ViewState["CurrentAssignmentId"] = assignmentId;
                    }
                    else
                    {
                        ShowAlert("Invalid Assignment ID provided.", "danger");
                        return 0;
                    }
                }
                return (int)(ViewState["CurrentAssignmentId"] ?? 0);
            }
            set { ViewState["CurrentAssignmentId"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            _assignmentManager = new AssignmentManager();
            _submissionManager = new SubmissionManager();
            _courseManager = new CourseManager();
            _userManager = new UserManager();

            if (!IsPostBack)
            {
                if (!User.Identity.IsAuthenticated)
                {
                    Response.Redirect("~/Common/Login.aspx");
                    return;
                }

                User currentUser = _userManager.GetUserByEmail(User.Identity.Name);
                if (currentUser == null || _userManager.GetRoleNameById(currentUser.UserTypeID) != "Lecturer")
                {
                    System.Web.Security.FormsAuthentication.SignOut();
                    Response.Redirect("~/Default.aspx");
                    return;
                }

                if (CurrentAssignmentId > 0)
                {
                    LoadAssignmentDetails(CurrentAssignmentId);
                    BindSubmissions(CurrentAssignmentId);
                }
                else
                {
                    ShowAlert("No assignment selected. Please select an assignment from My Courses.", "danger");
                    Response.Redirect("~/Lecturers/MyCourses.aspx");
                }
            }
        }

        private void LoadAssignmentDetails(int assignmentId)
        {
            Assignment assignment = _assignmentManager.GetAssignmentById(assignmentId);
            if (assignment != null)
            {
                //litAssignmentTitle.Text = assignment.Title;
                Course course = _courseManager.GetCourseById(assignment.CourseID);
                if (course != null)
                {
                    litCourseName.Text = course.CourseName;
                }
                else
                {
                    litCourseName.Text = "N/A";
                }

                User currentUser = _userManager.GetUserByEmail(User.Identity.Name);
                if (currentUser == null || assignment.LecturerID != currentUser.UserID)
                {
                    ShowAlert("You are not authorized to view submissions for this assignment.", "danger");
                    System.Web.Security.FormsAuthentication.SignOut();
                    Response.Redirect("~/Default.aspx");
                }
            }
            else
            {
                ShowAlert("Assignment not found.", "danger");
                Response.Redirect("~/Lecturers/MyCourses.aspx");
            }
        }

        private void BindSubmissions(int assignmentId)
        {
            List<Submission> submissions = _submissionManager.GetSubmissionsByAssignmentId(assignmentId);
            gvSubmissions.DataSource = submissions;
            gvSubmissions.DataBind();
        }

        // --- Ensure this method is present ---
        protected string GetStudentName(int studentId)
        {
            User student = _userManager.GetUserById(studentId);
            return student != null ? $"{student.FirstName} {student.LastName}" : "Unknown Student";
        }
        // ------------------------------------

        protected void gvSubmissions_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvSubmissions.PageIndex = e.NewPageIndex;
            BindSubmissions(CurrentAssignmentId);
        }

        protected void gvSubmissions_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvSubmissions.EditIndex = e.NewEditIndex;
            BindSubmissions(CurrentAssignmentId);
        }

        protected void gvSubmissions_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int submissionId = Convert.ToInt32(gvSubmissions.DataKeys[e.RowIndex].Value);
            TextBox txtEditGrade = (TextBox)gvSubmissions.Rows[e.RowIndex].FindControl("txtEditGrade");

            Submission submissionToUpdate = _submissionManager.GetSubmissionById(submissionId);

            if (submissionToUpdate == null)
            {
                ShowAlert("Error: Submission not found for update.", "danger");
                gvSubmissions.EditIndex = -1;
                BindSubmissions(CurrentAssignmentId);
                return;
            }

            decimal? grade = null;
            if (txtEditGrade != null && !string.IsNullOrEmpty(txtEditGrade.Text))
            {
                decimal parsedGrade;
                if (decimal.TryParse(txtEditGrade.Text.Trim(), out parsedGrade))
                {
                    if (parsedGrade >= 0 && parsedGrade <= 100)
                    {
                        grade = parsedGrade;
                    }
                    else
                    {
                        ShowAlert("Grade must be between 0 and 100.", "warning");
                        return;
                    }
                }
                else
                {
                    ShowAlert("Invalid grade value. Please enter a number.", "warning");
                    return;
                }
            }
            submissionToUpdate.Grade = grade;
            submissionToUpdate.IsGraded = (grade != null);

            try
            {
                bool success = _submissionManager.UpdateSubmission(submissionToUpdate);
                if (success)
                {
                    ShowAlert("Grade updated successfully!", "success");
                }
                else
                {
                    ShowAlert("Failed to update grade. Please try again.", "danger");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error updating grade: {ex.Message}");
                ShowAlert($"An error occurred while updating grade: {ex.Message}", "danger");
            }

            gvSubmissions.EditIndex = -1;
            BindSubmissions(CurrentAssignmentId);
        }

        protected void gvSubmissions_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvSubmissions.EditIndex = -1;
            BindSubmissions(CurrentAssignmentId);
        }

        protected void gvSubmissions_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DownloadFile")
            {
                string filePath = e.CommandArgument.ToString();

                if (!string.IsNullOrEmpty(filePath))
                {
                    string fullPath = Server.MapPath(filePath);

                    if (File.Exists(fullPath))
                    {
                        Response.Clear();
                        Response.ContentType = MimeMapping.GetMimeMapping(fullPath);
                        Response.AppendHeader("Content-Disposition", "attachment; filename=" + HttpUtility.UrlEncode(Path.GetFileName(fullPath)));
                        Response.TransmitFile(fullPath);
                        Response.End();
                    }
                    else
                    {
                        ShowAlert("Submitted file not found on the server.", "warning");
                    }
                }
                else
                {
                    ShowAlert("No file path provided for download.", "warning");
                }
            }
        }

        protected void gvSubmissions_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow && e.Row.RowState.HasFlag(DataControlRowState.Edit))
            {
                Submission submission = e.Row.DataItem as Submission;

                if (submission != null)
                {
                    TextBox txtEditGrade = (TextBox)e.Row.FindControl("txtEditGrade");

                    if (txtEditGrade != null)
                    {
                        txtEditGrade.Text = submission.Grade?.ToString() ?? string.Empty;
                    }
                }
            }
        }

        // --- Ensure this method is present ---
        private void ShowAlert(string message, string type)
        {
            string script = $@"
                <div class='alert alert-{type} alert-dismissible fade show' role='alert'>
                    {message}
                    <button type='button' class='btn-close' data-bs-dismiss='alert' aria-label='Close'></button>
                </div>";
            litAlert.Text = script;
        }
        // ------------------------------------
    }
}




