<%@ Page Title="Certificates" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Certificates.aspx.cs" Inherits="AGMSolutions.Students.Certificates" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .certificates-container {
            max-width: 1000px;
            margin: 20px auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            padding: 30px;
        }
        .certificate-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px;
            padding: 30px;
            margin: 20px 0;
            color: white;
            position: relative;
            overflow: hidden;
        }
        .certificate-card::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="50" cy="50" r="40" fill="none" stroke="rgba(255,255,255,0.1)" stroke-width="2"/></svg>');
            animation: rotate 20s linear infinite;
        }
        @keyframes rotate {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }
        .certificate-content {
            position: relative;
            z-index: 2;
        }
        .certificate-title {
            font-size: 1.8rem;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .certificate-course {
            font-size: 1.2rem;
            opacity: 0.9;
            margin-bottom: 15px;
        }
        .certificate-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin: 20px 0;
        }
        .certificate-detail {
            background: rgba(255,255,255,0.1);
            padding: 15px;
            border-radius: 10px;
            text-align: center;
        }
        .certificate-actions {
            display: flex;
            gap: 15px;
            margin-top: 20px;
        }
        .btn-certificate {
            background: rgba(255,255,255,0.2);
            border: 2px solid white;
            color: white;
            padding: 10px 20px;
            border-radius: 25px;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        .btn-certificate:hover {
            background: white;
            color: #667eea;
            transform: translateY(-2px);
        }
        .no-certificates {
            text-align: center;
            padding: 50px;
            color: #666;
        }
        .achievement-badge {
            background: #ffd700;
            color: #333;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            display: inline-block;
            margin: 5px;
        }
        .certificate-preview {
            background: white;
            border: 2px solid #ddd;
            border-radius: 10px;
            padding: 40px;
            margin: 20px 0;
            text-align: center;
            color: #333;
            position: relative;
        }
        .certificate-border {
            border: 5px solid #007bff;
            border-image: linear-gradient(45deg, #007bff, #28a745) 1;
            padding: 20px;
            margin: 10px;
        }
        .certificate-seal {
            position: absolute;
            bottom: 20px;
            right: 20px;
            width: 80px;
            height: 80px;
            background: radial-gradient(circle, #ffd700, #ff8c00);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 12px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="certificates-container">
        <div class="text-center mb-4">
            <h1><i class="fas fa-certificate"></i> My Certificates</h1>
            <p class="text-muted">Your achievements and course completion certificates</p>
        </div>

        <!-- Achievement Summary -->
        <div class="row mb-4">
            <div class="col-md-3 text-center">
                <div class="card bg-primary text-white">
                    <div class="card-body">
                        <h3>3</h3>
                        <p>Certificates Earned</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3 text-center">
                <div class="card bg-success text-white">
                    <div class="card-body">
                        <h3>87%</h3>
                        <p>Average Score</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3 text-center">
                <div class="card bg-info text-white">
                    <div class="card-body">
                        <h3>4</h3>
                        <p>Courses Completed</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3 text-center">
                <div class="card bg-warning text-white">
                    <div class="card-body">
                        <h3>Gold</h3>
                        <p>Achievement Level</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Certificates List -->
        <div class="certificates-list">
            <!-- Certificate 1: Computer Science 101 -->
            <div class="certificate-card">
                <div class="certificate-content">
                    <div class="certificate-title">
                        <i class="fas fa-award"></i> Course Completion Certificate
                    </div>
                    <div class="certificate-course">Computer Science 101 - Introduction to Programming</div>
                    
                    <div class="certificate-details">
                        <div class="certificate-detail">
                            <strong>Grade Achieved</strong><br>
                            A+ (95%)
                        </div>
                        <div class="certificate-detail">
                            <strong>Completion Date</strong><br>
                            July 15, 2024
                        </div>
                        <div class="certificate-detail">
                            <strong>Instructor</strong><br>
                            Dr. John Smith
                        </div>
                        <div class="certificate-detail">
                            <strong>Duration</strong><br>
                            12 Weeks
                        </div>
                    </div>

                    <div class="mb-3">
                        <span class="achievement-badge">Excellence Award</span>
                        <span class="achievement-badge">Perfect Attendance</span>
                        <span class="achievement-badge">Top 5% Student</span>
                    </div>

                    <div class="certificate-actions">
                        <a href="#" onclick="downloadCertificate('CS101')" class="btn-certificate">
                            <i class="fas fa-download"></i> Download PDF
                        </a>
                        <a href="#" onclick="shareCertificate('CS101')" class="btn-certificate">
                            <i class="fas fa-share-alt"></i> Share
                        </a>
                        <a href="#" onclick="verifyCertificate('CS101')" class="btn-certificate">
                            <i class="fas fa-check-circle"></i> Verify
                        </a>
                        <a href="#" onclick="previewCertificate('CS101')" class="btn-certificate">
                            <i class="fas fa-eye"></i> Preview
                        </a>
                    </div>
                </div>
            </div>

            <!-- Certificate 2: Mathematics 201 -->
            <div class="certificate-card" style="background: linear-gradient(135deg, #28a745 0%, #20c997 100%);">
                <div class="certificate-content">
                    <div class="certificate-title">
                        <i class="fas fa-medal"></i> Course Completion Certificate
                    </div>
                    <div class="certificate-course">Mathematics 201 - Calculus I</div>
                    
                    <div class="certificate-details">
                        <div class="certificate-detail">
                            <strong>Grade Achieved</strong><br>
                            B+ (88%)
                        </div>
                        <div class="certificate-detail">
                            <strong>Completion Date</strong><br>
                            June 20, 2024
                        </div>
                        <div class="certificate-detail">
                            <strong>Instructor</strong><br>
                            Prof. Sarah Johnson
                        </div>
                        <div class="certificate-detail">
                            <strong>Duration</strong><br>
                            16 Weeks
                        </div>
                    </div>

                    <div class="mb-3">
                        <span class="achievement-badge">High Achiever</span>
                        <span class="achievement-badge">Problem Solver</span>
                    </div>

                    <div class="certificate-actions">
                        <a href="#" onclick="downloadCertificate('MATH201')" class="btn-certificate">
                            <i class="fas fa-download"></i> Download PDF
                        </a>
                        <a href="#" onclick="shareCertificate('MATH201')" class="btn-certificate">
                            <i class="fas fa-share-alt"></i> Share
                        </a>
                        <a href="#" onclick="verifyCertificate('MATH201')" class="btn-certificate">
                            <i class="fas fa-check-circle"></i> Verify
                        </a>
                        <a href="#" onclick="previewCertificate('MATH201')" class="btn-certificate">
                            <i class="fas fa-eye"></i> Preview
                        </a>
                    </div>
                </div>
            </div>

            <!-- Certificate 3: English 101 -->
            <div class="certificate-card" style="background: linear-gradient(135deg, #fd7e14 0%, #e83e8c 100%);">
                <div class="certificate-content">
                    <div class="certificate-title">
                        <i class="fas fa-trophy"></i> Course Completion Certificate
                    </div>
                    <div class="certificate-course">English 101 - Academic Writing</div>
                    
                    <div class="certificate-details">
                        <div class="certificate-detail">
                            <strong>Grade Achieved</strong><br>
                            A (92%)
                        </div>
                        <div class="certificate-detail">
                            <strong>Completion Date</strong><br>
                            May 30, 2024
                        </div>
                        <div class="certificate-detail">
                            <strong>Instructor</strong><br>
                            Dr. Emily Davis
                        </div>
                        <div class="certificate-detail">
                            <strong>Duration</strong><br>
                            10 Weeks
                        </div>
                    </div>

                    <div class="mb-3">
                        <span class="achievement-badge">Outstanding Writer</span>
                        <span class="achievement-badge">Creative Excellence</span>
                    </div>

                    <div class="certificate-actions">
                        <a href="#" onclick="downloadCertificate('ENG101')" class="btn-certificate">
                            <i class="fas fa-download"></i> Download PDF
                        </a>
                        <a href="#" onclick="shareCertificate('ENG101')" class="btn-certificate">
                            <i class="fas fa-share-alt"></i> Share
                        </a>
                        <a href="#" onclick="verifyCertificate('ENG101')" class="btn-certificate">
                            <i class="fas fa-check-circle"></i> Verify
                        </a>
                        <a href="#" onclick="previewCertificate('ENG101')" class="btn-certificate">
                            <i class="fas fa-eye"></i> Preview
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Certificate Preview Modal -->
        <div id="certificatePreview" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.8); z-index: 1000; justify-content: center; align-items: center;">
            <div style="background: white; padding: 20px; border-radius: 10px; max-width: 800px; width: 90%;">
                <div class="text-right">
                    <button onclick="closeCertificatePreview()" class="btn btn-danger btn-sm">
                        <i class="fas fa-times"></i> Close
                    </button>
                </div>
                
                <div class="certificate-preview">
                    <div class="certificate-border">
                        <h2 style="color: #007bff; margin-bottom: 20px;">AGM Solutions</h2>
                        <h3 style="margin-bottom: 30px;">Certificate of Completion</h3>
                        
                        <p style="font-size: 18px; margin: 20px 0;">This is to certify that</p>
                        <h3 style="color: #28a745; margin: 20px 0;">
                            <asp:Label ID="lblStudentName" runat="server" Text="John Doe"></asp:Label>
                        </h3>
                        <p style="font-size: 18px; margin: 20px 0;">has successfully completed the course</p>
                        <h4 id="previewCourseName" style="color: #007bff; margin: 20px 0;">Course Name</h4>
                        
                        <div style="margin: 30px 0;">
                            <p><strong>Grade:</strong> <span id="previewGrade">A+</span></p>
                            <p><strong>Date:</strong> <span id="previewDate">July 15, 2024</span></p>
                            <p><strong>Instructor:</strong> <span id="previewInstructor">Dr. Smith</span></p>
                        </div>

                        <div class="certificate-seal">
                            <div>AGM<br>SEAL</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function downloadCertificate(courseCode) {
            // Generate and download certificate PDF
            alert(`Downloading certificate for ${courseCode}...`);
            // Here you would typically call a server method to generate the PDF
        }

        function shareCertificate(courseCode) {
            if (navigator.share) {
                navigator.share({
                    title: `Certificate - ${courseCode}`,
                    text: 'Check out my course completion certificate!',
                    url: window.location.href + '?cert=' + courseCode
                });
            } else {
                // Fallback for browsers that don't support Web Share API
                const url = window.location.href + '?cert=' + courseCode;
                navigator.clipboard.writeText(url).then(() => {
                    alert('Certificate link copied to clipboard!');
                });
            }
        }

        function verifyCertificate(courseCode) {
            alert(`Certificate ${courseCode} is verified and authentic.`);
        }

        function previewCertificate(courseCode) {
            // Update preview content based on course
            const courseData = {
                'CS101': {
                    name: 'Computer Science 101 - Introduction to Programming',
                    grade: 'A+ (95%)',
                    date: 'July 15, 2024',
                    instructor: 'Dr. John Smith'
                },
                'MATH201': {
                    name: 'Mathematics 201 - Calculus I',
                    grade: 'B+ (88%)',
                    date: 'June 20, 2024',
                    instructor: 'Prof. Sarah Johnson'
                },
                'ENG101': {
                    name: 'English 101 - Academic Writing',
                    grade: 'A (92%)',
                    date: 'May 30, 2024',
                    instructor: 'Dr. Emily Davis'
                }
            };

            const course = courseData[courseCode];
            if (course) {
                document.getElementById('previewCourseName').textContent = course.name;
                document.getElementById('previewGrade').textContent = course.grade;
                document.getElementById('previewDate').textContent = course.date;
                document.getElementById('previewInstructor').textContent = course.instructor;
            }

            document.getElementById('certificatePreview').style.display = 'flex';
        }

        function closeCertificatePreview() {
            document.getElementById('certificatePreview').style.display = 'none';
        }
    </script>
</asp:Content>
