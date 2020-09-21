//
//  OpenStudiesViewController.swift
//  cimonv2
//
//  Created by Afzal Hossain on 4/4/18.
//  Copyright © 2018 Afzal Hossain. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class OpenStudiesViewController: UICollectionViewController {
    fileprivate let reuseIdentifier = "openstudycell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 30.0, bottom: 50.0, right: 30.0)
    fileprivate var itemsPerRow: CGFloat = 2
    var publicStudiesData:[StudyStruct] = []
    // Create the Activity Indicator
    let activityIndicator = UIActivityIndicatorView(style: .gray)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        if UIScreen.main.bounds.width < 350{
            itemsPerRow = 1
        }else{
            itemsPerRow = 2
        }
        
        // Add it to the view where you want it to appear
        view.addSubview(activityIndicator)
        // Set up its size (the super view bounds usually)
        activityIndicator.frame = view.bounds
        
        // Register cell classes
        self.collectionView!.register(OpenStudyViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.enrollToStudy(_:)), name: NSNotification.Name(rawValue: "enrolledtostudy"), object: nil)
        
        populatePublicStudies()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populatePublicStudies(){
        // Start the loading animation
        activityIndicator.startAnimating()
        
        publicStudiesData = []
        let email:String = Utils.getDataFromUserDefaults(key: "email") as! String
        let serviceUrl = Utils.getBaseUrl() + "study/list/open/public?email=\(email)"
        Alamofire.request(serviceUrl).validate().responseJSON { response in
            self.activityIndicator.stopAnimating()
            switch response.result {
            case .success:
                let json = JSON(response.result.value as Any)
                print("response after object : \(json)")
                for item in json.arrayValue{
                    self.publicStudiesData.append(StudyStruct.responseFromJSONData(jsonData: item))
                }
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
                
            case .failure(let error):
                print(error)
                // TODO: show error label - service not available
            }
        }

    }
    
    @objc func enrollToStudy(_ notification: NSNotification){
        guard let index = notification.userInfo?["index"] as? IndexPath else { return }
        print ("index: \(index.section), \(index.row)")
        publicStudiesData.remove(at: index.row)
        DispatchQueue.main.async {
            self.collectionView?.deleteItems(at: [index])
            self.collectionView?.reloadData()

        }
    }
    
}


// MARK: - UICollectionViewDataSource
extension OpenStudiesViewController {
    //1
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return publicStudiesData.count
    }
    
    //3
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! OpenStudyViewCell
        print("len \(publicStudiesData.count), \(indexPath), \(publicStudiesData[0].name)")
        //2
        //let flickrPhoto = photoForIndexPath(indexPath: indexPath)
        //cell.backgroundColor = UIColor.white
        //3
        //cell.imageView.image = flickrPhoto.thumbnail
        //cell.studyThumbnail?.image = flickrPhoto.thumbnail
        //cell.studyName?.text = flickrPhoto.photoID
        //print("photo id:\(flickrPhoto.photoID)")
        //cell.
        cell.nameLabel.text = publicStudiesData[indexPath.row].name

        // add a border
        cell.layer.borderColor = UIColor(red: 0.8824, green: 0.7059, blue: 0.1647, alpha: 1.0).cgColor /* #gold */

        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 15 // optional
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let viewController = UIStoryboard(name: "Study", bundle: nil).instantiateViewController(withIdentifier: "openstudydetailsvc") as? OpenStudyDetailsViewController {
            viewController.indexPathInList = indexPath
            viewController.studyDetails = publicStudiesData[indexPath.row]
            //viewController.selectedNotification = object as! AppNotification
            navigationController?.pushViewController(viewController, animated: true)
            
        }

    }
    
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
                                                                             withReuseIdentifier: "openstudyheader",
                                                                             for: indexPath) as! StudyHeaderReusableView
            //headerView.studyHeader.text = searches[(indexPath as NSIndexPath).section].searchTerm
            
            return headerView
        default:
            //4
            fatalError("Unexpected element kind")
        }
    }
    
}


extension OpenStudiesViewController : UICollectionViewDelegateFlowLayout {
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
        return sectionInsets.left
    }
}

