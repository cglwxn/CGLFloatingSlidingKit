//
//  GDMapTabbarViewController.swift
//  GaoDeMapDemo
//
//  Created by cc on 2024/3/29.
//

import UIKit

class GDMapTabbarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tabBar.backgroundColor = .white
        addTabbarItems()
    }
    
    func addTabbarItems() {
        let mapVC = GDMapViewController()
        mapVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        
        let nearbyVC = UIViewController()
        nearbyVC.tabBarItem = UITabBarItem(tabBarSystemItem: .mostViewed, tag: 1)
        
        let messageVC = UIViewController()
        messageVC.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 2)
        
        let takeTaxiVC = UIViewController()
        takeTaxiVC.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 3)
        
        let loginVC = UIViewController()
        loginVC.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 4)
        
        viewControllers = [mapVC, nearbyVC, messageVC, takeTaxiVC, loginVC]
    }
}


