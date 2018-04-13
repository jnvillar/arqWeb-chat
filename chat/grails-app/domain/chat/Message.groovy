package chat

class Message {

    User user
    Chat chat
    Date timestamp = new Date()
    String message

    static belongsTo = Chat

    static constraints = {
        message(maxSize: 10000)
    }

    def toMap(){
        [
                user: user.name,
                chat: chat.id,
                timestamp: timestamp,
                message:message,
        ]
    }
}
