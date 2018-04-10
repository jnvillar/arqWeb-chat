package chat

class UrlMappings {

    static mappings = {
        "/$controller/$action?/$id?(.$format)?" {
            constraints {
                // apply constraints here
            }
        }


        "/"(controller: "index") {
            action = [GET: "index"]
        }

        "/login"(controller: "login") {
            action = [GET: "loginForm", POST: "login"]
        }

        "/logout"(controller: "login") {
            action = [GET: "logout"]
        }

        "/register"(controller: "login") {
            action = [GET: "registerForm", POST: "register"]
        }

        "/chat/start"(controller: "chat") {
            action = [POST: "create"]
        }

        "/chat/get"(controller: "chat") {
            action = [POST: "getChatOfUser"]
        }

        "/chat/lastMessages"(controller: "chat") {
            action = [POST: "lastMessages"]
        }

        "/chat/message"(controller: "chat") {
            action = [POST: "send"]
        }

        "500"(view: '/error')
        "404"(view: '/notFound')
    }
}
