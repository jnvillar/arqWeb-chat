package chat

class Chat {

    String topic
    List<Message> messages
    static hasMany = [members: User, messages: Message]

    static constraints = {
    }


}
