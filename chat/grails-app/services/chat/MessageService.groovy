package chat

import attachment.AttachmentType
import grails.gorm.transactions.Transactional

@Transactional
class MessageService {

    def create(Chat chat, User user, String msg, String attachmentBytes) {
        def attachment = null

        if (attachmentBytes != "null") {
            attachment = new Attachment([bytes: attachmentBytes, extensions: "png", type: AttachmentType.IMAGE])
        }

        Message message = new Message([chat: chat, message: msg, user: user, attachment: attachment])
        message
    }
}
