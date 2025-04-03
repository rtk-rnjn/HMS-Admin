//
//  BillingHostingController.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 27/03/25.
//

import SwiftUI

class BillingHostingController: UIHostingController<BillingView> {

    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        let billingView = BillingView()
        super.init(coder: coder, rootView: billingView)
    }

    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()

        self.rootView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        Task {
            guard let bills = await DataController.shared.fetchBills() else {
                return
            }
            DispatchQueue.main.async {
                self.rootView.invoices = bills
            }
        }
    }
}
