//
//  Social.swift
//  iOS Example
//
//  Created by v.a.prusakov on 24/04/2018.
//  Copyright © 2018 v.a.prusakov. All rights reserved.
//

import UIKit

enum Social {
    case twitter
    case github
    case medium
    
    var logo: UIImage {
        switch self {
        case .twitter:
            return #imageLiteral(resourceName: "twitter")
        case .github:
            return #imageLiteral(resourceName: "github")
        case .medium:
            return #imageLiteral(resourceName: "medium")
        }
    }
    
    var name: String {
        switch self {
        case .twitter:
            return "Twitter"
        case .github:
            return "Github"
        case .medium:
            return "Medium"
        }
    }
    
    var color: UIColor {
        switch self {
        case .twitter:
            return UIColor(hex: "#1da1f2")
        case .github:
            return UIColor(hex: "#fafafa")
        case .medium:
            return UIColor(hex: "#00ab6c")
        }
    }
    
    var url: URL? {
        switch self {
        case .twitter:
            return URL(string: "http://twitter.com/spectraldragon_")
        case .github:
            return URL(string: "https://github.com/SpectralDragon")
        case .medium:
            return URL(string: "https://medium.com/@SpectralDragon")
        }
    }
}
