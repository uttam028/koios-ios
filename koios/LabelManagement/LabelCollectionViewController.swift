//
//  TestLabelCollectionViewController.swift
//  cimonv2
//
//  Created by Afzal Hossain on 4/9/18.
//  Copyright © 2018 Afzal Hossain. All rights reserved.
//

import UIKit


class LabelCollectionViewController: UICollectionViewController {
    fileprivate let reuseIdentifier = "labelviewcell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    fileprivate var itemsPerRow: CGFloat = 3
    var collectionItemSelectDelegate:CollectionItemSelectDelegate!
    var labelList:[LabelStruct] = [LabelStruct]()
    
    func initData(labels:[LabelStruct]){
        labelList = labels
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(LabelCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        //self.collectionView?.backgroundColor = UIColor.red
        self.collectionView?.allowsMultipleSelection = true;
        self.collectionView?.allowsSelection = true; //this is set by default

        let backgroundImage = UIImage(named: "labelbackground")!
        let backgroundView = UIImageView(image: backgroundImage)
        self.collectionView?.backgroundView = backgroundView

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - UICollectionViewDataSource
extension LabelCollectionViewController {
    //1
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return labelList.count
    }
    
    //3
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! LabelCollectionViewCell
        
        if cell.subViewAdded{
            //do nothing
        }else{
            cell.addViewsToCell(imageName: labelList[indexPath.row].imageName, labelText: labelList[indexPath.row].labelText)
        }
        
        // add a border
        cell.layer.borderColor = UIColor(red: 0.8824, green: 0.7059, blue: 0.1647, alpha: 1.0).cgColor /* #e1b42a */
        cell.layer.borderWidth = 1
        //cell.layer.cornerRadius = 10 // optional
        
        //cell.delegate = self
        
        return cell
    }
    
    /*
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //guard let label = sender.labelButton.titleLabel?.text as! String? else { return }
        let label = labelTextList[indexPath.row]
        
        collectionItemSelectDelegate.handleItemTapAction(label: label)
        print("select item \(indexPath.row), label:\(label)")
    }*/
    
    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        
        let label = labelList[indexPath.row].labelText
        
        collectionItemSelectDelegate.handleItemTapAction(label: label)
        print("select item highlight \(indexPath.row), label:\(label)")
        self.collectionView?.setContentOffset(CGPoint(x:0,y:0), animated: true)
    }
    
    
    /*
    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let label = labelTextList[indexPath.row]
        
        collectionItemSelectDelegate.handleItemTapAction(label: label)
        print("select item unhighlight \(indexPath.row), label:\(label)")

    }*/
    
    /*
     override func collectionView(_ collectionView: UICollectionView,
     moveItemAt sourceIndexPath: IndexPath,
     to destinationIndexPath: IndexPath) {
     
     var sourceResults = searches[(sourceIndexPath as NSIndexPath).section].searchResults
     let flickrPhoto = sourceResults.remove(at: (sourceIndexPath as NSIndexPath).row)
     
     var destinationResults = searches[(destinationIndexPath as NSIndexPath).section].searchResults
     destinationResults.insert(flickrPhoto, at: (destinationIndexPath as NSIndexPath).row)
     }*/
    
    
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        //1
        switch kind {
        //2
        case UICollectionView.elementKindSectionHeader:
            //3
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "labelheaderreuseview",
                                                                             for: indexPath) as! LabelHeaderReusableView
            //headerView.studyHeader.text = searches[(indexPath as NSIndexPath).section].searchTerm
            self.collectionItemSelectDelegate = headerView
            return headerView
        default:
            //4
            fatalError("Unexpected element kind")
        }
    }
    
}


extension LabelCollectionViewController : UICollectionViewDelegateFlowLayout {
    
    
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        //return sectionInsets.left
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


protocol CollectionItemSelectDelegate: class {
    func handleItemTapAction(label:String)
}


