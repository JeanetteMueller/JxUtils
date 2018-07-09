//
//  String+Localized.swift
//  ProjectPhoenix
//
//  Created by Jeanette Müller on 08.11.16.
//  Copyright © 2016 Jeanette Müller. All rights reserved.
//

import Foundation


extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}


