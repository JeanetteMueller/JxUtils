//
//  SystemSoundID+playFile.swift
//  Podcat 2
//
//  Created by Jeanette Müller on 07.07.17.
//  Copyright © 2017 Jeanette Müller. All rights reserved.
//

import AudioToolbox

extension SystemSoundID {
    static func playFileNamed(_ fileName: String, withExtenstion fileExtension: String) {
        var sound: SystemSoundID = 0
        if let soundURL = Bundle.main.url(forResource: fileName, withExtension: fileExtension) {
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &sound)
            AudioServicesPlaySystemSound(sound)
        }
    }
}
