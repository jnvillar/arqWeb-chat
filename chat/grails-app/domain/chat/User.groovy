package chat

import groovy.transform.EqualsAndHashCode

@EqualsAndHashCode(includes = 'id,name')
class User {

    String name
    String password
    String topic

    static hasMany = [contacts: User]

    static constraints = {
        contacts (lazy: false)
        name(unique: true)
        topic(nullable: true, unique: true)
    }
}
