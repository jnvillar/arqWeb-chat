package chat

import grails.converters.JSON
import user.UserType


class ChatController {
    UserService userService
    ChatService chatService

    def getChatsOfUser() {
        User user = userService.get(params.userId as Long)
        List<Chat> chats = chatService.getAllByUser(user)
        def response = [status: 200, chats: chats]
        render response as JSON
    }

    def get() {
        Chat chat = chatService.get(params.id as Long)
        def response = [status: 200, chat: chat]
        render response as JSON
    }

    def create() {
        List<User> users = userService.getMultiple(JSON.parse(params.users as String))
        Chat chat = chatService.getByUsers(users)
        def response = [status: 200, chat: chat]
        render response as JSON
    }

    def createIntegration(){
        User user = User.findByName(params.user as String)
        User userIntegration = userService.getIntegrationUser([from:[name:params.userName, id:params.userId], sourceApp:params.userChat])

        List<User> users = [user,userIntegration]
        Chat chat = chatService.getByUsers(users)
        def response = [status: 200, chat: chat]
        render response as JSON
    }

    def lastMessages() {
        Chat chat = chatService.get(params.chatId as Long)

        def response = [
                status  : 200,

                messages: chat.messages.size() < 50 ?
                        chat.messages.collect { it.toMap() } :
                        chat.messages[-50..-1].collect { it.toMap() },
        ]
        render response as JSON
    }

    def send() {
        Chat chat = chatService.getByTopic(params.topic as String)
        Message message = chatService.addMessage(chat, session.user as User, params.msg as String, params.attachment as String, params.attachmentType as String)

        chatService.sendToChat(message)
        chatService.sendToUsers(message)

        def response = [status: 200]
        render response as JSON
    }

    def publicIntegration(){
        def data = request.JSON
        if(data.sourceApp == "grails"){ def res =  [status: 200]; render res as JSON; return}

        User user = userService.getIntegrationUser(params)
        Chat chat = chatService.getPublicGroup()
        Message message = chatService.addMessage(chat, user, data.msg as String, "null" , data.attachmentType as String)

        chatService.sendToChat(message)
        chatService.sendToUsers(message)
        def response = [status: 200]
        render response as JSON
    }

    def privateIntegration(){
        def data = request.JSON
        if(data.sourceApp == "grails"){ def res =  [status: 200]; render res as JSON; return}

        User userFrom = userService.getIntegrationUser(params)
        User userTo = User.findById(data.to.id)
        Chat chat = chatService.getByUsers([userFrom, userTo])
        Message message = chatService.addMessage(chat, userFrom, data.msg as String, data.attachment as String, data.attachmentType as String)

        chatService.sendToChat(message)
        chatService.sendToUsers(message)

        def response = [status: 200]
        render response as JSON
    }

}

