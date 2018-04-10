<!doctype html>
<html>

<g:render template="/head" model='[title: "Chat"]'></g:render>

<head>
    <asset:javascript src="sockjs.js"/>
    <asset:javascript src="stompjs.js"/>
</head>

<body>

<g:render template="/navbar"></g:render>

<div class="myContainer">

    <div class="chats bordered">

        <g:each var="user" in="${users}">
            <g:render template="/chat/userPreview" model="[user: user]"></g:render>
        </g:each>

    </div>


    <div class="chat bordered">
        <div id="chat"></div>

        <div>
            <div class="form-group" style="float: left; width: 90%">
                <textarea class="form-control" id="msg" rows="3"></textarea>
            </div>

            <div style="float: right; width: 10%">
                <button class="btn btn-success" id="submit-message">Send</button>
            </div>
        </div>
    </div>

</div>

</body>

<script>

    var currentChat;

    function startChat(users) {
        cleanChat();

        $.post("chat/start", {
                'users': JSON.stringify(users)
            },
            function (response) {
                currentChat = response.chat.topic;
                conect();
                loadMessages(response.chat.id)
            });

    }

    function loadMessages(chatId) {
        $.post("chat/lastMessages",
            {
                chatId: chatId
            },
            function (response) {
                if (response.status != 200) {
                    alert("Hubo un error");
                    return
                }

                console.log(response.messages);

                $.each(response.messages, function (index, value) {
                    loadMessage(value, response.owner[index])
                });
            });
    }

    function loadMessage(msg, owner) {

        $("#chat").append('<p>' + msg.timestamp + " <b>" + owner + "</b> " + msg.message + '</p>');
    }

    function cleanChat() {
        $("#chat").empty();
    }

    $("#submit-message").click(function () {

        if (!currentChat) return;
        var msg = $("#msg").val();

        $.post("chat/message",
            {
                msg: msg,
                userId: ${session.user.id},
                topic: currentChat
            },
            function (response) {
                if (response.status != 200) {
                    alert("Hubo un error")
                }
            });
    });

    function conect() {
        var socket = new SockJS("${createLink(uri: '/stomp')}");
        var client = Stomp.over(socket);

        client.connect({}, function () {
            client.subscribe(currentChat, function (message) {
                var msg = JSON.parse(message.body);
                loadMessage(msg, msg.user);
            });
        });
    };

</script>
</html>
