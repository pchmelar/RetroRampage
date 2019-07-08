//
//  World.swift
//  RetroRampage
//
//  Created by Petr Chmelar on 07/07/2019.
//  Copyright © 2019 Matee s.r.o. All rights reserved.
//

public struct World {
    public let map: Tilemap
    public var player: Player!
    
    public init(map: Tilemap) {
        self.map = map
        
        // Add things
        for y in 0 ..< map.height {
            for x in 0 ..< map.width {
                let position = Vector(x: Double(x) + 0.5, y: Double(y) + 0.5)
                let thing = map.things[y * map.width + x]
                switch thing {
                case .player:
                    self.player = Player(position: position)
                default:
                    break
                }
            }
        }
    }
}

public extension World {
    var size: Vector {
        return map.size
    }
    
    mutating func update(timeStep: Double, input: Input) {
        
        // Set player's direction
        let length = input.velocity.length
        if length > 0 {
            player.direction = input.velocity / length
        }
        
        player.velocity = input.velocity * player.speed
        player.position += player.velocity * timeStep
        while let intersection = player.intersection(with: map) {
            player.position -= intersection
        }
    }
}
