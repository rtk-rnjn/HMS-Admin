//
//  DoctorsViewController.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 19/03/25.
//

import UIKit

class DoctorsViewController: UIViewController {

    // MARK: Internal

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var tableView: UITableView!

    @IBOutlet var lowerSearchStack: UIStackView!

    var doctors: [Staff] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self

        searchBar.backgroundImage = UIImage()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }

    @IBAction func filterButtonTapped(_ sender: UIButton) {
        lowerSearchStack.isHidden = !lowerSearchStack.isHidden

        let filterImage = UIImage(systemName: "line.3.horizontal.decrease.circle")
        let filterSelectedImage = UIImage(systemName: "line.3.horizontal.decrease.circle.fill")

        if !lowerSearchStack.isHidden {
            sender.setImage(filterSelectedImage, for: .normal)
        } else {
            sender.setImage(filterImage, for: .normal)
        }
    }

    @IBAction func unwind(_ segue: UIStoryboardSegue) {}

    // MARK: Private

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
        print(searchText)
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

        return UIContextMenuConfiguration(identifier: identifier, previewProvider: nil) { _ in
            let editAction = UIAction(title: "Edit", image: UIImage(systemName: "pencil")) { _ in
                print("Edit")
            }

            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                print("Delete")
            }

            return UIMenu(title: "", children: [editAction, deleteAction])
        }
    }
}
