package login

import chat.Message
import chat.User

class Logger {

    static logMessageToChat(Message message){
        println "message: ${message.message} send to ${message.chat.topic} to chat ${message.chat.id}"
    }

    static logMessageToUser(Message message, User user){
        println "message: ${message.message} send to ${user.name} to topic ${user.topic}"
    }
}
