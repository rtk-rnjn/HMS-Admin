//
//  DoctorsHostingController.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 27/03/25.
//

import Foundation
import SwiftUI
import UIKit

class DoctorsHostingController: UIHostingController<DoctorListView> {

    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: DoctorListView())
        setupFilterMenu()
    }

    deinit {
        // Remove notification observer when the controller is deallocated
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchBar.searchTextField.clearButtonMode = .never
        prepareSearchController()

        // Add notification observer for refreshing doctors list
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleRefreshNotification),
            name: NSNotification.Name("RefreshDoctorsList"),
            object: nil
        )
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
    private var filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle"), for: .normal)
        button.tintColor = .systemBlue
        return button
    }()

    private let departments = [
        "Cardiology",
        "Neurology",
        "Orthopedics",
        "Pediatrics",
        "Gynecology & Obstetrics",
        "Oncology",
        "Radiology",
        "Emergency & Trauma",
        "Dermatology",
        "Psychiatry",
        "Gastroenterology",
        "Nephrology",
        "Endocrinology",
        "Pulmonology",
        "Ophthalmology",
        "ENT (Ear, Nose, Throat)",
        "Urology",
        "Anesthesiology",
        "Pathology & Lab Medicine"
    ]

    private var selectedDepartment: String? = nil {
        didSet {
            updateFilters()
            updateSearchBarText()
        }
    }

    private var selectedSpecialization: String? = nil {
        didSet {
            updateFilters()
            updateSearchBarText()
        }
    }

    private func setupFilterMenu() {
        let filterMenu = UIMenu(title: "Filter Doctors", children: [
            UIMenu(title: "Department", options: .displayInline, children:
                departments.map { department in
                    UIAction(title: department) { [weak self] action in
                        self?.selectedDepartment = department
                    }
                }
            ),
            UIAction(title: "Clear Filters", attributes: .destructive) { [weak self] _ in
                self?.clearFilters()
            }
        ])
        
        filterButton.menu = filterMenu
        filterButton.showsMenuAsPrimaryAction = true
    }

    private func clearFilters() {
        selectedDepartment = nil
        selectedSpecialization = nil
//        rootView.filterDepartment = nil
//        rootView.filterSpecialization = nil
        searchController.searchBar.text = ""
        rootView.searchQuery = ""
    }

    private func updateFilters() {
//        rootView.filterDepartment = selectedDepartment
//        rootView.filterSpecialization = selectedSpecialization
    }

    private func updateSearchBarText() {
        var searchComponents: [String] = []
        
        // Add department filter if selected
        if let department = selectedDepartment {
            searchComponents.append("\(department)")
        }
        
        // Add specialization filter if selected
        if let specialization = selectedSpecialization {
            searchComponents.append("\(specialization)")
        }
        
        // Combine all components with a separator
        let filterText = searchComponents.joined(separator: " | ")
        
        // Update search bar text
        searchController.searchBar.text = filterText
        rootView.searchQuery = filterText
    }
    private func prepareSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Doctors"
        
        // Add filter button to search bar
        if let searchBarContainer = searchController.searchBar.value(forKey: "searchField") as? UIView {
            filterButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            searchBarContainer.addSubview(filterButton)
            
            // Add constraints
            filterButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                filterButton.trailingAnchor.constraint(equalTo: searchBarContainer.trailingAnchor, constant: -8),
                filterButton.centerYAnchor.constraint(equalTo: searchBarContainer.centerYAnchor),
                filterButton.widthAnchor.constraint(equalToConstant: 30),
                filterButton.heightAnchor.constraint(equalToConstant: 30)
            ])
        }

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    @objc private func handleRefreshNotification() {
        refreshDoctorsList()
    }
}

extension DoctorsHostingController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // Get the search text from the search controller
        let searchText = searchController.searchBar.text ?? ""

        // Update the SwiftUI view's search query
        rootView.searchQuery = searchText
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Clear the search query when cancel is clicked
        rootView.searchQuery = ""
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // Hide filter button when search becomes active
        filterButton.isHidden = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // Show filter button when search becomes inactive
        filterButton.isHidden = false
    }
}
