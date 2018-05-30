package chat

import grails.converters.JSON
import login.LoginValidator

class LoginController {
    UserService userService
    LoginValidator loginValidator = new LoginValidator()

    def loginForm() {
        render(view: "login")
    }

    def registerForm(){
        render(view: "register")
    }

    def register(){
        User user = userService.create(params)
        session.user = user
        def response = [status:200]
        render response as JSON
    }

    def login() {
        def response = loginValidator.validate(session, params)
        render response as JSON
    }

    def logout() {
        loginValidator.logout(session)
        redirect(uri: "/")
    }
}
