//
//  Utility.swift
//  CircleMenu
//
//  Created by 刘业臻 on 16/6/25.
//  Copyright © 2016年 Alex K. All rights reserved.
//

import Foundation
import UIKit

extension CGPoint {
    func distanceTo(pointB: CGPoint) -> CGFloat {
        let diffX = self.x - pointB.x
        let diffY = self.y - pointB.y

        return CGFloat(hypotf(Float(diffX), Float(diffY)))
    }
}

internal extension Float {
    var radians: Float {
        return self * (Float(180) / Float(Double.pi))
    }

    var degrees: Float {
        return self  * Float(Double.pi) / 180.0
    }
}

internal extension UIView {

    var angleZ: Float {
        let radians: Float = atan2(Float(self.transform.b), Float(self.transform.a))
        return radians.radians
    }
}
