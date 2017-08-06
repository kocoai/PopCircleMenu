//
//  ViewController.swift
//  Example
//
//  Created by 刘业臻 on 16/7/8.
//  Copyright © 2016年 luiyezheng. All rights reserved.
//

import UIKit
import PopCircleMenu

class ViewController: UIViewController, CircleMenuDelegate {
    
    @IBOutlet var popMenuView: PopCircleMenuView!
    
    let items: [(icon: String, color: UIColor, text: String)] = [
        ("icon_home", UIColor(red:0.19, green:0.57, blue:1, alpha:1), "home"),
        ("icon_search", UIColor(red:0.22, green:0.74, blue:0, alpha:1), "search"),
        ("notifications-btn", UIColor(red:0.96, green:0.23, blue:0.21, alpha:1), "bell"),
        ("settings-btn", UIColor(red:0.51, green:0.15, blue:1, alpha:1), "setting"),
        ("nearby-btn", UIColor(red:1, green:0.39, blue:0, alpha:1), "nearby"),
        ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        popMenuView.circleButton?.delegate = self
        //Buttons count
        popMenuView.circleButton?.buttonsCount = 4
        
        //Distance between buttons and the red circle
        popMenuView.circleButton?.distance = 105
        
        //Delay between show buttons
        popMenuView.circleButton?.showDelay = 0.0
        
        //Animation Duration
        popMenuView.circleButton?.duration = 1
        
        guard let button = popMenuView.circleButton else {return}
        button.layer.cornerRadius = button.bounds.size.width / 2.0
    }

    func circleMenu(circleMenu: CircleMenu, willDisplay button: CircleMenuButton, atIndex: Int) {
        //set color
        button.backgroundColor = UIColor.lightGray
        button.setImage(UIImage(named: items[atIndex].icon), for: .normal)
        button.layer.borderWidth = 5.0
        button.layer.borderColor = UIColor.white.cgColor
        
        // set highlited image
        let highlightedImage  = UIImage(named: items[atIndex].icon)?.withRenderingMode(.alwaysTemplate)
        button.setImage(highlightedImage, for: .highlighted)
        button.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        
        //set text
        button.setTitle(items[atIndex].text, for: .normal)
        
    }
    
    func circleMenu(circleMenu: CircleMenu, buttonWillSelected button: CircleMenuButton, atIndex: Int) {
        print("button!!!!! will selected: \(atIndex)")
    }
    
    func circleMenu(circleMenu: CircleMenu, buttonDidSelected button: CircleMenuButton, atIndex: Int) {
        print("button!!!!! did selected: \(atIndex)")
    }


}

