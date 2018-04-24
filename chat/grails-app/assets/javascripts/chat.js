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

    var blob = undefined;

    if (file) {
        blob = file;
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

function loadMessage(msg, owner) {
    var type = "received";
    if (owner == currentUser) {
        type = "send";
    }

    var imageHtml = '';

    if (msg.attachment != null) {
        imageHtml = '<img id="msg-image" src=' + msg.attachment + '/>'
    }

    $("#chat").append(
        '<div class="message-' + type + '">' +
        '<div class="msg-name">' + owner + ' </div> ' +
        '<div class="msg-msg"> <p class="msg-msg">' + msg.message + '</p> </div> ' +
        imageHtml +
        '<div class="msg-timestamp">' + msg.timestamp.substring(11, 16) + '</div>' +
        '</div>'
    );


    scroll()
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

            $.each(response.messages, function (index, value) {
                loadMessage(value, response.owner[index])
            });
        });
}


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