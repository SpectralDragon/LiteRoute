//
//  Extensions.swift
//  iOS Example
//
//  Created by v.a.prusakov on 10/04/2018.
//  Copyright © 2018 v.a.prusakov. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get { return self.layer.cornerRadius }
        set { self.layer.cornerRadius = newValue }
    }
    
    enum RoundingType {
        case circle
        case `default`
        case custom(CGFloat)
    }
    
    func round(by type: RoundingType, masked isMasked: Bool? = nil) {
        let radius: CGFloat
        switch type {
        case .circle:
            radius = min(self.bounds.width, self.bounds.height) / 2
        case .default:
            radius = Style.Sizes.cornerRadius
        case .custom(let r):
            radius = r
        }
        
        self.layer.cornerRadius = radius
        if let isMasked = isMasked {
            self.layer.masksToBounds = isMasked
        }
    }
}

extension UIView {
    
    func applyShadow(color: UIColor = .black, radius: CGFloat = 10, opacity: Float = 1.0, offset: CGSize = .zero) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
    }
    
}

extension UIView {
    convenience init(color: UIColor) {
        self.init()
        self.backgroundColor = color
    }
}

extension UIColor {
    /// - seealso: https://gist.github.com/asarode/7b343fa3fab5913690ef
    static var random: UIColor {
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
    
    var isDark: Bool {
        var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 0.0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let colorBrightness = ((red * 299) + (green * 587) + (blue * 114)) / 1000
        return colorBrightness < 0.5
    }
    
    var readableTextColor: UIColor {
        return self.isDark ? UIColor.white : Style.Colors.textGray
    }
    
    /// - seealso: https://stackoverflow.com/a/48890509/5531429
    var darker: UIColor {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            
            let pFactor: CGFloat = 70.0 / 100.0
            
            let newRed = (red * pFactor).clamped(to: 0.0 ... 1.0)
            let newGreen = (green * pFactor).clamped(to: 0.0 ... 1.0)
            let newBlue = (blue * pFactor).clamped(to: 0.0 ... 1.0)
            
            return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: alpha)
        }
        
        return self
    }
    
    convenience init(hex: String) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = String(cString[cString.index(cString.startIndex, offsetBy: 1)...])
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: 1.0)
    }
}

extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

extension Comparable {
    
    func clamped(to range: ClosedRange<Self>) -> Self {
        
        if self > range.upperBound {
            return range.upperBound
        } else if self < range.lowerBound {
            return range.lowerBound
        } else {
            return self
        }
    }
}
