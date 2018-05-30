package chat

import groovy.transform.EqualsAndHashCode
import user.City

@EqualsAndHashCode(includes = 'id,name')
class User {

    String name
    String password
    String topic
    City city
    int age
    String nickName

    static hasMany = [contacts: User]

    static constraints = {
        contacts (lazy: false)
        name(unique: true)
        topic(nullable: true, unique: true)
        city(nullable: false)
    }
}
