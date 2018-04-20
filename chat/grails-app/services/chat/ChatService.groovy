package chat

import grails.converters.JSON
import grails.gorm.transactions.Transactional
import login.Logger
import org.springframework.messaging.simp.SimpMessageSendingOperations

@Transactional
class ChatService {
    MessageService messageService
    SimpMessageSendingOperations brokerMessagingTemplate

    def getAllByUser(User user) {
        List<Chat> chats = Chat.findAll().findAll { it.members.contains(user) }
        chats
    }

    def createChat(List<User> users) {
        String chatName = "/topic/${users.name.join()}"
        Chat chat = new Chat([topic: chatName, members: users as Set])
        chat.save(flush: true, failOnError: true)
    }

    def getByUsers(List<User> users) {
        Chat chat = Chat.all.find { it.members as Set == users as Set }
        if (!chat) chat = createChat(users)
        chat
    }

    def getByTopic(String topic) {
        Chat.findByTopic(topic)
    }

    def addMessage(Chat chat, User user, String msg, String attachment) {
        Message message = messageService.create(chat, user, msg, attachment)
        chat.addToMessages(message)
        chat.save(flush: true, failOnError: true)
        message
    }

    def get(Long id) {
        Chat.findById(id)
    }

    def sendToChat(Message message) {
        brokerMessagingTemplate.convertAndSend message.chat.topic, (message.toMap() as JSON).toString()
        Logger.logMessageToChat(message)
    }

    def sendToUsers(Message message) {
        message.chat.members.each { User user ->
            brokerMessagingTemplate.convertAndSend user.topic, (message.toMap() as JSON).toString()
            Logger.logMessageToUser(message, user)
        }
    }
}
