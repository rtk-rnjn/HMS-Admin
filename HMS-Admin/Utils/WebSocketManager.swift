//
//  WebSocketManager.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 28/03/25.
//

import Foundation
import UserNotifications

class WebSocketManager: NSObject {

    // MARK: Public

    public static let shared: WebSocketManager = .init()

    // MARK: Internal

    func connectWebSocket() {
        guard let url = URL(string: "ws://localhost:8080/hospital/announcement") else { return }
        webSocketTask = urlSession.webSocketTask(with: url)
        webSocketTask?.resume()
        receiveMessage()
    }

    func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case let .success(message):
                switch message {
                case let .string(text):
                    print("Received: \(text)")
                    self?.triggerNotification(title: "New Announcement", body: text)

                default:
                    break
                }

            case let .failure(error):
                print("Error: \(error)")
            }
            self?.receiveMessage() // Keep listening for new messages
        }
    }

    func triggerNotification(title: String, body: String) {
        Utils.createNotification(title: title, body: body)
    }

    // MARK: Private

    private var webSocketTask: URLSessionWebSocketTask?
    private let urlSession: URLSession = .init(configuration: .default)

}
