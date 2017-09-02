//
//  AudioPlayerVideo.swift
//  ProjectPhoenix
//
//  Created by Jeanette Müller on 15.01.17.
//  Copyright © 2017 Jeanette Müller. All rights reserved.
//

import Foundation
import AVFoundation

extension AudioPlayer {
    
    func getVideoLayer() -> AVPlayerLayer? {
        
        if let a = self.currentItem{
            let audioItem = a as! PCAudioItem
            
            if audioItem.episode.video{
                if let p = self.player{
                    let avPlayerLayer = AVPlayerLayer(player: p)
                    avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspect
                    
                    return avPlayerLayer
                }
            }
        }
        return nil
    }
    
}
