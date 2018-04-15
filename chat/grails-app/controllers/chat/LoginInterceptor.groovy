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

        if(!session.user.isAttached()){
            session.user.attach()
        }

        return true
    }

    boolean after() { true }

    void afterView() {
        // no-op
    }
}
