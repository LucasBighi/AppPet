//
//  SegmentedControl+Extension.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 25/10/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import Foundation
import UIKit

extension UISegmentedControl {
    
    func selectedSegmentTitle() -> String {
        let index = self.selectedSegmentIndex
        if let title = self.titleForSegment(at: index) {
            return title
        }
        return ""
    }
    
    func selectSegment(with title: String) {
        for segment in 0..<self.numberOfSegments {
            if self.titleForSegment(at: segment) == title {
                self.selectedSegmentIndex = segment
            }
        }
    }
}
