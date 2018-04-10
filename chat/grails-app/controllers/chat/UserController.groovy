package chat

class UserController {
    UserService userService

    def getAll() {
        userService.getAll()
    }
}
