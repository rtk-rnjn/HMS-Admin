import UIKit
import SwiftUI

class HospitalDetailHostingViewController: UIHostingController<HospitalOnboardingView> {

    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: HospitalOnboardingView())
    }

    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide the navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Ensure navigation bar stays hidden when view appears
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
