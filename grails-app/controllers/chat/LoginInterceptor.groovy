package chat


class LoginInterceptor {

    LoginInterceptor() {
        matchAll()
                .excludes(controller: "login", action: "*")
                .excludes(controller: "chat", action: "publicIntegration|privateIntegration")
                .excludes(controller: "user", action: "list")

    }


    boolean before() {
        if (!(session.user)) {
            redirect(url: "/login")
            return false
        }


        return true
    }

    boolean after() { true }

    void afterView() {

    }
}
