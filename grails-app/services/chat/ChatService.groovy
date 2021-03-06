package chat

import clients.ApiClient
import grails.converters.JSON
import login.Logger
import org.springframework.messaging.simp.SimpMessageSendingOperations
import user.UserType

class ChatService {
    MessageService messageService
    SimpMessageSendingOperations brokerMessagingTemplate
    ApiClient apiClient = new ApiClient()

    String publicIntegrationUrl =  "https://awebchat-integration.herokuapp.com/public/send"
    String privateIntegrationUrl = "https://awebchat-integration.herokuapp.com/private/send"


    def getAllByUser(User user) {
        List<Chat> chats = Chat.findAll().findAll { it.members.contains(user) }
        chats
    }

    def createChat(List<User> users) {
        String chatName = "/topic/${users.name.join()}"
        println "miembros creando chat ${users}"
        Chat chat = new Chat([topic: chatName, members: users as Set, type: ChatType.PRIVATE])
        chat.save(flush: true, failOnError: true)
    }

    def addToGroup(User user, Chat chat) {
        chat.addToMembers(user)
        chat.save(flush: true, failOnError: true)
    }

    def getPublicGroup() {
        Chat.findByType(ChatType.PUBLIC)
    }

    def addToPublicGroup(User user) {
        Chat chat = Chat.findOrCreateByTypeAndTopic(ChatType.PUBLIC, "/topic/public")
        chat.addToMembers(user)
        chat.save(flush: true, failOnError: true)
    }

    def getByUsers(List<User> users) {
        Chat chat = Chat.all.find { it.members as Set == users as Set && it.type == ChatType.PRIVATE }
        if (!chat) chat = createChat(users)
        chat
    }

    def getByTopic(String topic) {
        Chat.findByTopic(topic)
    }

    def addMessage(Chat chat, User user, String msg, String attachment, String attachmentType) {
        Message message = messageService.create(chat, user, msg, attachment, attachmentType)
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
        message.chat.members.findAll { it.type != UserType.INTEGRATION }.each { User user ->
            brokerMessagingTemplate.convertAndSend user.topic, (message.toMap() as JSON).toString()
            Logger.logMessageToUser(message, user)
        }

        def externalUsers = message.chat.members.findAll { it.type == UserType.INTEGRATION }

        if (message.chat.type == ChatType.PRIVATE && message.user.type != UserType.INTEGRATION) {
            externalUsers.each { User user ->

                def msg = [
                        "from"      : ["id": message.user.id, "name": message.user.name],
                        "msg"       : message.message,
                        "to"        : ["id": user.integrationId, "name": user.name],
                        "attachment": null,
                        "sourceApp" : "grails",
                        "targetApp" : user.integrationApp]


                apiClient.post(privateIntegrationUrl, msg)
                Logger.logPost(privateIntegrationUrl, msg)
                Logger.sendIntegrationPrivateMessage(message, user)
            }

        } else if(message.user.type != UserType.INTEGRATION){
            def msg = [
                    "from"      : ["id": message.user.id, "name": message.user.name],
                    "msg"       : message.message,
                    "to"        : null,
                    "attachment": null,
                    "sourceApp" : "grails",
                    "targetApp" : null]

            apiClient.post(publicIntegrationUrl, msg)
            Logger.logPost(publicIntegrationUrl, msg)
            Logger.sendIntegrationPublicMessage(message)
        }
    }
}
