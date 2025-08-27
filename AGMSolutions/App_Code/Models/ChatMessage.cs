namespace AGMSolutions.App_Code.Models
{
    public class ChatMessage
    {
        public int MessageID { get; set; }
        public int SenderID { get; set; }
        public int? ReceiverID { get; set; }
        public int? GroupID { get; set; }
        public string Message { get; set; }
        public string MessageType { get; set; }
        public bool IsRead { get; set; }
        public System.DateTime SentDate { get; set; }
        public string SenderName { get; set; }
        public string ReceiverName { get; set; }
    }
}
