using System;
using System.Collections.Generic;

namespace AGMSolutions.App_Code.Models
{
    public class QuizQuestion
    {
        public int QuizQuestionID { get; set; }
        public int QuestionID { get; set; } // Alternative property name
        public int QuizID { get; set; }
        public string QuestionText { get; set; }
        public string QuestionType { get; set; } = "MultipleChoice";
        public List<string> Options { get; set; } = new List<string>();
        public string CorrectAnswerValue { get; set; }
        public string CorrectAnswer { get; set; } // Writable property for compatibility
        public string OptionsJson { get; set; } // JSON format of options
        public int QuestionOrder { get; set; } // Order in the quiz
        public int Points { get; set; } = 1;
        public DateTime DateCreated { get; set; } = DateTime.Now;
        public bool IsActive { get; set; } = true;

        // For display purposes
        public string FormattedOptions
        {
            get
            {
                if (Options == null || Options.Count == 0)
                    return string.Empty;

                return string.Join("|", Options);
            }
            set
            {
                if (!string.IsNullOrEmpty(value))
                {
                    Options = new List<string>(value.Split('|'));
                }
            }
        }
    }
}
