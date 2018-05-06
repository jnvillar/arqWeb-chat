package chat

class Chat {

    String topic
    ChatType type
    List<Message> messages
    static hasMany = [members: User, messages: Message]

    static constraints = {
    }


}
