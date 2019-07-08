//
//  Player.swift
//  RetroRampage
//
//  Created by Petr Chmelar on 07/07/2019.
//  Copyright © 2019 Matee s.r.o. All rights reserved.
//

public struct Player {
    public let radius: Double = 0.25
    public var position: Vector
    public var velocity: Vector
    public let speed: Double = 2
    public var direction: Vector
    
    public init(position: Vector) {
        self.position = position
        self.velocity = Vector(x: 0, y: 0)
        self.direction = Vector(x: 1, y: 0)
    }
}

public extension Player {
    // Bounding rect for player
    var rect: Rect {
        let halfSize = Vector(x: radius, y: radius)
        return Rect(min: position - halfSize, max: position + halfSize)
    }
    
    // Detect if the player is colliding with a wall
    // Returns vector of intersection to enable collision response
    func intersection(with map: Tilemap) -> Vector? {
        for y in Int(rect.min.y) ... Int(rect.max.y) {
            for x in Int(rect.min.x) ... Int(rect.max.x) where map[x,y].isWall {
                let wallRect = Rect(
                    min: Vector(x: Double(x), y: Double(y)),
                    max: Vector(x: Double(x+1), y: Double(y+1))
                )
                if let intersection = rect.intersection(with: wallRect) {
                    return intersection
                }
            }
        }
        return nil
    }
}
