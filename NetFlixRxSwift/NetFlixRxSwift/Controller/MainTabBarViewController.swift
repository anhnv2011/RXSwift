//
//  MainTabBarViewController.swift
//  NetflixRxSwift
//
//  Created by MAC on 8/19/22.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = .orange // set mau khi chon
        self.tabBar.backgroundColor = .black
        //Messages
        
        let homeNavi = UINavigationController(rootViewController: HomeViewController())
        homeNavi.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house"))
        //        homeNavi.tabBarItem.badgeValue = "99"
        //        homeNavi.tabBarItem.badgeColor = .blue
        
        let upcomingNavi = UINavigationController(rootViewController: UpcomingViewController())
        upcomingNavi.tabBarItem = UITabBarItem(title: "Upcomming", image: UIImage(systemName: "play.circle"), selectedImage: UIImage(systemName: "play.circle"))
        
        let searchNavi = UINavigationController(rootViewController: SearchViewController())
        searchNavi.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"))
        
        let downloadNavi = UINavigationController(rootViewController: DownloadViewController())
        downloadNavi.tabBarItem = UITabBarItem(title: "Download", image: UIImage(systemName: "square.and.arrow.down"), selectedImage: UIImage(systemName: "square.and.arrow.down"))
        
        setViewControllers([homeNavi,upcomingNavi, searchNavi, downloadNavi], animated: true)
    }
    
    
    
    
}
