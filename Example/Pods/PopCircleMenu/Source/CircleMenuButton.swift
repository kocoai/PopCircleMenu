//
//  CircleMenuButton.swift
//  PopCircleMenu
//
//  Created by 刘业臻 on 16/7/8.
//  Copyright © 2016年 luiyezheng. All rights reserved.
//

import UIKit

public class CircleMenuButton: UIButton {

    // MARK: properties

    internal weak var circleMenu: CircleMenu?

    internal weak var container: UIView?

    private var rotateTransform: CATransform3D?

    internal var newAngle: Float = 0.0

    internal var view = UIView()

    internal weak var textLabel: UITextField?

    // MARK: life cycle

    init(size: CGSize, circleMenu: CircleMenu, distance: Float, angle: Float = 0, index: Int) {
        super.init(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: size))

        self.circleMenu = circleMenu

        self.backgroundColor = UIColor(red: 0.79, green: 0.24, blue: 0.27, alpha: 1)
        self.layer.cornerRadius = size.height / 2.0

        let aContainer = createContainer(size: CGSize(width: size.width, height:CGFloat(distance)), circleMenu: circleMenu)

        // hack view for rotate
        view = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        view.backgroundColor = UIColor.clear
        view.addSubview(self)

        //Create textLabel
        textLabel = UITextField(frame: CGRect(x: 0.0, y: 0.0, width: self.bounds.width, height: self.bounds.height))
        guard let textLabel = textLabel else {return}

        textLabel.font          = UIFont(name: "Helvetica-Bold", size: 12)
        textLabel.isHidden        = true
        textLabel.textColor     = UIColor.white
        textLabel.textAlignment = .center
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.backgroundColor           = UIColor.clear
        textLabel.isUserInteractionEnabled    = false
        textLabel.contentVerticalAlignment  = .top

        aContainer.addSubview(view)
        aContainer.addSubview(textLabel)

        //...
        container = aContainer

        self.rotatedZ(angle: angle, animated: false, distance: distance)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: configure

    private func createContainer(size: CGSize, circleMenu: CircleMenu) -> UIView {

        guard let circleMenuSuperView = circleMenu.superview else {
            fatalError("wront circle menu")
        }

        let container = Init(value: UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: size))) {
            $0.backgroundColor                           = UIColor.clear
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.layer.anchorPoint                         = CGPoint(x: 0.5, y: 1)
        }
        circleMenuSuperView.insertSubview(container, belowSubview: circleMenu)

        // added constraints
        let height = NSLayoutConstraint(item: container,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .height,
                                        multiplier: 1,
                                        constant: size.height)
        height.identifier = "height"
        container.addConstraint(height)

        container.addConstraint(NSLayoutConstraint(item: container,
                                                   attribute: .width,
                                                   relatedBy: .equal,
            toItem: nil,
            attribute: .width,
            multiplier: 1,
            constant: size.width))

        circleMenuSuperView.addConstraint(NSLayoutConstraint(item: circleMenu,
                                                             attribute: .centerX,
                                                             relatedBy: .equal,
            toItem: container,
            attribute: .centerX,
            multiplier: 1,
            constant:0))

        circleMenuSuperView.addConstraint(NSLayoutConstraint(item: circleMenu,
                                                             attribute: .centerY,
                                                             relatedBy: .equal,
            toItem: container,
            attribute: .centerY,
            multiplier: 1,
            constant:0))

        return container
    }

    // MARK: methods

    internal func rotatedZ(angle: Float, animated: Bool, duration: Double = 0, delay: Double = 0, distance: Float) {
        guard let container = self.container else {
            fatalError("contaner don't create")
        }

        guard let superViewWidth = (circleMenu!.superview?.bounds.width) else {return}
        guard let superViewX     = circleMenu!.superview?.bounds.maxX else {return}
        let circleMenuY          = circleMenu!.center.y
        let circleMenuX          = circleMenu!.center.x
        let distanceX            = circleMenu!.center.distanceTo(pointB: CGPoint(x: superViewX, y: circleMenuY))
        let distanceY            = circleMenu!.center.distanceTo(pointB: CGPoint(x: circleMenuX, y: 0.0))
        let circleMenuWidth      = circleMenu!.bounds.width

        let inset = CGFloat(distance)
        let yinset = CGFloat(distance) + 2 * circleMenuWidth

        guard let textLabel = textLabel else {return}

        //Top
        if circleMenuY < yinset && circleMenuX > inset && circleMenuX < (superViewWidth - inset) {
            let newAngle = angle + 270
            rotateTransform           = CATransform3DMakeRotation(-CGFloat(newAngle.degrees) / 2.4, 0, 0, 1)
            view.layer.transform      = CATransform3DMakeRotation(CGFloat(newAngle.degrees) / 2.4, 0, 0, 1)
            textLabel.layer.transform = CATransform3DMakeRotation(CGFloat(newAngle.degrees) / 2.4, 0, 0, 1)

        }
            //Bottom
        else if circleMenuX > inset && circleMenuX <  (superViewWidth - inset) {
            let newAngle = angle - 120
            rotateTransform           = CATransform3DMakeRotation(-CGFloat(newAngle.degrees) / 2.4, 0, 0, 1)
            view.layer.transform      = CATransform3DMakeRotation(CGFloat(newAngle.degrees) / 2.4, 0, 0, 1)
            textLabel.layer.transform = CATransform3DMakeRotation(CGFloat(newAngle.degrees) / 2.4, 0, 0, 1)

            //Top-left
        } else if distanceX - inset > 0 && (distanceY - yinset) < 0 {
            let newAngle = angle + 180
            rotateTransform           = CATransform3DMakeRotation(CGFloat(newAngle.degrees) / 2.4, 0, 0, 1)
            view.layer.transform      = CATransform3DMakeRotation(-CGFloat(newAngle.degrees) / 2.4, 0, 0, 1)
            textLabel.layer.transform = CATransform3DMakeRotation(-CGFloat(newAngle.degrees) / 2.4, 0, 0, 1)

            //Top-right
        } else if (distanceX - inset) < 0 && (distanceY - yinset) < 0 {
            let newAngle = angle + 180
            rotateTransform           = CATransform3DMakeRotation(-CGFloat(newAngle.degrees) / 2.4, 0, 0, 1)
            view.layer.transform      = CATransform3DMakeRotation(CGFloat(newAngle.degrees) / 2.4, 0, 0, 1)
            textLabel.layer.transform = CATransform3DMakeRotation(CGFloat(newAngle.degrees) / 2.4, 0, 0, 1)

            //Bottom-left
        } else if (distanceX - inset) > 0 && (distanceY - yinset) > 0 {
            rotateTransform           = CATransform3DMakeRotation(CGFloat(angle.degrees) / 2.4, 0, 0, 1)
            view.layer.transform      = CATransform3DMakeRotation(-CGFloat(angle.degrees) / 2.4, 0, 0, 1)
            textLabel.layer.transform = CATransform3DMakeRotation(-CGFloat(angle.degrees) / 2.4, 0, 0, 1)

            //Regular
        } else {
            rotateTransform           = CATransform3DMakeRotation(-CGFloat(angle.degrees) / 2.4, 0, 0, 1)
            view.layer.transform      = CATransform3DMakeRotation(CGFloat(angle.degrees) / 2.4, 0, 0, 1)
            textLabel.layer.transform = CATransform3DMakeRotation(CGFloat(angle.degrees) / 2.4, 0, 0, 1)

        }
        textLabel.bounds.size.height = self.bounds.width * 2.0

        guard let transform = rotateTransform else {return}

        if animated {
            UIView.animate(
                withDuration: duration,
                delay: delay,
                options: UIViewAnimationOptions.curveEaseInOut,
                animations: { () -> Void in
                    container.layer.transform = transform

                    textLabel.center = self.view.center

                },
                completion: nil)
        } else {
            container.layer.transform = transform

            textLabel.center = self.view.center

        }
    }
}

// MARK: Animations

internal extension CircleMenuButton {
    internal func showAnimation(distance: Float, duration: Double, delay: Double = 0) {
        guard let container = self.container else {
            fatalError()
        }

        let heightConstraint = self.container?.constraints.filter {$0.identifier == "height"}.first

        guard heightConstraint != nil else {
            return
        }
        self.transform = CGAffineTransform(scaleX: 0, y: 0)
        container.superview?.layoutIfNeeded()

        self.alpha = 0

        heightConstraint?.constant = CGFloat(distance)
        UIView.animate(
            withDuration: duration,
            delay: delay,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0,
            options: UIViewAnimationOptions.curveLinear,
            animations: { () -> Void in
                container.superview?.layoutIfNeeded()
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.alpha = 1
            }, completion: { (success) -> Void in
        })
    }

    internal func hideAnimation(distance: Float, duration: Double, delay: Double = 0) {

        guard let container = self.container else {
            fatalError()
        }

        let heightConstraint = self.container?.constraints.first {$0.identifier == "height"}

        guard heightConstraint != nil else {
            return
        }
        heightConstraint?.constant = CGFloat(distance)
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: .curveEaseInOut,
            animations: { () -> Void in
                container.superview?.layoutIfNeeded()
                self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }, completion: { (success) -> Void in
                self.alpha = 0

                if let _ = self.container {
                    if let textLabel = self.textLabel {
                        textLabel.removeFromSuperview() // remove textLabel
                    }
                    container.removeFromSuperview() // remove container
                }
        })
    }

    internal func changeDistance(distance: CGFloat) {

        guard let container = self.container else {
            fatalError()
        }

        let heightConstraint = self.container?.constraints.filter {$0.identifier == "height"}.first

        guard heightConstraint != nil else {
            return
        }

        heightConstraint?.constant = distance 
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 0.8,
            options: .curveEaseInOut,
            animations: {
                container.superview?.layoutIfNeeded()
            }, completion: nil)
    }

    // MARK: layer animation

    internal func rotationLayerAnimation(angle: Float, duration: Double) {
        if let aContainer = container {
            rotationLayerAnimation(view: aContainer, angle: angle, duration: duration)
        }
    }
}

internal extension UIView {
    internal func rotationLayerAnimation(view: UIView, angle: Float, duration: Double) {

        let rotation = Init(value: CABasicAnimation(keyPath: "transform.rotation")) {
            $0.duration       = TimeInterval(duration)
            $0.toValue        = (angle.degrees)
            $0.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        }
        view.layer.add(rotation, forKey: "rotation")
    }
}
