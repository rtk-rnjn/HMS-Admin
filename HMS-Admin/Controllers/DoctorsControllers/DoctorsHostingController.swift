//
//  DoctorsHostingController.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 27/03/25.
//

import Foundation
import SwiftUI

class DoctorsHostingController: UIHostingController<DoctorListView> {

    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: DoctorListView())
    }

    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareSearchController()
        
        // Add notification observer for refreshing doctors list
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleRefreshNotification),
            name: NSNotification.Name("RefreshDoctorsList"),
            object: nil
        )
    }

    deinit {
        // Remove notification observer when the controller is deallocated
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func handleRefreshNotification() {
        refreshDoctorsList()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        Task {
            if let staffs = await DataController.shared.fetchDoctors() {
                rootView.totalDoctors = staffs
            }
        }
    }

    func refreshDoctorsList() {
        Task {
            if let staffs = await DataController.shared.fetchDoctors() {
                rootView.totalDoctors = staffs
            }
        }
    }

    // MARK: Private

    private var searchController: UISearchController = .init()

    private func prepareSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Doctors"

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

extension DoctorsHostingController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {}
}
