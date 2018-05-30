function loadContacts() {
    $(".action-item").removeClass("action-selected");
    $(".contacts").addClass("action-selected");

    $(".sidebar-cards").html("");
    $.get("/user/contacts",
        function (response) {
            $(".sidebar-cards").html(response);
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

$(".chats").click(function () {
    loadChats(-1);
});

$(".contacts").click(function () {
    loadContacts()
});

$(".add").click(function () {
    $(".action-item").removeClass("action-selected");
    $(".add").addClass("action-selected");
});

$(".groups").click(function () {
    $(".action-item").removeClass("action-selected");
    $(".groups").addClass("action-selected");
})
