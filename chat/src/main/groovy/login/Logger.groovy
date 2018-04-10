package login

import chat.Message

class Logger {

    static logMessage(Message message){
        println "message: ${message.message} send to ${message.chat.topic}"
    }
}
