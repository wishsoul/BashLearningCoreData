//
//  NSObject+Name.swift
//  BashLearningCoreData
//
//  Created by xugh22 on 2023/8/18.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
