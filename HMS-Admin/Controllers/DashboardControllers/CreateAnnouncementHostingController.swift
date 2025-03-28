//
//  CreateAnnouncementHostingController.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 29/03/25.
//

import SwiftUI

class CreateAnnouncementHostingController: UIHostingController<CreateAnnouncementView> {

    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: CreateAnnouncementView())
    }

    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()

        rootView.onSave = {
            let announcement = $0
            Task {
                _ = await DataController.shared.createAnnouncement(announcement)
                Utils.createNotification(title: announcement.title, body: announcement.body)
            }
        }
    }
}
