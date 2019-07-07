//
//  Player.swift
//  RetroRampage
//
//  Created by Petr Chmelar on 07/07/2019.
//  Copyright © 2019 Matee s.r.o. All rights reserved.
//

public struct Player {
    public let radius: Double = 0.5
    public var position: Vector
    public var velocity: Vector
    
    public init(position: Vector) {
        self.position = position
        self.velocity = Vector(x: 1, y: 1)
    }
}

public extension Player {
    // Bounding rect for player
    var rect: Rect {
        let halfSize = Vector(x: radius, y: radius)
        return Rect(min: position - halfSize, max: position + halfSize)
    }
}
