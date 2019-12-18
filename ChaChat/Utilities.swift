//
//  Utilities.swift
//  ChaChat
//
//  Created by Elnur Rzayev on 03/10/2018.
//  Copyright © 2018 Elnur Rzayev. All rights reserved.
//

import Foundation
import UIKit

class Utilities{
    
    
//    ALERT Code
//    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    func showAlert(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
//    ALERT FINISH
//    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    func getDate() -> String{
        let today : Date = Date()
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:MM"
        return dateFormatter.string(from: today)
    }
    
}
