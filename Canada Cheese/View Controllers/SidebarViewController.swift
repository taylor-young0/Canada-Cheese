//
//  SidebarViewController.swift
//  Canada Cheese
//
//  Created by Taylor Young on 2022-01-06.
//  Copyright © 2022 Taylor Young. All rights reserved.
//

import UIKit

let sidebarTabs = [SidebarTab(name: NSLocalizedString("All Cheese", comment: ""), image: "folder"),
                   SidebarTab(name: NSLocalizedString("Favourites", comment: ""), image: "star")]

enum Section {
    case main
}

// See Build for iPad session at 2020 WWDC https://developer.apple.com/videos/play/wwdc2020/10105
// and https://swiftsenpai.com/development/uicollectionview-list-basic/
class SidebarViewController: UICollectionViewController {
    
    var dataSource: UICollectionViewDiffableDataSource<Section, SidebarTab>!
    var snapshot: NSDiffableDataSourceSnapshot<Section, SidebarTab>!
    var allCheeseVC: AllCheeseTableViewController?
    var favouritesVC: FavouritesTableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        allCheeseVC = splitViewController?.viewController(for: .supplementary) as? AllCheeseTableViewController
        favouritesVC = storyboard?.instantiateViewController(identifier: "favouritesVC") as? FavouritesTableViewController

        let configuration = UICollectionLayoutListConfiguration(appearance: .sidebar)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        collectionView.collectionViewLayout = layout
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SidebarTab> { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.image = item.image
            content.text = item.name
            content.imageProperties.tintColor = .systemRed
                
            // Assign content configuration to cell
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, SidebarTab>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: SidebarTab) -> UICollectionViewCell? in
            
            // Dequeue reusable cell using cell registration
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
            
            return cell
        }
        
        snapshot = NSDiffableDataSourceSnapshot<Section, SidebarTab>()
        snapshot.appendSections([.main])
        snapshot.appendItems(sidebarTabs, toSection: .main)

        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Mark selected sidebar tab depending on the currently shown supplementary view controller
        if let _ = splitViewController?.viewController(for: .supplementary) as? AllCheeseTableViewController {
            collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: UICollectionView.ScrollPosition.top)
        } else {
            collectionView.selectItem(at: IndexPath(row: 1, section: 0), animated: true, scrollPosition: UICollectionView.ScrollPosition.top)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            // if we are reselecting active tab
            if let vc = splitViewController?.viewController(for: .supplementary) as? AllCheeseTableViewController {
                vc.tableView.setContentOffset(CGPoint(x: 0.0, y: 0 - vc.navigationBarOffset), animated: true)
            }
            
            splitViewController?.setViewController(allCheeseVC, for: .supplementary)
        } else {
            // if we are reselecting active tab
            if let vc = splitViewController?.viewController(for: .supplementary) as? FavouritesTableViewController {
                vc.tableView.setContentOffset(CGPoint(x: 0.0, y: 0 - vc.navigationBarOffset), animated: true)
            }
            
            splitViewController?.setViewController(favouritesVC, for: .supplementary)
        }
    }
    
    func displayCheeseDetail(for id: String, loaded: Bool = true) {
        // scene(_:willConnectTo:options:)
        // data won't be loaded if the app has yet to be launched
        if !loaded {
            let allCheeseVC = splitViewController?.viewController(for: .supplementary) as? AllCheeseTableViewController
            let urlString = "https://raw.githubusercontent.com/taylor-young0/Canada-Cheese/main/Canada%20Cheese/canadianCheeseDirectory.json"
            
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    allCheeseVC?.parse(json: data)
                }
            }
        }
        
        if let vc = storyboard?.instantiateViewController(identifier: "cheeseDetail") as? CheeseDetailViewController {
            vc.selectedCheese = CanadianCheeses.allCheeses?.first(where: { $0.cheeseId == id })
            
            if UITraitCollection.current.horizontalSizeClass == .regular {
                vc.navigationItem.hidesBackButton = true
                splitViewController!.showDetailViewController(vc, sender: nil)
                
                if splitViewController?.displayMode == .oneOverSecondary {
                    splitViewController?.hide(.supplementary)
                }
            } else {
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

}

struct SidebarTab: Hashable {
    let name: String
    let image: UIImage
    
    init(name: String, image: String) {
        self.name = name
        self.image = UIImage(systemName: image)!
    }
}
