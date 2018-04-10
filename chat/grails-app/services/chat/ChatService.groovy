package chat

import grails.gorm.transactions.Transactional

@Transactional
class ChatService {
    MessageService messageService

    def getAllByUser(User user) {
        List<Chat> chats = Chat.findAllByMembersInList([user])
        chats
    }

    def createChat(List<User> users) {
        String chatName = "/topic/${users.name.join()}"
        Chat chat = new Chat([topic: chatName, members: users as Set])
        chat.save(flush: true, failOnError: true)
    }

    def getByUsers(List<User> users) {
        Chat chat = Chat.all.find { it.members == users as Set }
        if (!chat) chat = createChat(users)
        chat
    }

    def getByTopic(String topic) {
        Chat.findByTopic(topic)
    }

    def addMessage(Chat chat, User user, String msg) {
        Message message = messageService.create(chat, user , msg)
        chat.addToMessages(message)
        chat.save(flush: true, failOnError: true)
        message
    }

    def get(Long id){
        Chat.findById(id)
    }

}
