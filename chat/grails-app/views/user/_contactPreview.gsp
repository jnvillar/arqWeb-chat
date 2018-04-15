<g:each var="user" in="${users}">
    <div class="user-card contact-card" data-user="${user.name}">
        <div class="user-image">
           <i class="fa fa-user"></i>
        </div>

        <div class="user-name-and-preview">
            <div class="user-name-container">
                <div class="user-name">${user.name.capitalize()}</div>
            </div>
        </div>
    </div>
</g:each>
