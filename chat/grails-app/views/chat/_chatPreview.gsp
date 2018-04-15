<g:each var="chat" in="${chats}">
    <div class="user-card chat-card" data-chat="${chat.id}">
        <div class="user-image">
            <g:if test="${chat.members.size() == 2}">
                <i class="fa fa-user"></i>
            </g:if>
            <g:else>
                <i class="fa fa-users"></i>
            </g:else>
        </div>

        <div class="user-name-and-preview">
            <div class="user-name-container">

                <g:if test="${chat.members.size() == 2}">
                    <div class="user-name">${chat.members.name.join().replace(session.user.name, "").capitalize()}</div>

                    <div class="msg-notification" id="notification-${chat.id}">
                        <img src="https://cdn0.iconfinder.com/data/icons/social-messaging-ui-color-shapes/128/notification-circle-red-32.png"
                             width="18" height="18">
                    </div>
                </g:if>
                <g:else>
                    <div class="user-name">Grupo: ${chat.members.name.collect { " " + it.capitalize() }.join()}</div>

                    <div class="msg-notification" id="notification-${chat.id}">
                        <img src="https://cdn0.iconfinder.com/data/icons/social-messaging-ui-color-shapes/128/notification-circle-red-32.png"
                             width="18" height="18">
                    </div>
                </g:else>

            </div>

            <div class="message-preview" id="msg-preview-${chat.id}"></div>
        </div>
    </div>
</g:each>



