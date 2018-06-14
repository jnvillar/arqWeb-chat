package chat

import grails.converters.JSON

class UserController {
    UserService userService
    ChatService chatService

    def getAll() {
        def sort = params.sort
        List<User> users = userService.getAll()
        users.remove(session.user)
        userService.sortUsers(sort, users)
        render(template: "contactPreview", model: [users: users, sort:sort])
    }

    def list(){
        List<User> users = userService.getAll()
        users = users.collect{return [id:it.id, name:it.name]}
        render users as JSON
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
        session.user.attach()
        def sort = params.sort
        List<User> users = userService.getContacts(session.user)
        userService.sortUsers(sort, users)
        render(template: "contactPreview", model: [users: users, sort: sort])
    }

    def addContact() {
        User newContact = userService.getByName(params.name as String)
        userService.addContact(session.user as User, newContact)
        def response = [status: 200]
        render response as JSON
    }

    def integration(){
        def users = userService.getIntegrationUsers()
        users = users.findAll{it["id"] != "grails"}
        render(template: "contactIntegrationPreview", model: [users: users])
    }
}
