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
        let billingView = BillingView(invoices: BillingView.sampleInvoices)
        super.init(coder: coder, rootView: billingView)
    }

    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            guard let bills = await DataController.shared.fetchBills() else {
                // If no bills from backend, use sample data
                DispatchQueue.main.async {
                    self.rootView.invoices = BillingView.sampleInvoices
                }
                return
            }
            DispatchQueue.main.async {
                self.rootView.invoices = bills
            }
        }
    }
}
