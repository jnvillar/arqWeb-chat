package chat

import grails.gorm.transactions.Transactional

@Transactional
class MessageService {

    def create(Chat chat, User user, String msg) {
        Message message = new Message([chat:chat, message: msg, user: user])
        message
    }
}
