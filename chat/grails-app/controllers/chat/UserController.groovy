package chat

import grails.converters.JSON

class UserController {
    UserService userService
    ChatService chatService

    def getAll() {
        userService.getAll()
    }

    def get() {
        User user = userService.get(params.id as Long)
        def response = [status: 200, user: user]
        render response as JSON
    }

    def getChats() {
        List<Chat> chats = chatService.getAllByUser(session.user as User)
        render(template: "/chat/chatPreview", model: [chats: chats])
    }

    def getContacts() {
        Set<User> users = userService.getContacts(session.user)
        render(template: "contactPreview", model: [users: users])
    }

    def addContact() {
        User newContact = userService.getByName(params.name as String)
        userService.addContact(session.user as User, newContact)
        def response = [status: 200]
        render response as JSON
    }
}
