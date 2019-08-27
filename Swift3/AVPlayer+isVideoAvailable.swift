//
//  AVPlayer+isVideoAvailable.swift
//  Podcat 2
//
//  Created by Jeanette Müller on 23.07.19.
//  Copyright © 2019 Jeanette Müller. All rights reserved.
//

import Foundation

extension AVPlayer {
    var isAudioAvailable: Bool? {
        return self.currentItem?.asset.tracks.filter({$0.mediaType == AVMediaType.audio}).count != 0
    }

    var isVideoAvailable: Bool? {
        return self.currentItem?.asset.tracks.filter({$0.mediaType == AVMediaType.video}).count != 0
    }
}
