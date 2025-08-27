<%@ Page Title="API Documentation" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="ApiDocs.aspx.cs" Inherits="AGMSolutions.Students.ApiDocs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .api-docs-container {
            max-width: 1200px;
            margin: 20px auto;
            padding: 20px;
        }
        .api-header {
            background: var(--gradient-primary);
            color: white;
            padding: 40px;
            border-radius: 20px;
            text-align: center;
            margin-bottom: 30px;
        }
        .endpoint-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            border-left: 5px solid var(--primary-color);
        }
        .endpoint-method {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 6px;
            font-weight: bold;
            font-size: 0.8rem;
            margin-right: 10px;
        }
        .method-get { background: #28a745; color: white; }
        .method-post { background: #007bff; color: white; }
        .method-put { background: #ffc107; color: #333; }
        .method-delete { background: #dc3545; color: white; }
        .endpoint-url {
            font-family: 'Courier New', monospace;
            background: #f8f9fa;
            padding: 10px;
            border-radius: 6px;
            margin: 10px 0;
        }
        .code-block {
            background: #2d3748;
            color: #e2e8f0;
            padding: 20px;
            border-radius: 10px;
            overflow-x: auto;
            font-family: 'Courier New', monospace;
            margin: 15px 0;
        }
        .response-example {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 10px;
            padding: 20px;
            margin: 15px 0;
        }
        .nav-sidebar {
            position: sticky;
            top: 20px;
            background: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        .nav-item {
            display: block;
            padding: 8px 15px;
            color: var(--dark-color);
            text-decoration: none;
            border-radius: 8px;
            margin-bottom: 5px;
            transition: all 0.3s ease;
        }
        .nav-item:hover,
        .nav-item.active {
            background: var(--primary-color);
            color: white;
        }
        .parameter-table {
            width: 100%;
            border-collapse: collapse;
            margin: 15px 0;
        }
        .parameter-table th,
        .parameter-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #dee2e6;
        }
        .parameter-table th {
            background: #f8f9fa;
            font-weight: 600;
        }
        .required {
            color: var(--danger-color);
            font-weight: bold;
        }
        .optional {
            color: var(--secondary-color);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="api-docs-container">
        <div class="api-header">
            <h1><i class="fas fa-code"></i> AGM Solutions API Documentation</h1>
            <p>Complete reference for integrating with the AGM Solutions Learning Management System</p>
        </div>

        <div class="row">
            <div class="col-lg-3">
                <div class="nav-sidebar">
                    <h5>API Endpoints</h5>
                    <a href="#authentication" class="nav-item">Authentication</a>
                    <a href="#users" class="nav-item">Users</a>
                    <a href="#courses" class="nav-item">Courses</a>
                    <a href="#assignments" class="nav-item">Assignments</a>
                    <a href="#quizzes" class="nav-item">Quizzes</a>
                    <a href="#grades" class="nav-item">Grades</a>
                    <a href="#notifications" class="nav-item">Notifications</a>
                    <a href="#analytics" class="nav-item">Analytics</a>
                    <h5 class="mt-4">Resources</h5>
                    <a href="#errors" class="nav-item">Error Codes</a>
                    <a href="#rate-limits" class="nav-item">Rate Limits</a>
                    <a href="#webhooks" class="nav-item">Webhooks</a>
                </div>
            </div>
            
            <div class="col-lg-9">
                <!-- Authentication -->
                <section id="authentication">
                    <div class="endpoint-card">
                        <h3>Authentication</h3>
                        <p>AGM Solutions API uses Bearer token authentication. Include your API key in the Authorization header.</p>
                        
                        <h5>Login</h5>
                        <span class="endpoint-method method-post">POST</span>
                        <div class="endpoint-url">/api/auth/login</div>
                        
                        <h6>Request Body:</h6>
                        <div class="code-block">
{
  "email": "student@example.com",
  "password": "yourpassword"
}
                        </div>
                        
                        <h6>Response:</h6>
                        <div class="response-example">
<pre>{
  "success": true,
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 123,
    "email": "student@example.com",
    "role": "Student"
  }
}</pre>
                        </div>
                    </div>
                </section>

                <!-- Users -->
                <section id="users">
                    <div class="endpoint-card">
                        <h3>Users</h3>
                        
                        <h5>Get User Profile</h5>
                        <span class="endpoint-method method-get">GET</span>
                        <div class="endpoint-url">/api/users/{id}</div>
                        
                        <h6>Parameters:</h6>
                        <table class="parameter-table">
                            <thead>
                                <tr>
                                    <th>Parameter</th>
                                    <th>Type</th>
                                    <th>Required</th>
                                    <th>Description</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>id</td>
                                    <td>integer</td>
                                    <td class="required">Required</td>
                                    <td>User ID</td>
                                </tr>
                            </tbody>
                        </table>
                        
                        <h6>Response:</h6>
                        <div class="response-example">
<pre>{
  "id": 123,
  "firstName": "John",
  "lastName": "Doe",
  "email": "john.doe@example.com",
  "role": "Student",
  "enrolledCourses": 5,
  "completedAssignments": 23,
  "averageGrade": 87.5
}</pre>
                        </div>
                    </div>
                </section>

                <!-- Courses -->
                <section id="courses">
                    <div class="endpoint-card">
                        <h3>Courses</h3>
                        
                        <h5>Get All Courses</h5>
                        <span class="endpoint-method method-get">GET</span>
                        <div class="endpoint-url">/api/courses</div>
                        
                        <h6>Query Parameters:</h6>
                        <table class="parameter-table">
                            <thead>
                                <tr>
                                    <th>Parameter</th>
                                    <th>Type</th>
                                    <th>Required</th>
                                    <th>Description</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>page</td>
                                    <td>integer</td>
                                    <td class="optional">Optional</td>
                                    <td>Page number (default: 1)</td>
                                </tr>
                                <tr>
                                    <td>limit</td>
                                    <td>integer</td>
                                    <td class="optional">Optional</td>
                                    <td>Items per page (default: 20)</td>
                                </tr>
                                <tr>
                                    <td>search</td>
                                    <td>string</td>
                                    <td class="optional">Optional</td>
                                    <td>Search term</td>
                                </tr>
                            </tbody>
                        </table>
                        
                        <h5>Enroll in Course</h5>
                        <span class="endpoint-method method-post">POST</span>
                        <div class="endpoint-url">/api/courses/{courseId}/enroll</div>
                        
                        <h6>Request Body:</h6>
                        <div class="code-block">
{
  "studentId": 123
}
                        </div>
                    </div>
                </section>

                <!-- Assignments -->
                <section id="assignments">
                    <div class="endpoint-card">
                        <h3>Assignments</h3>
                        
                        <h5>Get Student Assignments</h5>
                        <span class="endpoint-method method-get">GET</span>
                        <div class="endpoint-url">/api/assignments/student/{studentId}</div>
                        
                        <h5>Submit Assignment</h5>
                        <span class="endpoint-method method-post">POST</span>
                        <div class="endpoint-url">/api/assignments/{assignmentId}/submit</div>
                        
                        <h6>Request Body (Form Data):</h6>
                        <table class="parameter-table">
                            <thead>
                                <tr>
                                    <th>Field</th>
                                    <th>Type</th>
                                    <th>Required</th>
                                    <th>Description</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>studentId</td>
                                    <td>integer</td>
                                    <td class="required">Required</td>
                                    <td>Student ID</td>
                                </tr>
                                <tr>
                                    <td>file</td>
                                    <td>file</td>
                                    <td class="required">Required</td>
                                    <td>Assignment file</td>
                                </tr>
                                <tr>
                                    <td>comments</td>
                                    <td>string</td>
                                    <td class="optional">Optional</td>
                                    <td>Student comments</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </section>

                <!-- Quizzes -->
                <section id="quizzes">
                    <div class="endpoint-card">
                        <h3>Quizzes</h3>
                        
                        <h5>Get Quiz Questions</h5>
                        <span class="endpoint-method method-get">GET</span>
                        <div class="endpoint-url">/api/quizzes/{quizId}/questions</div>
                        
                        <h5>Submit Quiz Answers</h5>
                        <span class="endpoint-method method-post">POST</span>
                        <div class="endpoint-url">/api/quizzes/{quizId}/submit</div>
                        
                        <h6>Request Body:</h6>
                        <div class="code-block">
{
  "studentId": 123,
  "answers": [
    {
      "questionId": 1,
      "selectedOption": "A"
    },
    {
      "questionId": 2,
      "selectedOption": "C"
    }
  ],
  "timeSpent": 1800
}
                        </div>
                        
                        <h6>Response:</h6>
                        <div class="response-example">
<pre>{
  "success": true,
  "score": 85,
  "totalQuestions": 10,
  "correctAnswers": 8,
  "grade": "B+",
  "feedback": "Good job! Review topics 3 and 7."
}</pre>
                        </div>
                    </div>
                </section>

                <!-- Grades -->
                <section id="grades">
                    <div class="endpoint-card">
                        <h3>Grades</h3>
                        
                        <h5>Get Student Grades</h5>
                        <span class="endpoint-method method-get">GET</span>
                        <div class="endpoint-url">/api/grades/student/{studentId}</div>
                        
                        <h5>Get Course Grades</h5>
                        <span class="endpoint-method method-get">GET</span>
                        <div class="endpoint-url">/api/grades/course/{courseId}</div>
                        
                        <h6>Response:</h6>
                        <div class="response-example">
<pre>{
  "grades": [
    {
      "id": 1,
      "courseName": "Computer Science 101",
      "assignmentName": "Binary Search Tree",
      "grade": "A",
      "score": 95,
      "maxScore": 100,
      "submittedDate": "2024-07-15T10:30:00Z",
      "gradedDate": "2024-07-17T14:20:00Z"
    }
  ],
  "averageGrade": 87.5,
  "gpa": 3.4
}</pre>
                        </div>
                    </div>
                </section>

                <!-- Notifications -->
                <section id="notifications">
                    <div class="endpoint-card">
                        <h3>Notifications</h3>
                        
                        <h5>Get User Notifications</h5>
                        <span class="endpoint-method method-get">GET</span>
                        <div class="endpoint-url">/api/notifications/user/{userId}</div>
                        
                        <h5>Mark as Read</h5>
                        <span class="endpoint-method method-put">PUT</span>
                        <div class="endpoint-url">/api/notifications/{notificationId}/read</div>
                        
                        <h5>Send Notification</h5>
                        <span class="endpoint-method method-post">POST</span>
                        <div class="endpoint-url">/api/notifications/send</div>
                        
                        <h6>Request Body:</h6>
                        <div class="code-block">
{
  "recipientId": 123,
  "title": "Assignment Due Reminder",
  "message": "Your assignment is due tomorrow.",
  "type": "assignment",
  "priority": "high"
}
                        </div>
                    </div>
                </section>

                <!-- Analytics -->
                <section id="analytics">
                    <div class="endpoint-card">
                        <h3>Analytics</h3>
                        
                        <h5>Get Student Analytics</h5>
                        <span class="endpoint-method method-get">GET</span>
                        <div class="endpoint-url">/api/analytics/student/{studentId}</div>
                        
                        <h6>Query Parameters:</h6>
                        <table class="parameter-table">
                            <thead>
                                <tr>
                                    <th>Parameter</th>
                                    <th>Type</th>
                                    <th>Required</th>
                                    <th>Description</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>timeRange</td>
                                    <td>string</td>
                                    <td class="optional">Optional</td>
                                    <td>week, month, semester, year</td>
                                </tr>
                                <tr>
                                    <td>metrics</td>
                                    <td>string</td>
                                    <td class="optional">Optional</td>
                                    <td>performance, engagement, time</td>
                                </tr>
                            </tbody>
                        </table>
                        
                        <h6>Response:</h6>
                        <div class="response-example">
<pre>{
  "performanceMetrics": {
    "averageGrade": 87.5,
    "improvementRate": 5.2,
    "attendanceRate": 96
  },
  "engagementMetrics": {
    "forumPosts": 23,
    "discussionParticipation": 78,
    "resourcesAccessed": 156
  },
  "timeMetrics": {
    "totalStudyTime": 42,
    "averageSessionTime": 35,
    "peakStudyHours": [9, 10, 11, 14, 15]
  }
}</pre>
                        </div>
                    </div>
                </section>

                <!-- Error Codes -->
                <section id="errors">
                    <div class="endpoint-card">
                        <h3>Error Codes</h3>
                        
                        <table class="parameter-table">
                            <thead>
                                <tr>
                                    <th>Code</th>
                                    <th>Message</th>
                                    <th>Description</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>400</td>
                                    <td>Bad Request</td>
                                    <td>Invalid request parameters</td>
                                </tr>
                                <tr>
                                    <td>401</td>
                                    <td>Unauthorized</td>
                                    <td>Authentication required</td>
                                </tr>
                                <tr>
                                    <td>403</td>
                                    <td>Forbidden</td>
                                    <td>Insufficient permissions</td>
                                </tr>
                                <tr>
                                    <td>404</td>
                                    <td>Not Found</td>
                                    <td>Resource not found</td>
                                </tr>
                                <tr>
                                    <td>429</td>
                                    <td>Rate Limit Exceeded</td>
                                    <td>Too many requests</td>
                                </tr>
                                <tr>
                                    <td>500</td>
                                    <td>Internal Server Error</td>
                                    <td>Server error occurred</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </section>

                <!-- Rate Limits -->
                <section id="rate-limits">
                    <div class="endpoint-card">
                        <h3>Rate Limits</h3>
                        <p>API requests are limited to prevent abuse and ensure fair usage:</p>
                        
                        <ul>
                            <li><strong>General API calls:</strong> 1000 requests per hour</li>
                            <li><strong>Authentication:</strong> 10 login attempts per minute</li>
                            <li><strong>File uploads:</strong> 100 MB per hour</li>
                            <li><strong>Search requests:</strong> 200 requests per hour</li>
                        </ul>
                        
                        <p>Rate limit headers are included in responses:</p>
                        <div class="code-block">
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1609459200
                        </div>
                    </div>
                </section>

                <!-- Webhooks -->
                <section id="webhooks">
                    <div class="endpoint-card">
                        <h3>Webhooks</h3>
                        <p>Subscribe to real-time events from AGM Solutions:</p>
                        
                        <h5>Available Events:</h5>
                        <ul>
                            <li><code>assignment.submitted</code> - Student submits assignment</li>
                            <li><code>grade.published</code> - Grade is published</li>
                            <li><code>user.enrolled</code> - Student enrolls in course</li>
                            <li><code>quiz.completed</code> - Student completes quiz</li>
                            <li><code>notification.sent</code> - Notification is sent</li>
                        </ul>
                        
                        <h5>Webhook Payload Example:</h5>
                        <div class="code-block">
{
  "event": "assignment.submitted",
  "timestamp": "2024-07-15T10:30:00Z",
  "data": {
    "assignmentId": 123,
    "studentId": 456,
    "courseName": "Computer Science 101",
    "submittedAt": "2024-07-15T10:30:00Z"
  }
}
                        </div>
                    </div>
                </section>
            </div>
        </div>
    </div>

    <script>
        // Smooth scrolling for navigation
        document.querySelectorAll('.nav-item').forEach(item => {
            item.addEventListener('click', function(e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({ behavior: 'smooth', block: 'start' });
                    
                    // Update active state
                    document.querySelectorAll('.nav-item').forEach(nav => nav.classList.remove('active'));
                    this.classList.add('active');
                }
            });
        });

        // Highlight current section on scroll
        window.addEventListener('scroll', function() {
            const sections = document.querySelectorAll('section');
            const navItems = document.querySelectorAll('.nav-item');
            
            let current = '';
            sections.forEach(section => {
                const sectionTop = section.offsetTop - 100;
                if (window.pageYOffset >= sectionTop) {
                    current = section.getAttribute('id');
                }
            });
            
            navItems.forEach(item => {
                item.classList.remove('active');
                if (item.getAttribute('href') === `#${current}`) {
                    item.classList.add('active');
                }
            });
        });
    </script>
</asp:Content>
