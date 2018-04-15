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

        <div class="action-bar">
            <div class="action-item chats">
                <i class="fa fa-comments"></i>
            </div>

            <div class="action-item contacts">
                <i class="fa fa-address-book"></i>
            </div>

            <div class="action-item groups" data-toggle="modal" data-target="#add-group">
                <i class="fa fa-users"></i>
            </div>

            <div class="action-item add" data-toggle="modal" data-target="#add-contact">
                <i class="fa fa-user-plus"></i>
            </div>

        </div>

        <div class="sidebar-cards">

        </div>
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

    var currentChatTopic = "none";
    var userTopic = "${session.user.topic}";
    var currentChatSuscription;


    $(document).ready(function () {
        var socket = new SockJS("${createLink(uri: '/stomp')}");
        var client = Stomp.over(socket);

        client.connect({}, function () {
            client.subscribe(userTopic, function (message) {
                var msg = JSON.parse(message.body);
                if (currentChatTopic != msg.chatTopic) {
                    showPreview(msg)
                }
            });
        });

        loadChats(-1);
    });

    function showPreview(message) {

        if (message.message.length > 30) {
            message.message = message.message.substr(0, 30) + "..."
        }

        var msg = message.message.substr(0, 30);
        $("#notification-" + message.chat).show();
        $("#msg-preview-" + message.chat).html(msg)
    }

    $("div").on('click', ".contact-card", function () {
        if ($(this).hasClass("chat-selected")) return;
        $(".chat-selected").removeClass("chat-selected");
        $(this).addClass("chat-selected");

        var userId = $(this).data("user");
        var users = ["${session.user.name}", userId];

        cleanChat();

        $.post("chat/start", {
                'users': JSON.stringify(users)
            },
            function (response) {
                var chatTopic = response.chat.topic;
                conect(chatTopic);
                loadMessages(response.chat.id);
                loadChats(response.chat.id);
            });
    });


    $("div").on('click', ".chat-card", function () {
        if ($(this).hasClass("chat-selected")) return;

        $(this).find(".msg-notification").hide();
        $(this).find(".message-preview").html("");
        $(".chat-selected").removeClass("chat-selected");
        $(this).addClass("chat-selected");

        var chatId = $(this).data("chat");

        cleanChat();

        $.post("chat/get", {
                'id': chatId
            },
            function (response) {
                var chatTopic = response.chat.topic;
                conect(chatTopic);
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
        var type = "received";
        if (owner == "${session.user.name}") {
            type = "send";
        }

        $("#chat").append(
            '<div class="message-' + type + '">' +
            '<div class="msg-name">' + owner + ' </div> ' +
            '<div class="msg-msg"> <p class="msg-msg">' + msg.message + '</p> </div> ' +
            '<div class="msg-timestamp">' + msg.timestamp.substring(11, 16) + '</div>' +
            '</div>'
        );
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
        if (!currentChatTopic) return;
        var msg = $("#msg").val();

        $.post("chat/message",
            {
                msg: msg,
                userId: ${session.user.id},
                topic: currentChatTopic
            },
            function (response) {
                if (response.status != 200) {
                    alert("Hubo un error")
                }
            });

        cleanInput();
    });


    function conect(chatTopic) {
        var socket = new SockJS("${createLink(uri: '/stomp')}");
        var client = Stomp.over(socket);

        if (currentChatSuscription) {
            currentChatSuscription.unsubscribe()
        }

        currentChatTopic = chatTopic;

        client.connect({}, function () {
            currentChatSuscription = client.subscribe(chatTopic, function (message) {
                var msg = JSON.parse(message.body);
                loadMessage(msg, msg.user);
            });
        });
    }


    function loadChats(chat) {
        $(".action-item").removeClass("action-selected");
        $(".chats").addClass("action-selected");

        $(".sidebar-cards").html("");
        $.get("/user/chats",
            function (response) {
                $(".sidebar-cards").html(response);
                $('.chat-card[data-chat="' + chat + '"]').addClass("chat-selected")
            });
    }

    function loadContacts() {
        $(".action-item").removeClass("action-selected");
        $(".contacts").addClass("action-selected");

        $(".sidebar-cards").html("");
        $.get("/user/contacts",
            function (response) {
                $(".sidebar-cards").html(response);
            });
    }

    $(".chats").click(function () {
        loadChats(-1);
    });

    $(".contacts").click(function () {
        loadContacts()
    });

    $(".add").click(function () {
        $(".action-item").removeClass("action-selected");
        $(".add").addClass("action-selected");
    })

    $(".groups").click(function () {
        $(".action-item").removeClass("action-selected");
        $(".groups").addClass("action-selected");
    })






</script>

<g:render template="/chat/addContact"></g:render>
<g:render template="/chat/addGroup"></g:render>

</html>
