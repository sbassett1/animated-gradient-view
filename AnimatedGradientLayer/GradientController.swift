//
//  GradientController.swift
//  AnimatedGradientLayer
//
//  Created by Stephen Bassett on 5/21/19.
//  Copyright © 2019 Stephen Bassett. All rights reserved.
//

import UIKit

class GradientController: UIViewController {
    
    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient = 0
    let gradientOne = UIColor.rgb(48, green: 62, blue: 103).cgColor
    let gradientTwo = UIColor.rgb(244, green: 88, blue: 53).cgColor
    let gradientThree = UIColor.rgb(196, green: 70, blue: 107).cgColor

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradientSet.append([gradientOne, gradientTwo])
        gradientSet.append([gradientTwo, gradientThree])
        gradientSet.append([gradientThree, gradientOne])
        gradient.colors = gradientSet[currentGradient]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.drawsAsynchronously = true
        view.layer.addSublayer(gradient)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradient.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateGradient()
    }

    func animateGradient() {
        var previousGradient: Int!
        if currentGradient < gradientSet.count - 1 {
            currentGradient += 1
            previousGradient = currentGradient - 1
        } else {
            currentGradient = 0
            previousGradient = gradientSet.count - 1
        }
        let gradientChangeAnim = CABasicAnimation(keyPath: "colors")
        gradientChangeAnim.duration = 5.0
        gradientChangeAnim.fromValue = gradientSet[previousGradient]
        gradientChangeAnim.toValue = gradientSet[currentGradient]
        gradient.setValue(currentGradient, forKey: "colorChange")
        
        gradientChangeAnim.delegate = self
        gradient.add(gradientChangeAnim, forKey: nil)
    }
    
}

extension GradientController: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            if let colorChange = gradient.value(forKey: "colorChange") as? Int {
                gradient.colors = gradientSet[colorChange]
                animateGradient()
            }
        }
    }
    
}

extension UIColor {
    
    static func rgb(_ red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
}
