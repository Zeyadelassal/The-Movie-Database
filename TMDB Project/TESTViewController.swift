//
//  TESTViewController.swift
//  TMDB Project
//
//  Created by ZeyadEl3ssal on 1/21/20.
//  Copyright © 2020 ZeyadEl3ssal. All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu

class TESTViewController: UIViewController {

    let items = ["Most Popular", "Upcoming", "Top Rated"]
    override func viewDidLoad() {
        super.viewDidLoad()
        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: BTTitle.title("Dropdown Menu"), items: items)
            self.navigationItem.titleView = menuView
            
           menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
                    print("Did select item at index: \(indexPath)")
                    //  menuView.selectedCellLabel.text = menuItems[indexPath]
                    if indexPath == 1 {
                            print("hi")
                }
            }
        }

        // Do any additional setup after loading the view.
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
