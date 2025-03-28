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
}
