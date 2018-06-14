<g:each var="contactsObject" in="${users}">
    <p style="color: white; margin-top: 2%"> ${contactsObject.id.capitalize()} </p>
    <g:each var="contact" in="${contactsObject.contacts}">
        <div class="user-card contact-integration-card" data-userid="${contact.id}" data-username="${contact.name}"  data-userchat="${contactsObject.id}">

            <div class="user-image">
                <i class="fa fa-user"></i>
            </div>

            <div class="user-name-and-preview">
                <div class="user-name-container">
                    <div class="user-name">${contact.name.capitalize()}</div>
                </div>
            </div>

        </div>
    </g:each>

</g:each>

