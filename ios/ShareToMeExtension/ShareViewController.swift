//
//  ShareViewController.swift
//  ShareToMeExtension
//
//  Created by Sean Yesmunt on 4/23/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices
import Foundation

class ShareViewController: SLComposeServiceViewController {
  
  var urlFromPage = ""

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
      
      let requestString = "https://c706a6f2.ngrok.io?url=" + urlFromPage;
      let requestURL = URL(string: requestString)!
      let task = URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
        if error == nil {
          print("success")
        }
      }
      
      task.resume()
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }
  
  override func viewDidLoad() {
    let extensionItem = extensionContext?.inputItems.first as! NSExtensionItem
    let itemProvider = extensionItem.attachments?.first as! NSItemProvider
    let propertyList = String(kUTTypePropertyList)
    if itemProvider.hasItemConformingToTypeIdentifier(propertyList) {
      itemProvider.loadItem(forTypeIdentifier: propertyList, options: nil, completionHandler: { (item, error) -> Void in
        guard let dictionary = item as? NSDictionary else { return }
        OperationQueue.main.addOperation {
          if let results = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary,
            let urlString = results["URL"] as? String {
            self.urlFromPage = urlString;
          }
        }
      })
    } else {
      print("error")
    }
  }

}
