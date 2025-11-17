//
//  Utilities:SignNameUtility.swift
//  HandSignTranslator2
//
//  Created by Elisa Guadalupe Alejos Torres on 16/11/25.
//

import Foundation
import UIKit


struct SignNameUtility {
    
    
    static func imageName(for character: String) -> String {
        return character.uppercased()
    }
    
    
    static func imageExists(for character: String) -> Bool {
        let name = imageName(for: character)
        return UIImage(named: name) != nil
    }
}
