//
//  DoctorsHomeViewController.swift
//  HMS-Admin
//
//  Created by harsh chauhan on 26/03/25.
//
import UIKit

class DoctorsHomeViewController:UIViewController, UISearchResultsUpdating{
    
    

    @IBOutlet var tableView: UITableView!
    var doctors: [Staff]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    @IBAction func addDoctor(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "segueShowAddEditDoctorTableViewController", sender: nil)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text!)
    }
    
}

extension DoctorsHomeViewController: UITableViewDataSource, UITableViewDelegate {
    override func viewWillAppear(_ animated: Bool) {
        refreshData()
    }

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
    
    private func refreshData() {
        Task {
            doctors = await DataController.shared.fetchDoctors()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}


