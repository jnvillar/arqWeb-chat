function showPreview(message) {

    if (message.message.length > 30) {
        message.message = message.message.substr(0, 30) + "..."
    }

    var msg = message.message.substr(0, 30);
    $("#notification-" + message.chat).show();
    $("#msg-preview-" + message.chat).html(msg)
}