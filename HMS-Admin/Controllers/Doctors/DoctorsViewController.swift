//
//  DoctorsViewController.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 19/03/25.
//

import UIKit

private let filterImage: UIImage? = .init(systemName: "line.3.horizontal.decrease.circle")
private let filterSelectedImage: UIImage? = .init(systemName: "line.3.horizontal.decrease.circle.fill")

class DoctorsViewController: UIViewController {

    // MARK: Internal

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!

    var doctors: [Staff] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self

        searchBar.backgroundImage = UIImage()
        refreshData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowAddEditDoctorTableViewController", let navigationController = segue.destination as? UINavigationController, let addEditDoctorTableViewController = navigationController.topViewController as? AddEditDoctorTableViewController {
            addEditDoctorTableViewController.doctor = sender as? Staff
        }
    }

    @IBAction func unwind(_ segue: UIStoryboardSegue) {}

    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "segueShowAddEditDoctorTableViewController", sender: nil)
    }

    // MARK: Private

    private var searchTask: DispatchWorkItem?

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
            self.doctors = self.doctors.filter { $0.fullName.lowercased().contains(searchText.lowercased()) }
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
        return doctors.count
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorTableViewCell", for: indexPath) as? DoctorTableViewCell

        guard let cell else { fatalError("tune oo rangeele kaisa jaadu kiya") }

        let doctor = doctors[indexPath.section]
        cell.updateElements(with: doctor)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? DoctorTableViewCell
        cell?.isSelected = false

        performSegue(withIdentifier: "segueShowDoctorDetailsViewController", sender: nil)
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let identifier = "\(indexPath.section)-\(indexPath.row)" as NSString
        let doctor = doctors[indexPath.section]
        return UIContextMenuConfiguration(identifier: identifier, previewProvider: nil) { _ in
            let editAction = UIAction(title: "Edit", image: UIImage(systemName: "pencil")) { _ in
                self.performSegue(withIdentifier: "segueShowAddEditDoctorTableViewController", sender: doctor)
            }

            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                print("Delete")
            }

            return UIMenu(title: "", children: [editAction, deleteAction])
        }
    }
}
