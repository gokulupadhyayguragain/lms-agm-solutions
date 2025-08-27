using AGMSolutions.App_Code.BLL;
using AGMSolutions.App_Code.Models;
using System;
using System.Collections.Generic;
using System.Linq; // Make sure this is included for LINQ methods if used (e.g., in GetUserByEmail or other managers)
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AGMSolutions.Lecturers
{
    public partial class ManageAssignments : System.Web.UI.Page
    {
        private UserManager _userManager;
        private CourseManager _courseManager;
        private AssignmentManager _assignmentManager;

        protected void Page_Load(object sender, EventArgs e)
        {
            _userManager = new UserManager();
            _courseManager = new CourseManager();
            _assignmentManager = new AssignmentManager();

            if (!IsPostBack)
            {
                // Lecturer authorization check
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

                BindCoursesDropdown(currentUser.UserID);

                // If a CourseID is passed in the query string (e.g., from MyCourses.aspx)
                if (!string.IsNullOrEmpty(Request.QueryString["courseId"]))
                {
                    int courseId = Convert.ToInt32(Request.QueryString["courseId"]);
                    // Ensure the selected course is in the dropdown before setting SelectedValue
                    if (ddlCourses.Items.FindByValue(courseId.ToString()) != null)
                    {
                        ddlCourses.SelectedValue = courseId.ToString();
                        BindAssignments(courseId);
                        pnlAssignments.Visible = true;
                        litSelectedCourseName.Text = ddlCourses.SelectedItem.Text;
                    }
                    else
                    {
                        // Handle case where courseId from query string is not in the dropdown
                        // (e.g., not assigned to this lecturer, or invalid ID)
                        ShowAlert("Invalid course selected or you are not assigned to it.", "warning");
                        pnlAssignments.Visible = false;
                    }
                }
            }
        }

        private void BindCoursesDropdown(int lecturerId)
        {
            List<Course> courses = _courseManager.GetCoursesByLecturerId(lecturerId);
            ddlCourses.DataSource = courses;
            ddlCourses.DataTextField = "CourseName"; // Or "CourseCode" if you prefer
            ddlCourses.DataValueField = "CourseID";
            ddlCourses.DataBind();
            ddlCourses.Items.Insert(0, new ListItem("-- Select a Course --", "0"));
        }

        protected void ddlCourses_SelectedIndexChanged(object sender, EventArgs e)
        {
            int selectedCourseId = Convert.ToInt32(ddlCourses.SelectedValue);
            if (selectedCourseId > 0)
            {
                BindAssignments(selectedCourseId);
                pnlAssignments.Visible = true;
                litSelectedCourseName.Text = ddlCourses.SelectedItem.Text;
            }
            else
            {
                pnlAssignments.Visible = false;
                gvAssignments.DataSource = null; // Clear GridView
                gvAssignments.DataBind();
            }
        }

        private void BindAssignments(int courseId)
        {
            List<Assignment> assignments = _assignmentManager.GetAssignmentsByCourseId(courseId);
            gvAssignments.DataSource = assignments;
            gvAssignments.DataBind();
        }

        protected void btnAddAssignment_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                ShowAlert("Please fix the validation errors.", "warning");
                return;
            }

            int courseId = Convert.ToInt32(ddlCourses.SelectedValue);
            if (courseId == 0)
            {
                ShowAlert("Please select a course first.", "danger");
                return;
            }

            User currentUser = _userManager.GetUserByEmail(User.Identity.Name);
            if (currentUser == null)
            {
                ShowAlert("User not found. Please log in again.", "danger");
                return;
            }

            DateTime dueDate = DateTime.MinValue; // Initialize it
            if (!DateTime.TryParse(txtDueDate.Text.Trim(), out dueDate))
            {
                ShowAlert("Invalid Due Date format. Please use YYYY-MM-DD.", "warning");
                return;
            }

            decimal? maxMarks = null;
            if (!string.IsNullOrEmpty(txtMaxMarks.Text))
            {
                decimal parsedMarks;
                if (decimal.TryParse(txtMaxMarks.Text.Trim(), out parsedMarks))
                {
                    maxMarks = parsedMarks;
                }
                else
                {
                    ShowAlert("Invalid Max Marks value. Please enter a number.", "warning");
                    return;
                }
            }


            Assignment newAssignment = new Assignment
            {
                CourseID = courseId,
                LecturerID = currentUser.UserID,
                Title = txtTitle.Text.Trim(),
                Description = txtDescription.Text.Trim(),
                DueDate = dueDate,
                MaxMarks = maxMarks,
                IsActive = true // Default to active
            };

            try
            {
                bool success = _assignmentManager.AddAssignment(newAssignment);
                if (success)
                {
                    ShowAlert("Assignment added successfully!", "success");
                    ClearAssignmentFields();
                    BindAssignments(courseId);
                }
                else
                {
                    ShowAlert("Failed to add assignment. Please try again.", "danger");
                }
            }
            catch (Exception ex)
            {
                // Log the exception for debugging
                System.Diagnostics.Debug.WriteLine($"Error adding assignment: {ex.Message}");
                ShowAlert($"Error adding assignment: {ex.Message}. Please check input values.", "danger");
            }
        }

        private void ClearAssignmentFields()
        {
            txtTitle.Text = string.Empty;
            txtDescription.Text = string.Empty;
            txtDueDate.Text = string.Empty;
            txtMaxMarks.Text = string.Empty;
        }

        protected void gvAssignments_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvAssignments.PageIndex = e.NewPageIndex;
            int courseId = Convert.ToInt32(ddlCourses.SelectedValue);
            BindAssignments(courseId);
        }

        protected void gvAssignments_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvAssignments.EditIndex = e.NewEditIndex;
            int courseId = Convert.ToInt32(ddlCourses.SelectedValue);
            BindAssignments(courseId); // Rebind to show the row in edit mode
        }

        protected void gvAssignments_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int assignmentId = Convert.ToInt32(gvAssignments.DataKeys[e.RowIndex].Value);
            // Get edited values from controls in the EditItemTemplate
            TextBox editTitle = (TextBox)gvAssignments.Rows[e.RowIndex].FindControl("txtEditTitle");
            TextBox editDescription = (TextBox)gvAssignments.Rows[e.RowIndex].FindControl("txtEditDescription");
            TextBox editDueDate = (TextBox)gvAssignments.Rows[e.RowIndex].FindControl("txtEditDueDate");
            TextBox editMaxMarks = (TextBox)gvAssignments.Rows[e.RowIndex].FindControl("txtEditMaxMarks");
            CheckBox editIsActive = (CheckBox)gvAssignments.Rows[e.RowIndex].FindControl("chkEditIsActive");

            Assignment assignmentToUpdate = _assignmentManager.GetAssignmentById(assignmentId);
            if (assignmentToUpdate == null)
            {
                ShowAlert("Assignment not found.", "danger");
                gvAssignments.EditIndex = -1;
                int courseId = Convert.ToInt32(ddlCourses.SelectedValue);
                BindAssignments(courseId);
                return;
            }

            // Input validation for DueDate format before parsing
            DateTime editedDueDate = DateTime.MinValue; // Initialize it
            if (editDueDate != null && !DateTime.TryParse(editDueDate.Text.Trim(), out editedDueDate))
            {
                ShowAlert("Invalid Due Date format for update. Please use YYYY-MM-DD.", "warning");
                return;
            }

            decimal? editedMaxMarks = null;
            if (editMaxMarks != null && !string.IsNullOrEmpty(editMaxMarks.Text))
            {
                decimal parsedEditedMarks;
                if (decimal.TryParse(editMaxMarks.Text.Trim(), out parsedEditedMarks))
                {
                    editedMaxMarks = parsedEditedMarks;
                }
                else
                {
                    ShowAlert("Invalid Max Marks value for update. Please enter a number.", "warning");
                    return;
                }
            }

            assignmentToUpdate.Title = editTitle.Text.Trim();
            assignmentToUpdate.Description = editDescription.Text.Trim();
            assignmentToUpdate.DueDate = editedDueDate;
            assignmentToUpdate.MaxMarks = editedMaxMarks;
            assignmentToUpdate.IsActive = editIsActive.Checked;

            try
            {
                bool success = _assignmentManager.UpdateAssignment(assignmentToUpdate);
                if (success)
                {
                    ShowAlert("Assignment updated successfully!", "success");
                }
                else
                {
                    ShowAlert("Failed to update assignment.", "danger");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error updating assignment: {ex.Message}");
                ShowAlert($"Error updating assignment: {ex.Message}. Please check input values.", "danger");
            }

            gvAssignments.EditIndex = -1; // Exit edit mode
            int currentCourseId = Convert.ToInt32(ddlCourses.SelectedValue);
            BindAssignments(currentCourseId);
        }

        protected void gvAssignments_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvAssignments.EditIndex = -1; // Exit edit mode
            int courseId = Convert.ToInt32(ddlCourses.SelectedValue);
            BindAssignments(courseId);
        }

        protected void gvAssignments_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int assignmentId = Convert.ToInt32(gvAssignments.DataKeys[e.RowIndex].Value);
            try
            {
                bool success = _assignmentManager.DeleteAssignment(assignmentId);
                if (success)
                {
                    ShowAlert("Assignment deleted successfully!", "success");
                    int courseId = Convert.ToInt32(ddlCourses.SelectedValue);
                    BindAssignments(courseId);
                }
                else
                {
                    ShowAlert("Failed to delete assignment.", "danger");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error deleting assignment: {ex.Message}");
                ShowAlert($"Error deleting assignment: {ex.Message}", "danger");
            }
        }

        protected void gvAssignments_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow && e.Row.RowState.HasFlag(DataControlRowState.Edit))
            {
                // Get the data item for the current row
                Assignment assignment = e.Row.DataItem as Assignment;

                if (assignment != null)
                {
                    // Find the controls in the EditItemTemplate and populate them
                    TextBox txtEditTitle = (TextBox)e.Row.FindControl("txtEditTitle");
                    TextBox txtEditDescription = (TextBox)e.Row.FindControl("txtEditDescription");
                    TextBox txtEditDueDate = (TextBox)e.Row.FindControl("txtEditDueDate");
                    TextBox txtEditMaxMarks = (TextBox)e.Row.FindControl("txtEditMaxMarks");
                    CheckBox chkEditIsActive = (CheckBox)e.Row.FindControl("chkEditIsActive");

                    if (txtEditTitle != null) txtEditTitle.Text = assignment.Title;
                    if (txtEditDescription != null) txtEditDescription.Text = assignment.Description;
                    if (txtEditDueDate != null) txtEditDueDate.Text = assignment.DueDate.ToString("yyyy-MM-dd"); // Format for HTML5 date input
                    if (txtEditMaxMarks != null) txtEditMaxMarks.Text = assignment.MaxMarks?.ToString(); // Convert nullable decimal to string
                    if (chkEditIsActive != null) chkEditIsActive.Checked = assignment.IsActive;
                }
            }
        }

        private void ShowAlert(string message, string type)
        {
            // litAlert is the Literal control defined in your .aspx page
            string script = $@"
                <div class='alert alert-{type} alert-dismissible fade show' role='alert'>
                    {message}
                    <button type='button' class='btn-close' data-bs-dismiss='alert' aria-label='Close'></button>
                </div>";
            litAlert.Text = script;
        }
    }
}


