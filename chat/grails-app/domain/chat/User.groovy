package chat

class User {

    String name
    String password

    static constraints = {
        name(unique: true)
    }


}
