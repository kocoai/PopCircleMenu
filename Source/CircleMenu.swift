//
//  CircleMenu1.swift
//  PopCircleMenu
//
//  Created by 刘业臻 on 16/7/8.
//  Copyright © 2016年 luiyezheng. All rights reserved.
//


import UIKit

// MARK: helpers

func Init<Type>(value: Type, block: (_ object: Type) -> Void) -> Type {
    block(value)
    return value
}

// MARK: Protocol

/**
 *  CircleMenuDelegate
 */
@objc public protocol CircleMenuDelegate {

    /**
     Tells the delegate the circle menu is about to draw a button for a particular index.

     - parameter circleMenu: The circle menu object informing the delegate of this impending event.
     - parameter button:     A circle menu button object that circle menu is going to use when drawing the row. Don't change button.tag
     - parameter atIndex:    An button index.
     */
    @objc optional func circleMenu(circleMenu: CircleMenu, willDisplay button: CircleMenuButton, atIndex: Int)

    /**
     Tells the delegate that a specified index is about to be selected.

     - parameter circleMenu: A circle menu object informing the delegate about the impending selection.
     - parameter button:     A selected circle menu button. Don't change button.tag
     - parameter atIndex:    Selected button index
     */
    @objc optional func circleMenu(circleMenu: CircleMenu, buttonWillSelected button: CircleMenuButton, atIndex: Int)

    /**
     Tells the delegate that the specified index is now selected.

     - parameter circleMenu: A circle menu object informing the delegate about the new index selection.
     - parameter button:     A selected circle menu button. Don't change button.tag
     - parameter atIndex:    Selected button index
     */
    @objc optional func circleMenu(circleMenu: CircleMenu, buttonDidSelected button: CircleMenuButton, atIndex: Int)
}

// MARK: CircleMenu

/// A Button object with pop ups buttons
public class CircleMenu: UIButton {

    // MARK: properties

    /// Buttons count
    public var buttonsCount: Int = 3
    /// Circle animation duration
    public var duration: Double  = 2
    /// Distance between center button and buttons
    public var distance: Float   = 100
    /// Delay between show buttons
    public var showDelay: Double = 0.0
    /// Highlighted border Color
    public var highlightedBorderColor: UIColor = UIColor(red: 255, green: 22, blue: 93, alpha: 1.0)
    /// Normal border Color
    public var normalBorderColor: UIColor = UIColor.white

    /// The object that acts as the delegate of the circle menu.
    @IBOutlet weak public var delegate: CircleMenuDelegate?

    var buttons: [CircleMenuButton]?

    // MARK: life cycle

    /**
     Initializes and returns a circle menu object.

     - parameter frame:        A rectangle specifying the initial location and size of the circle menu in its superview’s coordinates.
     - parameter normalIcon:   The image to use for the specified normal state.
     - parameter selectedIcon: The image to use for the specified selected state.
     - parameter buttonsCount: The number of buttons.
     - parameter duration:     The duration, in seconds, of the animation.
     - parameter distance:     Distance between center button and sub buttons.

     - returns: A newly created circle menu.
     */
    public init(frame: CGRect, buttonsCount: Int = 3, duration: Double = 2,
                distance: Float = 100) {
        super.init(frame: frame)

        self.buttonsCount = buttonsCount
        self.duration     = duration
        self.distance     = distance

        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = true
        layer.borderColor = highlightedBorderColor.withAlphaComponent(0.5).cgColor

        setImage(UIImage(), for: .normal)
        setImage(UIImage(), for: .selected)
    }

    // MARK: methods

    /**
     Hide button

     - parameter duration:  The duration, in seconds, of the animation.
     - parameter hideDelay: The time to delay, in seconds.
     */
    public func hideButtons(duration: Double, hideDelay: Double = 0) {
        if buttons == nil {
            return
        }

        buttonsAnimationIsShow(isShow: false, duration: duration, hideDelay: hideDelay)
        tapBounceAnimation()
        tapRotatedAnimation(duration: 0.3, isSelected: false)
    }

    /**
     Check is sub buttons showed
     */
    public func buttonsIsShown() -> Bool {
        guard let buttons = self.buttons else {
            return false
        }

        for button in buttons {
            if button.alpha == 0 {
                return false
            }
        }
        return true
    }

    // MARK: create

    private func createButtons() -> [CircleMenuButton] {
        var buttons = [CircleMenuButton]()

        let step: Float = 360.0 / Float(self.buttonsCount)
        for index in 0..<self.buttonsCount {

            let angle: Float = (Float(index) * step) / 2.5
            let distance = Float(self.bounds.size.height/2.0)
            let size = CGSize(width: self.bounds.width, height: self.bounds.height)
            let button = Init(value: CircleMenuButton(size: size, circleMenu: self, distance:distance, angle: angle, index: index)) {
                $0.tag = index
                $0.addTarget(self, action: #selector(CircleMenu.buttonHandler(sender:)), for: UIControlEvents.touchDragExit)
                $0.alpha = 0
            }
            buttons.append(button)
        }
        return buttons
    }

    // MARK: configure

    // MARK: actions

    func onTap() {
        if buttonsIsShown() == false {
            buttons = createButtons()
        }
        let isShow = !buttonsIsShown()

        let duration  = isShow ? self.duration : min(0.2, self.duration)
        buttonsAnimationIsShow(isShow: isShow, duration: duration)
        tapBounceAnimation()
        tapRotatedAnimation(duration: Float(duration), isSelected: isShow)
    }

    @objc internal func buttonHandler(sender: UIButton) {
        guard case let sender as CircleMenuButton = sender else {
            return
        }

        delegate?.circleMenu?(circleMenu: self, buttonWillSelected: sender, atIndex: sender.tag)


        if let container = sender.container { // rotation animation
            container.superview?.bringSubview(toFront: container)
        }

        if let _ = buttons {
            hideCenterButton(duration: min(duration, 0.2))
            buttonsAnimationIsShow(isShow: false, duration: min(duration, 0.2), hideDelay: 0.0)
        }

        let dispatchTime = DispatchTime.now() + min(duration, 0.2) * Double(NSEC_PER_SEC)

        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.delegate?.circleMenu?(circleMenu: self, buttonDidSelected: sender, atIndex: sender.tag)
        }
    }

    // MARK: animations
    private func buttonsAnimationIsShow(isShow: Bool, duration: Double, hideDelay: Double = 0) {
        guard let buttons = self.buttons else {
            return
        }

        let step: Float = 360.0 / Float(self.buttonsCount)
        for index in 0..<self.buttonsCount {
            let button = buttons[index]
            let angle: Float = Float(index) * step
            if isShow == true {
                delegate?.circleMenu?(circleMenu: self, willDisplay: button, atIndex: index)

                button.rotatedZ(angle: angle, animated: false, delay: Double(index) * showDelay, distance: distance)
                button.showAnimation(distance: distance, duration: duration, delay: Double(index) * showDelay)
            } else {
                button.hideAnimation(
                    distance: Float(self.bounds.size.height / 2.0),
                    duration: duration, delay: hideDelay)
            }
        }
        if isShow == false { // hide buttons and remove

            self.buttons = nil
        }
    }

    private func tapBounceAnimation() {
        self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 5,
                       options: UIViewAnimationOptions.curveLinear,
                                   animations: { () -> Void in
                                    self.transform = CGAffineTransform(scaleX: 1, y: 1)
            },
                                   completion: nil)
    }

    private func tapRotatedAnimation(duration: Float, isSelected: Bool) {
        self.isSelected = isSelected
        self.alpha = 1.0
    }

    internal func hideCenterButton(duration: Double, delay: Double = 0) {
        UIView.animate( withDuration: TimeInterval(duration), delay: TimeInterval(delay),
                        options: UIViewAnimationOptions.curveEaseOut,
                                    animations: { () -> Void in
                                        self.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            }, completion: nil)
    }
}
