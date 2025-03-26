//
//  DoctorProfileViewController.swift
//  HMS-Admin
//
//  Created by Vibhav Upadhyay on 26/03/25.
//

import UIKit

class DoctorProfileViewController: UIViewController {
    
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "DoctorsProfile", bundle: nil)
        let nib2 = UINib(nibName: "OtherThingsOfProfile", bundle: nil)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(nib, forCellReuseIdentifier: "cell")
        tableView.register(nib2, forCellReuseIdentifier: "cell1")
        tableView.showsVerticalScrollIndicator = false
    }
    
}


extension DoctorProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 5
        case 2:
            return 3
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DoctorsProfileTableViewCell
            cell.layer.cornerRadius = 10
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! OtherThingsTableViewCell
            cell.layer.cornerRadius = 10
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section != 0 {
            return 60
        }
        else{
            return 200
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let headerLabel = UILabel()
        if section == 1 {
            headerLabel.text = "Personal Information"
        }
        else if section == 2 {
            headerLabel.text = "Professional Information"
        }
        else if section == 3{
            headerLabel.text = "Department & Schedule"
        }
        headerLabel.textColor = .black
        headerLabel.frame = CGRect(x: 16, y: 0, width: tableView.bounds.width, height: 40)
        headerView.addSubview(headerLabel)
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
}
