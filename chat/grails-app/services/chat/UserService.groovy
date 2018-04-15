package chat

import grails.gorm.transactions.Transactional

@Transactional
class UserService {

    def getAll() {
        User.findAll()
    }

    def get(Long id) {
        User.findById(id)
    }

    def getByName(String name) {
        User.findByName(name.toLowerCase())
    }

    def getMultiple(userNames) {
        List<User> users = []
        userNames.each { userName ->
            users.add(User.findByName(userName as String))
        }
        users
    }

    def getContacts(User user) {
        user.contacts
    }

    def create(Map params) {
        User user = new User([name    : params.name.toLowerCase(),
                              password: params.password])
        user.save(flush: true, failOnError: true)
        user.topic = "/topic/${user.name}"
        user
    }

    def addContact(User user, User newContact) {
        if (user != newContact) {
            user.addToContacts(newContact)
        }
        user.save(flush: true, failOnError: true)
        user
    }
}
