package chat

import groovy.transform.EqualsAndHashCode

@EqualsAndHashCode(includes = 'id')
class User {

    String name
    String password
    String topic

    static hasMany = [contacts: User]

    static constraints = {
        name(unique: true)
        topic(nullable: true, unique: true)
    }
}
