//
//  InitialTabBarController.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 19/03/25.
//

import UIKit
import UserNotifications

class InitialTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: false)

        Task {
            await requestAccessForNotification()
        }

        Task {
            let loggedIn = await DataController.shared.autoLogin()
            if !loggedIn {
                DispatchQueue.main.async {
                    let okAction = AlertActionHandler(title: "OK", style: .default) { _ in
                        DataController.shared.logout()
                        self.performSegue(withIdentifier: "segueShowSignInViewController", sender: nil)
                    }
                    let alert = Utils.getAlert(title: "Error", message: "Authentication Failed. Please log in again", actions: [okAction])
                    self.present(alert, animated: true)
                }
            }
        }
    }

    func requestAccessForNotification() async {
        let center = UNUserNotificationCenter.current()
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            if granted {
                let settings = await center.notificationSettings()
                guard settings.authorizationStatus == .authorized else { return }
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
