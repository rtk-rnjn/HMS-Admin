//
//  SelectorTableViewController.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 21/03/25.
//

import UIKit

class SelectorTableViewController: UITableViewController {
    var options: [String] = []
    var selectedMappedOptions: [String: Bool] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        clearsSelectionOnViewWillAppear = false
        navigationItem.rightBarButtonItems = [editButtonItem, UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addOption))]

        selectedMappedOptions = options.reduce(into: [:]) { $0[$1] = false }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectorTableViewCell", for: indexPath) as? SelectorTableViewCell

        guard let cell else { fatalError() }

        cell.updateElements(with: options[indexPath.row])

        cell.accessoryType = selectedMappedOptions[options[indexPath.row]]! ? .checkmark : .none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMappedOptions[options[indexPath.row]] = !selectedMappedOptions[options[indexPath.row]]!
        _ = selectedMappedOptions.map({ $0.value }).filter({ $0 }).count

        tableView.reloadRows(at: [indexPath], with: .fade)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            options.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    @objc func addOption() {
        let alertController = UIAlertController(title: "Add Option", message: "Enter a new option", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Option Name"
        }

        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let self, let text = alertController.textFields?.first?.text, !text.isEmpty else { return }

            options.append(text)
            selectedMappedOptions[text] = false

            let newIndexPath = IndexPath(row: options.count - 1, section: 0)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addAction(addAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }
}
