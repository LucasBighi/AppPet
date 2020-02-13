//
//  String+Extension.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 11/10/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//
import Foundation

extension String {
    func isEmailValid() -> Bool {
        if self.contains("@"), self.contains(".") {
            return true
        }
        return false
    }
    
    func isNameValid() -> Bool {
        if self.contains(" ") {
            return true
        }
        return false
    }
}

