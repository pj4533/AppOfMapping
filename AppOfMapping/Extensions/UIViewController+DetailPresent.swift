//
//  UIViewController+DetailPresent.swift
//  Slaad
//
//  Created by PJ Gray on 5/4/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 1
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        present(viewControllerToPresent, animated: false)
    }
    
    func dismissDetail() {
        let transition = CATransition()
        transition.duration = 1
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false)
    }
}
