<%@ Page Title="Take Quiz" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="TakeQuiz.aspx.cs" Inherits="AGMSolutions.Students.TakeQuiz" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <style>
        .quiz-container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .quiz-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        .timer-display {
            background: rgba(255,255,255,0.2);
            border-radius: 10px;
            padding: 10px 20px;
            display: inline-block;
            font-size: 18px;
            font-weight: bold;
            margin-top: 15px;
        }
        .question-container {
            padding: 30px;
        }
        .question-number {
            background: #667eea;
            color: white;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            margin-bottom: 20px;
        }
        .option-item {
            background: #f8f9fa;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            padding: 15px;
            margin: 10px 0;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .option-item:hover {
            background: #e3f2fd;
            border-color: #2196f3;
        }
        .option-item.selected {
            background: #e3f2fd;
            border-color: #2196f3;
            box-shadow: 0 0 10px rgba(33, 150, 243, 0.3);
        }
        .drag-drop-area {
            min-height: 60px;
            border: 2px dashed #ddd;
            border-radius: 10px;
            padding: 15px;
            background: #f8f9fa;
            margin: 15px 0;
        }
        .drag-drop-area.active {
            border-color: #28a745;
            background: #d4edda;
        }
        .draggable-option {
            background: #007bff;
            color: white;
            padding: 8px 15px;
            border-radius: 20px;
            display: inline-block;
            margin: 5px;
            cursor: move;
            user-select: none;
        }
        .progress-bar-container {
            background: #e9ecef;
            height: 6px;
            border-radius: 3px;
            overflow: hidden;
            margin-bottom: 20px;
        }
        .progress-bar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            height: 100%;
            transition: width 0.3s ease;
        }
        .quiz-navigation {
            padding: 20px 30px;
            background: #f8f9fa;
            border-top: 1px solid #e9ecef;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .proctoring-warning {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            color: #856404;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-5">
        <!-- Proctoring Warning -->
        <div class="proctoring-warning text-center">
            <i class="fas fa-exclamation-triangle me-2"></i>
            <strong>Proctored Quiz:</strong> Please ensure you're in a quiet environment. Tab switching will be monitored.
        </div>

        <div class="quiz-container">
            <!-- Quiz Header -->
            <div class="quiz-header">
                <h2 id="quizTitle" runat="server">Quiz Title</h2>
                <p id="quizDescription" runat="server">Quiz Description</p>
                <div class="timer-display">
                    <i class="fas fa-clock me-2"></i>
                    Time Remaining: <span id="timerDisplay">30:00</span>
                </div>
            </div>

            <!-- Progress Bar -->
            <div class="progress-bar-container">
                <div class="progress-bar" id="progressBar" style="width: 0%"></div>
            </div>

            <!-- Question Container -->
            <div class="question-container">
                <div class="question-number" id="questionNumber">1</div>
                
                <!-- MCQ Question -->
                <div id="mcqQuestion" class="question-type" style="display: none;">
                    <h4 id="mcqText" class="mb-4">Question text will appear here</h4>
                    <div id="mcqOptions" class="options-container">
                        <!-- MCQ options will be populated here -->
                    </div>
                </div>

                <!-- Drag & Drop Question -->
                <div id="dragDropQuestion" class="question-type" style="display: none;">
                    <h4 id="dragDropText" class="mb-4">Question text will appear here</h4>
                    <div class="drag-drop-area" id="dropZone">
                        Drop your answer here
                    </div>
                    <div id="dragOptions" class="mt-3">
                        <!-- Draggable options will be populated here -->
                    </div>
                </div>

                <!-- Dropdown Multiple Question -->
                <div id="dropdownQuestion" class="question-type" style="display: none;">
                    <h4 id="dropdownText" class="mb-4">Question text will appear here</h4>
                    <div id="dropdownOptions" class="options-container">
                        <!-- Dropdown options will be populated here -->
                    </div>
                </div>

                <!-- Question Info -->
                <div class="mt-4">
                    <small class="text-muted">
                        Points: <span id="questionPoints">5</span> | 
                        Question <span id="currentQuestionNum">1</span> of <span id="totalQuestions">10</span>
                    </small>
                </div>
            </div>

            <!-- Navigation -->
            <div class="quiz-navigation">
                <button type="button" id="btnPrevious" class="btn btn-outline-secondary" onclick="previousQuestion()">
                    <i class="fas fa-arrow-left me-2"></i>Previous
                </button>
                <div>
                    <button type="button" id="btnNext" class="btn btn-primary" onclick="nextQuestion()">
                        Next<i class="fas fa-arrow-right ms-2"></i>
                    </button>
                    <button type="button" id="btnSubmit" class="btn btn-success" onclick="submitQuiz()" style="display: none;">
                        <i class="fas fa-check me-2"></i>Submit Quiz
                    </button>
                </div>
            </div>
        </div>

        <!-- Hidden form data -->
        <asp:HiddenField ID="hdnQuizData" runat="server" />
        <asp:HiddenField ID="hdnCurrentQuestion" runat="server" Value="0" />
        <asp:HiddenField ID="hdnAnswers" runat="server" />
        <asp:HiddenField ID="hdnQuizDuration" runat="server" />
        
        <!-- Submit form -->
        <asp:Button ID="btnSubmitQuiz" runat="server" OnClick="btnSubmitQuiz_Click" style="display: none;" />
    </div>

    <script>
        let quizData = null;
        let currentQuestion = 0;
        let answers = {};
        let timerInterval = null;
        let timeRemaining = 0;
        let tabSwitchCount = 0;

        // Initialize quiz when page loads
        window.onload = function() {
            initializeQuiz();
            startTimer();
            setupProctoring();
        };

        function initializeQuiz() {
            const quizDataHidden = document.getElementById('<%= hdnQuizData.ClientID %>');
            if (quizDataHidden.value) {
                quizData = JSON.parse(quizDataHidden.value);
                timeRemaining = quizData.QuizDurationMinutes * 60; // Convert to seconds
                document.getElementById('<%= hdnQuizDuration.ClientID %>').value = timeRemaining;
                
                document.getElementById('quizTitle').innerText = quizData.QuizTitle;
                document.getElementById('totalQuestions').innerText = quizData.Questions.length;
                
                loadQuestion(0);
            }
        }

        function loadQuestion(questionIndex) {
            if (!quizData || questionIndex >= quizData.Questions.length) return;

            const question = quizData.Questions[questionIndex];
            currentQuestion = questionIndex;
            
            // Update progress
            const progress = ((questionIndex + 1) / quizData.Questions.length) * 100;
            document.getElementById('progressBar').style.width = progress + '%';
            
            // Update question number
            document.getElementById('questionNumber').innerText = questionIndex + 1;
            document.getElementById('currentQuestionNum').innerText = questionIndex + 1;
            document.getElementById('questionPoints').innerText = question.Points;

            // Hide all question types
            document.querySelectorAll('.question-type').forEach(div => div.style.display = 'none');

            // Show appropriate question type
            if (question.TYPE === 'MCQ') {
                loadMCQQuestion(question);
            } else if (question.TYPE === 'DRAGDROP') {
                loadDragDropQuestion(question);
            } else if (question.TYPE === 'DROPDOWN') {
                loadDropdownQuestion(question);
            }

            // Update navigation buttons
            updateNavigation();
        }

        function loadMCQQuestion(question) {
            document.getElementById('mcqQuestion').style.display = 'block';
            document.getElementById('mcqText').innerText = question.QuestionText;
            
            const optionsContainer = document.getElementById('mcqOptions');
            optionsContainer.innerHTML = '';
            
            Object.keys(question.Options).forEach(optionKey => {
                const optionDiv = document.createElement('div');
                optionDiv.className = 'option-item';
                optionDiv.innerHTML = `
                    <input type="radio" name="mcq_${question.Q_ID}" value="${optionKey}" id="opt_${optionKey}" style="margin-right: 10px;">
                    <label for="opt_${optionKey}">${question.Options[optionKey]}</label>
                `;
                optionDiv.onclick = () => selectMCQOption(optionKey, question.Q_ID);
                optionsContainer.appendChild(optionDiv);
            });

            // Restore previous answer if exists
            if (answers[question.Q_ID]) {
                const radio = document.querySelector(`input[name="mcq_${question.Q_ID}"][value="${answers[question.Q_ID]}"]`);
                if (radio) {
                    radio.checked = true;
                    radio.closest('.option-item').classList.add('selected');
                }
            }
        }

        function loadDragDropQuestion(question) {
            document.getElementById('dragDropQuestion').style.display = 'block';
            document.getElementById('dragDropText').innerText = question.QuestionText;
            
            const dropZone = document.getElementById('dropZone');
            const optionsContainer = document.getElementById('dragOptions');
            
            // Clear previous content
            dropZone.innerHTML = 'Drop your answer here';
            optionsContainer.innerHTML = '';
            
            // Create draggable options
            Object.keys(question.Options).forEach(optionKey => {
                const optionDiv = document.createElement('div');
                optionDiv.className = 'draggable-option';
                optionDiv.draggable = true;
                optionDiv.innerText = question.Options[optionKey];
                optionDiv.setAttribute('data-value', optionKey);
                
                optionDiv.ondragstart = (e) => {
                    e.dataTransfer.setData('text/plain', optionKey);
                };
                
                optionsContainer.appendChild(optionDiv);
            });
            
            // Setup drop zone
            dropZone.ondragover = (e) => {
                e.preventDefault();
                dropZone.classList.add('active');
            };
            
            dropZone.ondragleave = () => {
                dropZone.classList.remove('active');
            };
            
            dropZone.ondrop = (e) => {
                e.preventDefault();
                const optionKey = e.dataTransfer.getData('text/plain');
                dropZone.innerHTML = question.Options[optionKey];
                dropZone.classList.remove('active');
                answers[question.Q_ID] = optionKey;
                saveAnswers();
            };
        }

        function loadDropdownQuestion(question) {
            document.getElementById('dropdownQuestion').style.display = 'block';
            document.getElementById('dropdownText').innerText = question.QuestionText;
            
            const optionsContainer = document.getElementById('dropdownOptions');
            optionsContainer.innerHTML = '';
            
            Object.keys(question.Options).forEach(optionKey => {
                const optionDiv = document.createElement('div');
                optionDiv.className = 'option-item';
                optionDiv.innerHTML = `
                    <input type="checkbox" value="${optionKey}" id="chk_${optionKey}" style="margin-right: 10px;">
                    <label for="chk_${optionKey}">${question.Options[optionKey]}</label>
                `;
                optionDiv.onclick = () => toggleDropdownOption(optionKey, question.Q_ID);
                optionsContainer.appendChild(optionDiv);
            });

            // Restore previous answers if exists
            if (answers[question.Q_ID]) {
                const selectedOptions = answers[question.Q_ID];
                selectedOptions.forEach(optionKey => {
                    const checkbox = document.getElementById(`chk_${optionKey}`);
                    if (checkbox) {
                        checkbox.checked = true;
                        checkbox.closest('.option-item').classList.add('selected');
                    }
                });
            }
        }

        function selectMCQOption(optionKey, questionId) {
            // Clear all selections
            document.querySelectorAll(`input[name="mcq_${questionId}"]`).forEach(radio => {
                radio.closest('.option-item').classList.remove('selected');
            });
            
            // Select current option
            const radio = document.querySelector(`input[name="mcq_${questionId}"][value="${optionKey}"]`);
            radio.checked = true;
            radio.closest('.option-item').classList.add('selected');
            
            answers[questionId] = optionKey;
            saveAnswers();
        }

        function toggleDropdownOption(optionKey, questionId) {
            const checkbox = document.getElementById(`chk_${optionKey}`);
            checkbox.checked = !checkbox.checked;
            checkbox.closest('.option-item').classList.toggle('selected');
            
            if (!answers[questionId]) answers[questionId] = [];
            
            if (checkbox.checked) {
                if (!answers[questionId].includes(optionKey)) {
                    answers[questionId].push(optionKey);
                }
            } else {
                answers[questionId] = answers[questionId].filter(opt => opt !== optionKey);
            }
            saveAnswers();
        }

        function saveAnswers() {
            document.getElementById('<%= hdnAnswers.ClientID %>').value = JSON.stringify(answers);
        }

        function nextQuestion() {
            if (currentQuestion < quizData.Questions.length - 1) {
                loadQuestion(currentQuestion + 1);
            }
        }

        function previousQuestion() {
            if (currentQuestion > 0) {
                loadQuestion(currentQuestion - 1);
            }
        }

        function updateNavigation() {
            document.getElementById('btnPrevious').style.display = currentQuestion === 0 ? 'none' : 'inline-block';
            
            if (currentQuestion === quizData.Questions.length - 1) {
                document.getElementById('btnNext').style.display = 'none';
                document.getElementById('btnSubmit').style.display = 'inline-block';
            } else {
                document.getElementById('btnNext').style.display = 'inline-block';
                document.getElementById('btnSubmit').style.display = 'none';
            }
        }

        function startTimer() {
            timerInterval = setInterval(() => {
                timeRemaining--;
                updateTimerDisplay();
                
                if (timeRemaining <= 0) {
                    clearInterval(timerInterval);
                    alert('Time is up! Quiz will be submitted automatically.');
                    submitQuiz();
                }
            }, 1000);
        }

        function updateTimerDisplay() {
            const minutes = Math.floor(timeRemaining / 60);
            const seconds = timeRemaining % 60;
            document.getElementById('timerDisplay').innerText = 
                `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
        }

        function setupProctoring() {
            // Basic proctoring features
            document.addEventListener('visibilitychange', () => {
                if (document.hidden) {
                    tabSwitchCount++;
                    console.log('Tab switch detected:', tabSwitchCount);
                    
                    if (tabSwitchCount >= 3) {
                        alert('Multiple tab switches detected. Quiz will be submitted for review.');
                    }
                }
            });

            // Disable right-click
            document.addEventListener('contextmenu', e => e.preventDefault());
            
            // Disable F12, Ctrl+Shift+I, etc.
            document.addEventListener('keydown', (e) => {
                if (e.key === 'F12' || 
                    (e.ctrlKey && e.shiftKey && e.key === 'I') ||
                    (e.ctrlKey && e.shiftKey && e.key === 'C') ||
                    (e.ctrlKey && e.key === 'u')) {
                    e.preventDefault();
                    alert('Developer tools are disabled during the quiz.');
                }
            });
        }

        function submitQuiz() {
            if (confirm('Are you sure you want to submit the quiz? This action cannot be undone.')) {
                saveAnswers();
                clearInterval(timerInterval);
                document.getElementById('<%= btnSubmitQuiz.ClientID %>').click();
            }
        }

        // Prevent accidental navigation
        window.addEventListener('beforeunload', (e) => {
            e.preventDefault();
            e.returnValue = '';
        });
    </script>
</asp:Content>
