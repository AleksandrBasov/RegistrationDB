//
//  Utilities.swift
//  Registration
//
//  Created by Александр Басов on 11/9/21.
//

import Foundation
import UIKit

class Utilities {
    
    static func styleTextField(_ textfield: UITextField){
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
        textfield.borderStyle = .none
        textfield.layer.addSublayer(bottomLine)
    }
    
    static func styleFieldButton(_ button: UIButton){
        button.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button: UIButton){
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
    
    func isPasswordValid(_ Password : String) -> Bool{
        let Password = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z](?=.*[0-9].{>8}$")
        return Password.evaluate(with: Password)
    }
}
