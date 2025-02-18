//
//  CustomTabBarController.swift
//  practice_list
//
//  Created by 大場史温 on 2025/02/04.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // ios18からのiPadのTabBarの仕様が変更されている。
        // カスタマイズ
        traitOverrides.horizontalSizeClass = .compact
        tabBar.items![0].title = "イベント一覧"
        tabBar.items![0].image = UIImage(systemName: "house.fill")
        tabBar.items![1].title = "抽選結果"
        tabBar.items![1].image = UIImage(systemName: "lanyardcard.fill")
    }
}
