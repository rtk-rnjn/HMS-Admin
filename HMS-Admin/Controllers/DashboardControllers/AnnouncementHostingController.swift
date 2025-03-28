//
//  AnnouncementHostingController.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 28/03/25.
//

import SwiftUI

class AnnouncementHostingController: UIHostingController<AnnouncementView> {

    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: AnnouncementView())
    }

    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            if let announcements = await DataController.shared.fetchAnnouncements() {
                rootView.announcements = announcements
            }
        }
    }
}
