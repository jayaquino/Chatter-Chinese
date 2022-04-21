//
//  UIButtonExtensions.swift
//  Chatter Chinese
//
//  Created by Nelson Aquino Jr  on 3/17/22.
//

import UIKit

extension UIButton {
    func pulse() {
    let pulse = CASpringAnimation(keyPath: "transform.scale")
    pulse.duration = 0.4
    pulse.fromValue = 0.8
    pulse.toValue = 1.0
    pulse.autoreverses = true
    pulse.repeatCount = .infinity
    pulse.initialVelocity = 0.5
    pulse.damping = 0.5
    layer.add(pulse, forKey: nil)
    }
}

extension UITableViewCell {
    func pulse() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.8
        pulse.fromValue = 0.98
        pulse.toValue = 1.0
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        layer.add(pulse, forKey: nil)
        }
}
