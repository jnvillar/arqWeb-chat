<%@ page import="chat.ChatType" %>
<g:each var="chat" in="${chats}">
    <div class="user-card chat-card" data-chat="${chat.id}">
        <div class="user-image">
            <g:if test="${chat.members.size() == 2 && chat.type == chat.ChatType.PRIVATE}">
                <i class="fa fa-user"></i>
            </g:if>
            <g:else>
                <i class="fa fa-users"></i>
            </g:else>
        </div>

        <div class="user-name-and-preview">
            <div class="user-name-container">
                <g:if test="${chat.type == chat.ChatType.PUBLIC}">
                    <div class="user-name">Grupo Público</div>
                </g:if>
                <g:else>
                    <g:if test="${chat.members.size() == 2}">
                        <div class="user-name">${chat.members.name.join().replaceFirst(session.user.name, "").capitalize()}
                        </div>
                    </g:if>
                    <g:else>
                        <div class="user-name">Grupo: ${chat.members.name.collect {
                            " " + it.capitalize()
                        }.join()}</div>
                    </g:else>
                </g:else>

                <div class="msg-notification" id="notification-${chat.id}">
                    <i class="fa fa-bell"></i>
                </div>
            </div>

            <div class="message-preview" id="msg-preview-${chat.id}"></div>
        </div>
    </div>
</g:each>



