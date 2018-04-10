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

    def getMultiple(usersIds) {
        List<User> users = []
        usersIds.each { userId ->
            users.add(User.findById(userId as Long))
        }
        users
    }

    def create(Map params) {
        User user = new User([name: params.name,
                              password: params.password])
        user.save(flush: true, failOnError: true)
        user
    }
}
