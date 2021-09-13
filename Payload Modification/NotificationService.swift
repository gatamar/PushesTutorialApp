//
//  NotificationService.swift
//  Payload Modification
//
//  Created by Olha Bachalo on 07.09.2021.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

        guard let bestAttemptContent = bestAttemptContent else {
          return
        }
        guard let urlPath = request.content.userInfo["media-url"] as? String,
              let url = URL(string: ROT13.shared.decrypt(urlPath)) else {
                  contentHandler(bestAttemptContent)
                  return
        }

        bestAttemptContent.title = ROT13.shared.decrypt(bestAttemptContent.title)
        bestAttemptContent.body = ROT13.shared.decrypt(bestAttemptContent.body)

        // 1
        URLSession.shared.dataTask(with: url) { data, response, _ in
          // 2
          defer { contentHandler(bestAttemptContent) }
          // 3
          guard let data = data else { return }
          // 4
          let file = response?.suggestedFilename ?? url.lastPathComponent
          let destination = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(file)

          do {
            try data.write(to: destination)
            // 5
            let attachment = try UNNotificationAttachment(
              identifier: "",
              url: destination)
            bestAttemptContent.attachments = [attachment]
          } catch {
            // 6
          }
        }.resume()
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
