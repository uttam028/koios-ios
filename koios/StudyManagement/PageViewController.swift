//
//  RootViewControoler.swift
//  PagingMenuControllerDemo
//
//  Created by Cheng-chien Kuo on 5/14/16.
//  Copyright © 2016 kitasuke. All rights reserved.
//

import UIKit
//import PagingMenuController

struct HomePagingMenuOptions: PagingMenuControllerCustomizable {
    
    //private let appCenterVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "appcentervc") as UIViewController
    private let openVC = UIStoryboard(name: "Study", bundle: nil).instantiateViewController(withIdentifier: "openstudyvc") as UIViewController
    private let myVC = UIStoryboard(name: "Study", bundle: nil).instantiateViewController(withIdentifier: "mystudyvc") as UIViewController
    
    internal var componentType: ComponentType {
        return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
    
    fileprivate var pagingControllers: [UIViewController] {
        return [openVC, myVC]
    }
    
    fileprivate struct MenuOptions: MenuViewCustomizable {
        var displayMode: MenuDisplayMode {
            return .segmentedControl
        }
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItem1(), MenuItem2()]
        }
        
    }
    var lazyLoadingPage: LazyLoadingPage = .three
    var isScrollEnabled: Bool = false
    
    /*fileprivate struct MenuItem1: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "App Center"))
        }
    }*/
    fileprivate struct MenuItem1: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "Available"))
        }
    }
    fileprivate struct MenuItem2: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "Enrolled"))
        }
    }
}

class PageViewController: UIViewController {
    var pagingMenuController:PagingMenuController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //view.backgroundColor = UIColor.white
        
        let options = HomePagingMenuOptions()
        pagingMenuController = PagingMenuController(options: options)
        pagingMenuController.view.frame.origin.y = self.view.bounds.origin.y
        //pagingMenuController.view.frame.size.height -= 10
        
        /*
        pagingMenuController.onMove = { state in
            switch state {
            case let .willMoveController(menuController, previousMenuController):
                print(previousMenuController)
                print(menuController)
            case let .didMoveController(menuController, previousMenuController):
                print(previousMenuController)
                print(menuController)
            case let .willMoveItem(menuItemView, previousMenuItemView):
                print(previousMenuItemView)
                print(menuItemView)
            case let .didMoveItem(menuItemView, previousMenuItemView):
                print(previousMenuItemView)
                print(menuItemView)
            case .didScrollStart:
                print("Scroll start")
            case .didScrollEnd:
                print("Scroll end")
            }
        }*/
        
        //NotificationCenter.default.addObserver(self, selector: #selector(self.switchToAppCenter(_:)), name: NSNotification.Name(rawValue: "enrolledtostudy"), object: nil)

        
        addChild(pagingMenuController)
        view.addSubview(pagingMenuController.view)
        pagingMenuController.didMove(toParent: self)
        

        //self.navigationController?.navigationBar.barTintColor = UIColor.white
        //self.navigationController?.navigationBar.isTranslucent = false
        
        self.edgesForExtendedLayout = []

        
    }
    
    @objc func switchToAppCenter(_ notification: NSNotification){
        guard let index = notification.userInfo?["index"] as? IndexPath else { return }
        guard let name = notification.userInfo?["studyName"] as? String else { return }
        print("pagin menu controller gets action")
        DispatchQueue.main.async {
            self.pagingMenuController.move(toPage: 0)


        }
        
    }
   
    /*
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }*/
}
