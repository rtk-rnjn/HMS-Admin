import UIKit
import SwiftUI

class HospitalDetailHostingController: UIHostingController<HospitalOnboardingView> {

    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: HospitalOnboardingView())
    }

    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - Navigation Methods

    func navigateToDashboard() {
        // Get the storyboard that contains the dashboard
        let storyboard = UIStoryboard(name: "Initial", bundle: nil)

        // Instantiate the tab bar controller
        if let tabBarController = storyboard.instantiateInitialViewController() as? UITabBarController {
            // Set the window's root view controller to the tab bar
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = tabBarController

                // Ensure we're on the dashboard tab (assuming it's the first tab)
                tabBarController.selectedIndex = 0

                // Add a subtle animation for the transition
                UIView.transition(with: window,
                                duration: 0.3,
                                options: .transitionCrossDissolve,
                                animations: nil,
                                completion: nil)
            }
        }
    }

    func navigateToAddDoctors() {
        // Get the storyboard that contains the doctor onboarding
        let storyboard = UIStoryboard(name: "Doctors", bundle: nil)

        // Instantiate the add doctor controller
        if let addDoctorController = storyboard.instantiateViewController(withIdentifier: "AddDoctorHostingController") as? AddDoctorHostingController {
            // Present it modally with a nice animation
            addDoctorController.modalPresentationStyle = .fullScreen
            addDoctorController.modalTransitionStyle = .coverVertical
            present(addDoctorController, animated: true)
        }
    }
}
