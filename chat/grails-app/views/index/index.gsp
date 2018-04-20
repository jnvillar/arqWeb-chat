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
        <img id="ItemPreview" src="" />

        <div class="chat" id="chat">

        </div>

        <div class="input-container">
            <div class="attachment-btn-container">
                <input type="file" class="attach-btn" id="attachment-button" name="file"
                       enctype="multipart/form-data"/>
                <label for="file"><i class="fa fa-paperclip"></i></label>
            </div>

            <div class="message-container form-group">
                <textarea class="form-control message-input" id="msg" rows="1"></textarea>
            </div>

            <div class="send-btn-container">
                <button class="btn send-btn" id="submit-message">Send</button>
            </div>

        </div>
    </div>
</div>

</body>

<script>

    var currentChatTopic = "none";
    var userTopic = "${session.user.topic}";
    var currentChatSuscription;

    var Base64={_keyStr:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",encode:function(e){var t="";var n,r,i,s,o,u,a;var f=0;e=Base64._utf8_encode(e);while(f<e.length){n=e.charCodeAt(f++);r=e.charCodeAt(f++);i=e.charCodeAt(f++);s=n>>2;o=(n&3)<<4|r>>4;u=(r&15)<<2|i>>6;a=i&63;if(isNaN(r)){u=a=64}else if(isNaN(i)){a=64}t=t+this._keyStr.charAt(s)+this._keyStr.charAt(o)+this._keyStr.charAt(u)+this._keyStr.charAt(a)}return t},decode:function(e){var t="";var n,r,i;var s,o,u,a;var f=0;e=e.replace(/[^A-Za-z0-9+/=]/g,"");while(f<e.length){s=this._keyStr.indexOf(e.charAt(f++));o=this._keyStr.indexOf(e.charAt(f++));u=this._keyStr.indexOf(e.charAt(f++));a=this._keyStr.indexOf(e.charAt(f++));n=s<<2|o>>4;r=(o&15)<<4|u>>2;i=(u&3)<<6|a;t=t+String.fromCharCode(n);if(u!=64){t=t+String.fromCharCode(r)}if(a!=64){t=t+String.fromCharCode(i)}}t=Base64._utf8_decode(t);return t},_utf8_encode:function(e){e=e.replace(/rn/g,"n");var t="";for(var n=0;n<e.length;n++){var r=e.charCodeAt(n);if(r<128){t+=String.fromCharCode(r)}else if(r>127&&r<2048){t+=String.fromCharCode(r>>6|192);t+=String.fromCharCode(r&63|128)}else{t+=String.fromCharCode(r>>12|224);t+=String.fromCharCode(r>>6&63|128);t+=String.fromCharCode(r&63|128)}}return t},_utf8_decode:function(e){var t="";var n=0;var r=c1=c2=0;while(n<e.length){r=e.charCodeAt(n);if(r<128){t+=String.fromCharCode(r);n++}else if(r>191&&r<224){c2=e.charCodeAt(n+1);t+=String.fromCharCode((r&31)<<6|c2&63);n+=2}else{c2=e.charCodeAt(n+1);c3=e.charCodeAt(n+2);t+=String.fromCharCode((r&15)<<12|(c2&63)<<6|c3&63);n+=3}}return t}}



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



        $('#ItemPreview').attr('src', msg.attachment);
        scroll()
    }

    function cleanChat() {
        $("#chat").empty();
    }

    function cleanInput() {
        $(".attach-btn").val(null);
        $("#msg").val('')
    }

    function scroll() {
        $('#chat').scrollTop($('#chat')[0].scrollHeight);
    }


    function postMsg(file, msg) {
        if (!msg && !file) return;

        var blob = null;

        if (file) {
            blob =file;
        }


        var fd = new FormData();

        fd.append("msg", msg);
        fd.append("userId", "${session.user.id}");
        fd.append("attachment", blob);
        fd.append("topic", currentChatTopic);


        $.ajax("chat/message",
            {
                type: "POST",
                data: fd,
                processData: false,
                contentType: false,
                success: function (response) {
                    if (response.status != 200) {
                        alert("Hubo un error")
                    }
                },
                error: function (response) {
                }
            });

        cleanInput();
    }

    $("#submit-message").click(function () {
        if (!currentChatTopic) return;
        var msg = $("#msg").val();


        var fileList = document.getElementById("attachment-button").files;
        var fileReader = new FileReader();

        if (fileReader && fileList && fileList.length) {
            fileReader.readAsDataURL(fileList[0]);
            fileReader.onload = function () {
                postMsg(fileReader.result, msg)
            }
        } else {
            postMsg(null, msg)
        }
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
