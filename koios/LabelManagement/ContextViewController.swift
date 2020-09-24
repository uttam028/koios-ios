//
//  RootViewControoler.swift
//  PagingMenuControllerDemo
//
//  Created by Cheng-chien Kuo on 5/14/16.
//  Copyright © 2016 kitasuke. All rights reserved.
//

import UIKit
//import PagingMenuController

struct PagingMenuOptions: PagingMenuControllerCustomizable {
    private let activityViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "testlabelcollectionvc") as! LabelCollectionViewController
    private let contextViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "testlabelcollectionvc") as! LabelCollectionViewController
    private let moodViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "testlabelcollectionvc") as! LabelCollectionViewController
    
    
    
    internal var componentType: ComponentType {
        return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
    
    fileprivate var pagingControllers: [UIViewController] {
        moodViewController.initData(labels: [LabelStruct(imageName: "happy", labelText: "Happy"), LabelStruct(imageName: "sad", labelText: "Sad"), LabelStruct(imageName: "angry", labelText: "Angry"), LabelStruct(imageName: "annoyed", labelText: "Annoyed"), LabelStruct(imageName: "shocked", labelText: "Shocked"), LabelStruct(imageName: "stressed", labelText: "Stressed"), LabelStruct(imageName: "excited", labelText: "Excited"), LabelStruct(imageName: "satisfied", labelText: "Satisfied"), LabelStruct(imageName: "", labelText: "Other")])
        
        activityViewController.initData(labels: [LabelStruct(imageName: "sitting", labelText: "Sitting"),
                                          LabelStruct(imageName: "standing", labelText: "Standing"),
                                          LabelStruct(imageName: "walking", labelText: "Walking"),
                                          LabelStruct(imageName: "lying", labelText: "Lying"),
                                          LabelStruct(imageName: "running", labelText: "Running"),
                                          LabelStruct(imageName: "biking", labelText: "Biking"),
                                          LabelStruct(imageName: "stairsdown", labelText: "Stairs Down"),
                                          LabelStruct(imageName: "stairsup", labelText: "Stairs Up"),  LabelStruct(imageName: "", labelText: "Other")])
        
        contextViewController.initData(labels: [LabelStruct(imageName: "labelhome", labelText: "Home"), LabelStruct(imageName: "work", labelText: "Work"), LabelStruct(imageName: "school", labelText: "School"), LabelStruct(imageName: "store", labelText: "Store"), LabelStruct(imageName: "dining", labelText: "Dining"), LabelStruct(imageName: "gym", labelText: "Gym"), LabelStruct(imageName: "commute", labelText: "Commute"), LabelStruct(imageName: "library", labelText: "Library"), LabelStruct(imageName: "", labelText: "Other")])
        
        return [activityViewController, contextViewController, moodViewController]
    }
    
    fileprivate struct MenuOptions: MenuViewCustomizable {
        var displayMode: MenuDisplayMode {
            //return .standard(widthMode: MenuItemWidthMode.flexible, centerItem: true, scrollingMode: MenuScrollingMode.scrollEnabled)
            //return .segmentedControl
            return .infinite(widthMode: MenuItemWidthMode.flexible, scrollingMode: MenuScrollingMode.scrollEnabled)
        }
        var dummyItemViewsSet: Int{
            return 3
        }
        
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItem1(), MenuItem2(), MenuItem3()]
        }
    }
    
    
    fileprivate struct MenuItem1: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "Activity"))
        }
    }
    fileprivate struct MenuItem2: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "Context"))
        }
    }
    fileprivate struct MenuItem3: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "Mood"))
        }
    }
    
}

class ContextViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        print("program comes here.....")

        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.white
        self.title = "Labeling"
        
        let options = PagingMenuOptions()
        let pagingMenuController = PagingMenuController(options: options)
        //pagingMenuController.view.frame.origin.y += 80
        //pagingMenuController.view.frame.size.height -= 64
        
        pagingMenuController.view.frame.origin.y = self.view.bounds.origin.y

        
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
        
        addChild(pagingMenuController)
        view.addSubview(pagingMenuController.view)
        pagingMenuController.didMove(toParent: self)
        
        
        self.edgesForExtendedLayout = [.bottom]

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.tabBarController?.tabBar.isHidden = false
        //self.extendedLayoutIncludesOpaqueBars = true
        
        tabBarController?.tabBar.isHidden = true
        self.extendedLayoutIncludesOpaqueBars = false

    }
}

