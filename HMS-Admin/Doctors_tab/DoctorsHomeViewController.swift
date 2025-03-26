//
//  DoctorsHomeViewController.swift
//  HMS-Admin
//
//  Created by harsh chauhan on 26/03/25.
//
import UIKit

class DoctorsHomeViewController:UIViewController{
    
    @IBOutlet var collectionView: UICollectionView!
    
    
    var doctors: [Staff]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //Creating nib to access
        
        let searchBarNib = UINib(nibName: "SearchBarCell", bundle: nil)
        let statusCardNib = UINib(nibName: "StatusCard", bundle: nil)
        let doctorCardNib = UINib(nibName: "DoctorProfile", bundle: nil)
        
        
        collectionView.register(searchBarNib, forCellWithReuseIdentifier: "searchBarCell")
        collectionView.register(statusCardNib, forCellWithReuseIdentifier: "statusCard")
        collectionView.register(doctorCardNib, forCellWithReuseIdentifier: "doctorCard")
        
        collectionView.setCollectionViewLayout(generateLayout(), animated: false)
        
    }
    
    
    @IBAction func addDoctor(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "segueShowAddEditDoctorTableViewController", sender: nil)
    }
    
}

//Generating Layout for collection View

extension DoctorsHomeViewController {
    func generateLayout()->UICollectionViewLayout{
            let layout = UICollectionViewCompositionalLayout{
                (sectionIndex,environment) ->NSCollectionLayoutSection? in
                let section:NSCollectionLayoutSection
                    switch sectionIndex{
                    case 0:section = self.generateSearchLayout()
                    case 2:section = self.generateDoctorsProfileLayout()
                    default :
                        section = self.generateStatusLayout()
                    }
                section.contentInsets = .init(top: 0, leading: 0, bottom: 10, trailing: 0)
                    return section
                
            }
            return layout
        }
    
    func generateDoctorsProfileLayout()->NSCollectionLayoutSection{
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100)), subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0)
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    func generateSearchLayout()->NSCollectionLayoutSection{
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    func generateStatusLayout()->NSCollectionLayoutSection{
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .absolute(100)), subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        return section
    }
}

extension DoctorsHomeViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
        case 1:
            return 3
        default:
            return doctors?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section{
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchBarCell", for: indexPath) as! SearchBarCollectionViewCell
//            cell.layer.borderWidth = 1
//            applyShadowStyling(to: cell)
            cell.layer.cornerRadius = 10
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "statusCard", for: indexPath) as! StatusBarCollectionViewCell
//            cell.layer.borderWidth = 1
            
            cell.layer.cornerRadius = 10
            applyShadowStyling(to: cell)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "doctorCard", for: indexPath) as! DoctorProfileCollectionViewCell
//            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 10
            applyShadowStyling(to: cell)
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshData()
    }
    
    private func refreshData() {
        Task {
            doctors = await DataController.shared.fetchDoctors()
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 2:
            performSegue(withIdentifier: "segueShowDoctorDetailsTableViewController", sender: nil)
        default:return
        }
    }
    
    
    
    private func applyShadowStyling(to cell: UICollectionViewCell) {
            // Create a shadow layer
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.15
            cell.layer.shadowRadius = 3
            cell.layer.shadowOffset = CGSize(width: 0, height: 2)
//            cell.layer.shadowColor = UIColor.black.cgColor
//            cell.layer.shadowOffset = CGSize(width: 0, height: 2)
//            cell.layer.shadowRadius = 4
//            cell.layer.shadowOpacity = 1
            cell.layer.masksToBounds = false
    
            // Make sure the content view keeps the corner radius
            cell.contentView.layer.cornerRadius = cell.layer.cornerRadius
            cell.contentView.layer.masksToBounds = true
    
            // Make sure the background is not transparent
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .white
    
            // Improve shadow performance by setting its path
            cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.layer.cornerRadius).cgPath
        }
}


