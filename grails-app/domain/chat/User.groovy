package chat

import groovy.transform.EqualsAndHashCode
import user.City
import user.UserType

@EqualsAndHashCode(includes = 'id,name')
class User {

    String name
    String password
    String topic
    City city
    int age
    String nickName
    UserType type

    String integrationApp
    String integrationId

    static hasMany = [contacts: User]

    static constraints = {
        contacts (lazy: false)
        name(nullable: true)
        topic(nullable: true, unique: true)
        city(nullable: false)
        integrationApp(nullable: true)
        integrationId(nullable: true)
    }
}
