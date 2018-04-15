package login

import chat.User

class LoginValidator {

    static validate(session, params) {
        def response
        def user = User.findByName(params.name.toLowerCase())

        switch (user) {
            case { it != null && it.password == params.password }:
                session.user = user
                response = [status: 200]
                break
            case { it != null }:
                response = [status: 405]
                break
            default:
                response = [status: 404]
                break
        }

        response
    }

    static logout(session) {
        session.user = null
    }
}