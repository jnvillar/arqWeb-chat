package chat

import grails.converters.JSON


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
        Message message = chatService.addMessage(chat, session.user as User, params.msg as String, params.attachment as String)

        chatService.sendToChat(message)
        chatService.sendToUsers(message)

        def response = [status: 200]
        render response as JSON
    }
}

