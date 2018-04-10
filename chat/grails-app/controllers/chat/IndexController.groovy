package chat

class IndexController {
    UserService userService

    def index() {
        List<User> users = userService.getAll()
        users = users.findAll { User user -> user.name != session.user.name }
        render(view: "index", model: [users: users])
    }
}
