//
//  Extensions.swift
//  Budget
//
//  Created by user on 22/09/2020.
//  Copyright © 2020 Sergey Neupokoev. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
}

public extension UIView {
    
    func vibrate() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }

    func shake(count : Float = 2,for duration : TimeInterval = 0.5,withTranslation translation : Float = 2) {

        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.speed = 4
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = count
        animation.duration = duration/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.values = [translation, -translation]
        layer.add(animation, forKey: "shake")
    }
    

}
