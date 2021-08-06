//
//  MainViewController.swift
//  KeysocAlbum
//
//  Created by Tsang Ka Kui on 6/8/2021.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let albumVC = AlbumViewController()
        let albumController = UINavigationController(rootViewController: albumVC)
        albumController.tabBarItem.title = "Album"
        albumController.tabBarItem.image = UIImage(systemName: "tv.music.note")
        
        let bookmarkVC = BookmarkViewController()
        let bookmarkController = UINavigationController(rootViewController: bookmarkVC)
        bookmarkController.tabBarItem.title = "Bookmark"
        bookmarkController.tabBarItem.image = UIImage(systemName: "bookmark.circle")
        
        viewControllers = [albumController, bookmarkController]
        tabBar.tintColor = UIColor.systemRed
        tabBar.barStyle = .black
    }
}
