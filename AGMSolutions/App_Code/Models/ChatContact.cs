namespace AGMSolutions.App_Code.Models
{
    public class ChatContact
    {
        public int ContactID { get; set; }
        public int UserID { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public string Role { get; set; }
        public string ContactName { get; set; }
        public string ContactRole { get; set; }
        public string ContactAvatar { get; set; }
        public bool IsOnline { get; set; }
        public System.DateTime? LastSeen { get; set; }
        public string LastMessage { get; set; }
        public System.DateTime? LastMessageDate { get; set; }
        public int UnreadCount { get; set; }
    }
}
