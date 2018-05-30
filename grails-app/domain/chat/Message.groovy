package chat

class Message {

    User user
    Chat chat
    Date timestamp = new Date()
    String message
    Attachment attachment

    static belongsTo = Chat

    static constraints = {
        message(maxSize: 10000, nullable: true)
        attachment(nullable: true)
    }

    def toMap() {
        [
                user               : user.name,
                chat               : chat.id,
                chatTopic          : chat.topic,
                timestamp          : timestamp,
                message            : message,
                attachment         : attachment?.bytes,
                attachmentType     : attachment?.type?.name(),
                attachmentExtension: attachment?.extensions
        ]
    }
}
