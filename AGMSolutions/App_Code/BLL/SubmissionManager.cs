// App_Code/BLL/SubmissionManager.cs
using System;
using System.Collections.Generic;
using AGMSolutions.App_Code.DAL;
using AGMSolutions.App_Code.Models;

namespace AGMSolutions.App_Code.BLL
{
    public class SubmissionManager
    {
        private SubmissionDAL _submissionDAL;
        private AssignmentManager _assignmentManager;
        private EnrollmentManager _enrollmentManager; // To check if student is enrolled
        private UserManager _userManager;

        public SubmissionManager()
        {
            _submissionDAL = new SubmissionDAL();
            _assignmentManager = new AssignmentManager();
            _enrollmentManager = new EnrollmentManager();
            _userManager = new UserManager();
        }

        public bool AddSubmission(Submission submission)
        {
            if (submission == null || submission.AssignmentID <= 0 || submission.StudentID <= 0)
            {
                throw new ArgumentException("Assignment ID and Student ID are required for submission.");
            }

            Assignment assignment = _assignmentManager.GetAssignmentById(submission.AssignmentID);
            User student = _userManager.GetUserById(submission.StudentID);

            if (assignment == null || !assignment.IsActive)
            {
                throw new Exception("Assignment is invalid or inactive.");
            }
            if (student == null || _userManager.GetRoleNameById(student.UserTypeID) != "Student")
            {
                throw new Exception("Invalid Student ID.");
            }
            // Check if student is enrolled in the course this assignment belongs to
            if (!_enrollmentManager.IsStudentEnrolledInCourse(submission.StudentID, assignment.CourseID))
            {
                throw new Exception("You are not enrolled in the course for this assignment.");
            }
            // Check if due date has passed
            if (DateTime.Now > assignment.DueDate)
            {
                // This could be a warning or prevented based on policy. For now, prevent.
                throw new Exception("Cannot submit: Assignment due date has passed.");
            }

            // Check if student has already submitted (unique constraint will catch, but good to check proactively)
            if (_submissionDAL.GetSubmissionByStudentAndAssignment(submission.StudentID, submission.AssignmentID) != null)
            {
                throw new Exception("You have already submitted for this assignment. If you need to re-submit, please contact your lecturer.");
            }

            submission.SubmissionDate = DateTime.Now;
            submission.IsGraded = false; // New submissions are not graded by default

            return _submissionDAL.AddSubmission(submission);
        }

        // This method can be used for re-submission by student (updating content) or for grading by lecturer
        public bool UpdateSubmission(Submission submission)
        {
            if (submission == null || submission.SubmissionID <= 0)
            {
                throw new ArgumentException("Submission ID is required for update.");
            }
            // More complex logic here based on who is updating (student re-submitting, lecturer grading)
            // For re-submission, you might prevent it after due date or if already graded.

            return _submissionDAL.UpdateSubmission(submission);
        }

        public bool DeleteSubmission(int submissionId)
        {
            if (submissionId <= 0)
            {
                throw new ArgumentException("Invalid Submission ID.");
            }
            // Business logic for deletion, e.g., only before grading
            return _submissionDAL.DeleteSubmission(submissionId);
        }

        public Submission GetSubmissionById(int submissionId)
        {
            if (submissionId <= 0)
            {
                throw new ArgumentException("Invalid Submission ID.");
            }
            return _submissionDAL.GetSubmissionById(submissionId);
        }

        public List<Submission> GetSubmissionsByAssignmentId(int assignmentId)
        {
            if (assignmentId <= 0)
            {
                throw new ArgumentException("Invalid Assignment ID.");
            }
            return _submissionDAL.GetSubmissionsByAssignmentId(assignmentId);
        }

        public List<Submission> GetSubmissionsByStudentId(int studentId)
        {
            if (studentId <= 0)
            {
                throw new ArgumentException("Invalid Student ID.");
            }
            return _submissionDAL.GetSubmissionsByStudentId(studentId);
        }

        public Submission GetSubmissionByStudentAndAssignment(int studentId, int assignmentId)
        {
            if (studentId <= 0 || assignmentId <= 0)
            {
                throw new ArgumentException("Invalid Student ID or Assignment ID.");
            }
            return _submissionDAL.GetSubmissionByStudentAndAssignment(studentId, assignmentId);
        }

        // For grading
        public bool GradeSubmission(int submissionId, decimal grade, string feedback)
        {
            if (submissionId <= 0 || grade < 0)
            {
                throw new ArgumentException("Invalid Submission ID or Grade.");
            }

            Submission submission = GetSubmissionById(submissionId);
            if (submission == null)
            {
                throw new Exception("Submission not found.");
            }

            // Optional: Validate grade against assignment max marks
            Assignment assignment = _assignmentManager.GetAssignmentById(submission.AssignmentID);
            if (assignment != null && assignment.MaxMarks.HasValue && grade > assignment.MaxMarks.Value)
            {
                throw new ArgumentException($"Grade cannot exceed maximum marks ({assignment.MaxMarks.Value}).");
            }

            submission.Grade = grade;
            submission.Feedback = feedback;
            submission.IsGraded = true;

            return _submissionDAL.UpdateSubmission(submission);
        }
    }
}


