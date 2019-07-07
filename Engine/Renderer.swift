//
//  Renderer.swift
//  RetroRampage
//
//  Created by Petr Chmelar on 07/07/2019.
//  Copyright © 2019 Matee s.r.o. All rights reserved.
//

public struct Renderer {
    public private(set) var bitmap: Bitmap
    
    public init(width: Int, height: Int) {
        self.bitmap = Bitmap(width: width, height: height, color: .white)
    }
}

public extension Renderer {
    mutating func draw(_ world: World) {
        // Get relative scale between world units and pixels
        let scale = Double(bitmap.height) / world.size.y
        
        // Draw player
        var rect = world.player.rect
        rect.min *= scale
        rect.max *= scale
        bitmap.fill(rect: rect, color: .blue)
    }
}
