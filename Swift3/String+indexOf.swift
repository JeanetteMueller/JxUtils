//
//  String+indexOf.swift
//  Podcat 2
//
//  Created by Jeanette Müller on 15.05.19.
//  Copyright © 2019 Jeanette Müller. All rights reserved.
//

import Foundation


extension String {
    func indexOf(char: Character) -> Int? {
        return firstIndex(of: char)?.utf16Offset(in: self)
    }
}
