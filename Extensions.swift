//
//  Extensions.swift
//  SuperSearch
//
//  Created by Clarke Kent on 1/1/23.
//

import Foundation
import UIKit


// https://stackoverflow.com/questions/41156542/how-to-blur-an-existing-image-in-a-uiimageview-with-swift
protocol Blurable {
    func addBlur(_ alpha: CGFloat)
}

extension Blurable where Self: UIView {
    func addBlur(_ alpha: CGFloat = 1.0) {
        // create effect
        let effect = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: effect)
        
        // set boundry and alpha
        effectView.frame = self.bounds
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        effectView.alpha = alpha
        
        self.addSubview(effectView)
    }
}

// Conformance
extension UIView: Blurable {}

