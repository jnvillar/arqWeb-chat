package chat


class LoginInterceptor {

    LoginInterceptor() {
        match(controller: "user|chat|index", action: "*")
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
