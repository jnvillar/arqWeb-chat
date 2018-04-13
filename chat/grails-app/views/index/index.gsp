<!doctype html>
<html>

<g:render template="/head" model='[title: "Chat"]'></g:render>

<head>
    <asset:javascript src="sockjs.js"/>
    <asset:javascript src="stompjs.js"/>
</head>

<g:render template="/navbar"></g:render>

<body>

<div class="myContainer">

    <div class="sidebar" style="overflow-y:scroll ">
        <g:each var="user" in="${users}">
            <g:render template="/chat/userPreview" model="[user: user]"></g:render>
        </g:each>
    </div>


    <div class="chat-container">
        <div class="chat" id="chat"></div>

        <div class="input-container">

            <div class="message-container form-group">
                <textarea class="form-control message-input" id="msg" rows="1"></textarea>
            </div>

            <div class="send-btn-container">
                <button class="btn btn-success send-btn" id="submit-message">Send</button>
            </div>

        </div>
    </div>
</div>

</body>

<script>

    var currentChat;

    $(".user-card").click(function () {
        $(".chat-selected").removeClass("chat-selected");
        $(this).addClass("chat-selected");

        var userId = $(this).data("user");
        var users = ["${session.user.id}", userId];

        cleanChat();

        $.post("chat/start", {
                'users': JSON.stringify(users)
            },
            function (response) {
                currentChat = response.chat.topic;
                conect();
                loadMessages(response.chat.id)
            });
    });

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

                $.each(response.messages, function (index, value) {
                    loadMessage(value, response.owner[index])
                });
            });
    }

    function loadMessage(msg, owner) {
        $("#chat").append('<p>' + msg.timestamp + " <b>" + owner + "</b> " + msg.message + '</p>');
        scroll()
    }

    function cleanChat() {
        $("#chat").empty();
    }

    function cleanInput() {
        $("#msg").val('')
    }

    function scroll() {
        $('#chat').scrollTop($('#chat')[0].scrollHeight);
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


        cleanInput();
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
    }
    ;

</script>
</html>
