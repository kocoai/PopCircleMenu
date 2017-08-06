//
//  PopCircleMenuView.swift
//  CircleMenu
//
//  Created by 刘业臻 on 16/7/2.
//  Copyright © 2016年 Alex K. All rights reserved.
//

import UIKit

public class PopCircleMenuView: UIView, UIGestureRecognizerDelegate {

    public var circleButton: CircleMenu?

    private weak var selectedButton: CircleMenuButton?

    private lazy var longPressGestureRecognizer: UILongPressGestureRecognizer = {
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(PopCircleMenuView.onPress(sender:)))
        recognizer.delegate = self
        return recognizer
    }()

    init(frame: CGRect, buttonSize: CGSize, buttonsCount: Int = 3, duration: Double = 2,
         distance: Float = 100) {
        super.init(frame: frame)
        let rect     = CGRect(x: 0.0, y: 0.0, width: buttonSize.width, height: buttonSize.height)
        circleButton = CircleMenu(frame: rect, buttonsCount: buttonsCount, duration: duration, distance: distance)
        guard let circleButton = circleButton else {return}
        addSubview(circleButton)
        addGestureRecognizer(longPressGestureRecognizer)

    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        addGestureRecognizer(longPressGestureRecognizer)

    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        addGestureRecognizer(longPressGestureRecognizer)
    }

    @objc func onPress(sender: UILongPressGestureRecognizer) {
        guard let circleButton = circleButton else {return}
        circleButton.backgroundColor = UIColor.clear

        //circleButton.layer.borderColor = UIColor.color(255, green: 22, blue: 93, alpha: 1.0).CGColor
        circleButton.layer.borderWidth = 7.0
        bringSubview(toFront: circleButton)

        let buttonWidth = circleButton.bounds.width

        if sender.state == .began {
            circleButton.center = sender.location(in: self)
            circleButton.onTap()
            circleButton.isHidden = false
        } else if sender.state == .changed {
            guard let buttons = circleButton.buttons else {return}
            for button in buttons {
                guard let textLabel = button.textLabel else {return}
                let distance = button.center.distanceTo(pointB: sender.location(in: button))

                if distance <= buttonWidth / 2.0 {
                    let color = circleButton.highlightedBorderColor

                    button.changeDistance(distance: CGFloat(circleButton.distance) + 25.0)
                    button.layer.borderColor = color.cgColor

                    selectedButton   = button
                    textLabel.isHidden = false

                } else if distance >= 25 + buttonWidth / 2.0 {
                    let color = circleButton.normalBorderColor

                    button.changeDistance(distance: CGFloat(circleButton.distance))
                    button.layer.borderColor = color.cgColor

                    textLabel.isHidden = true

                }
            }

        } else if sender.state == .ended {
            let duration = circleButton.duration
            if let button = selectedButton {
                let distance = button.center.distanceTo(pointB: sender.location(in: button))
                if distance <= button.bounds.width / 2.0 {
                    circleButton.buttonHandler(sender: button)

                } else {
                    circleButton.onTap()
                    circleButton.hideCenterButton(duration: min(duration, 0.2))

                }
            } else {
                circleButton.onTap()
                circleButton.hideCenterButton(duration: min(duration, 0.2))

            }
        }
    }

    func setup() {
        let rect = CGRect(x: 0.0, y: 0.0, width: 44.0, height: 44.0)
        circleButton = CircleMenu(frame: rect)
        guard let circleButton = circleButton else {return}
        addSubview(circleButton)
    }
}
