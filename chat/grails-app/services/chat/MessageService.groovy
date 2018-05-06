package chat

import attachment.AttachmentType

class MessageService {

    def create(Chat chat, User user, String msg, String attachmentBytes, String attachmentType) {
        def attachment = null

        if (attachmentBytes != "null") {
            attachment = new Attachment([bytes: attachmentBytes, extensions: "png", type: AttachmentType.valueOf(attachmentType) ])
        }

        Message message = new Message([chat: chat, message: msg, user: user, attachment: attachment])
        message
    }
}
