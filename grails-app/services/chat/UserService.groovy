package chat

import clients.ApiClient
import user.City
import user.UserType

class UserService {
    ChatService chatService
    ApiClient apiClient = new ApiClient()

    def getAll() {
        User.findAllByType(UserType.LOCAL)
    }

    def get(Long id) {
        User.findById(id)
    }

    def getByName(String name) {
        User.findByName(name.toLowerCase())
    }

    def getIntegrationUser(params) {
        User user = User.findByNameAndTypeAndIntegrationId(params.from.name as String, UserType.INTEGRATION, params.from.id as String)
        if (!user) user = createIntegrationUser(params)
        user
    }

    def createIntegrationUser(params) {
        User user = new User([name          : params.from.name.toLowerCase(),
                              password      : "a",
                              city          : City.BUENOS_AIRES,
                              age           : 10,
                              nickName      : params.from.name.toLowerCase(),
                              integrationApp: params.sourceApp,
                              integrationId : params.from.id,
                              type          : UserType.INTEGRATION])
        user.save(flush: true, failOnError: true)
    }

    def getMultiple(userNames) {
        List<User> users = []
        userNames.each { userName ->
            users.add(User.findByName(userName as String))
        }
        users
    }

    def getContacts(User user) {
        user.contacts as List<User>
    }

    def create(Map params) {
        User user = new User([name    : params.name.toLowerCase(),
                              password: params.password,
                              city    : City.valueOf(params.country as String),
                              age     : params.age as Integer,
                              nickName: params.nickName,
                              type    : UserType.LOCAL])
        user.topic = "/topic/${user.name}"
        user.save(flush: true, failOnError: true)
        chatService.addToPublicGroup(user)
        user
    }

    def addContact(User user, User newContact) {
        if (user != newContact) {
            user.addToContacts(newContact)
        }
        user.save(flush: true, failOnError: true)
        user
    }

    def getIntegrationUsers() {
        def response = apiClient.get("https://awebchat-integration.herokuapp.com/contacts")
        println response
        println response.body
        println response.json
        return response.json
    }

    def sortUsers(sort, List<User> users) {
        switch (sort) {
            case { it == "name" }:
                users.sort { it.name }
                break
            case { it == "city" }:
                users.sort { it.city.name() }
                break
            case { it == "age" }:
                users.sort { it.age }
                break
            default:
                break
        }
    }
}
