package chat

import attachment.AttachmentType

class Attachment {
    String bytes
    String extensions
    AttachmentType type
    Message message

    static belongsTo = Message

    static constraints = {
        bytes nullable: false
        extensions nullable: true
        type nullable: false
    }

    static mapping = {
        bytes column: 'bytes', sqlType: 'longblob'
    }
}
