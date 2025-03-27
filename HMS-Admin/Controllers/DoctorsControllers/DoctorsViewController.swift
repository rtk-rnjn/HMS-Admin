//
//  DoctorsViewController.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 19/03/25.
//

import UIKit

private let filterImage: UIImage? = .init(systemName: "line.3.horizontal.decrease.circle")
private let filterSelectedImage: UIImage? = .init(systemName: "line.3.horizontal.decrease.circle.fill")

class DoctorsViewController: UIViewController, UISearchResultsUpdating {

    // MARK: Internal

    @IBOutlet var tableView: UITableView!

    var doctors: [Staff]? = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        prepareSearchController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowAddEditDoctorTableViewController", let navigationController = segue.destination as? UINavigationController, let addEditDoctorTableViewController = navigationController.topViewController as? AddEditDoctorTableViewController {
            addEditDoctorTableViewController.doctor = sender as? Staff
        }

        if segue.identifier == "segueShowDoctorDetailsTableViewController", let doctorDetailsTableViewController = segue.destination as? DoctorDetailsTableViewController, let doctor = sender as? Staff {
            doctorDetailsTableViewController.doctor = doctor
        }
    }

    func updateSearchResults(for searchController: UISearchController) {}

    @IBAction func unwind(_ segue: UIStoryboardSegue) {}

    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "segueShowAddEditDoctorTableViewController", sender: nil)
    }

    // MARK: Private

    private var searchTask: DispatchWorkItem?
    private var searchController: UISearchController = .init()

    private func prepareSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Doctors"

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func refreshData() {
        Task {
            doctors = await DataController.shared.fetchDoctors()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

}

extension DoctorsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        searchTask?.cancel()

        if searchText.isEmpty {
            refreshData()
            return
        }

        searchTask = DispatchWorkItem {
            self.doctors = self.doctors?.filter {
                $0.fullName.lowercased().contains(searchText.lowercased()) ||
                $0.department.lowercased().contains(searchText.lowercased()) ||
                $0.specializations.contains(where: { $0.lowercased().contains(searchText.lowercased()) })
            }
            self.tableView.reloadData()
        }

        if let task = searchTask {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: task)
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        refreshData()
    }
}

extension DoctorsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return doctors?.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorTableViewCell", for: indexPath) as? DoctorTableViewCell

        guard let cell else { fatalError() }

        guard let doctors else { fatalError() }

        let doctor = doctors[indexPath.section]
        cell.updateElements(with: doctor)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? DoctorTableViewCell
        cell?.isSelected = false

        let doctor = doctors?[indexPath.section]

        performSegue(withIdentifier: "segueShowDoctorDetailsTableViewController", sender: doctor)
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let identifier = "\(indexPath.section)-\(indexPath.row)" as NSString
        guard let doctor = doctors?[indexPath.section] else { fatalError() }
        return UIContextMenuConfiguration(identifier: identifier, previewProvider: nil) { _ in
            let editAction = UIAction(title: "Edit", image: UIImage(systemName: "pencil")) { _ in
                self.performSegue(withIdentifier: "segueShowAddEditDoctorTableViewController", sender: doctor)
            }

            return UIMenu(title: "", children: [editAction])
        }
    }
}
