//
//  ViewController.swift
//  Storm Viewer
//
//  Created by Carlos Irigoyen on 4/22/19.
//  Copyright © 2019 Carlos Irigoyen. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
  
  var pictures = [String]()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    // Title Large True
    title = "Storm Viewer"
    navigationController?.navigationBar.prefersLargeTitles = true
    
    // Display button on navigationBar for Share Content
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped(sender:)))
    
    let fm = FileManager.default
    let path = Bundle.main.resourcePath!
    // Print
    // "/Users/carlosirigoyen/Library/Developer/CoreSimulator/Devices/91B6C70A-9196-4CC3-9F57-3D88796A871F/data/Containers/Bundle/Application/A99E25D1-04D9-4008-8592-26016AA43123/Storm Viewer.app"
    
    let items = try! fm.contentsOfDirectory(atPath: path)
    // Print
    //    - 0 : "_CodeSignature"
    //    - 1 : "libswiftRemoteMirror.dylib"
    //    - 2 : "nssl0049.jpg"
    //    - 3 : "Base.lproj"
    //    - 4 : "nssl0046.jpg"
    //    - 5 : "nssl0091.jpg"
    //    - 6 : "nssl0045.jpg"
    //    - 7 : "nssl0051.jpg"
    //    - 8 : "nssl0041.jpg"
    //    - 9 : "Storm Viewer"
    //    - 10 : "nssl0042.jpg"
    //    - 11 : "nssl0043.jpg"
    //    - 12 : "nssl0033.jpg"
    //    - 13 : "Frameworks"
    //    - 14 : "Info.plist"
    //    - 15 : "PkgInfo"
    //    - 16 : "nssl0034.jpg"
    
    for item in items {
      if item.hasPrefix("nssl") {
        // this is a picture to load!
        pictures.append(item)
      }
    }
    pictures.sort(by: <)
    
    print(fm)
    print(path)
    print(items)
    print(pictures.count)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pictures.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    print(indexPath)
    print(indexPath.row)
    let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
    cell.textLabel?.text = pictures[indexPath.row]
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
      vc.selectedImage = pictures[indexPath.row]
      vc.selectedImagePosition = indexPath.row + 1
      vc.totalImagesCount = pictures.count
      navigationController?.pushViewController(vc, animated: true)
    }
  }
  
  @objc func shareTapped(sender:UIView) {
    // Para permitir el guardado de las imagenes en el dispositivo debemos aplicar un cambio sobre info.plist
    // Añadir un nuevo Row, agregar Privacy Photo Library "Privacy - Photo Library Additions Usage Descrip" and add text description
    
    

    
//    let vc = UIActivityViewController(activityItems: [imageText!, image], applicationActivities: [])
//    vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
//    present(vc, animated: true)
    
    
    
    
    UIGraphicsBeginImageContext(view.frame.size)
    view.layer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    print(image ?? "no hay nada")
    let textToShare = "Check out my app"
    
    if let myWebsite = URL(string: "http://itunes.apple.com/app/idXXXXXXXXX") {//Enter link to your app here
      let objectsToShare = [textToShare, myWebsite, image ?? #imageLiteral(resourceName: "app-logo")] as [Any]
      let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
      
      //Excluded Activities
      activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
      //
      
//      activityVC.popoverPresentationController?.sourceView = sender
      activityVC.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
      self.present(activityVC, animated: true, completion: nil)
    }
  }


}

