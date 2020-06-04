//
// Created by Frank Jia on 2020-04-24.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation
import SwiftUI

extension Array {
    func showDividerAfter(index: Int) -> Bool {
        return index < self.count - 1
    }
}
extension UIApplication {
    // https://stackoverflow.com/questions/57063142/swiftui-status-bar-color
    class func setStatusBarStyle(_ style: UIStatusBarStyle) {
        if let vc = UIApplication.getKeyWindow()?.rootViewController as? ContentHostingController {
            vc.changeStatusBarStyle(style)
        }
    }
    private class func getKeyWindow() -> UIWindow? {
        return UIApplication.shared.windows.first{ $0.isKeyWindow }
    }
}
