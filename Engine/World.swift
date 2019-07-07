//
//  World.swift
//  RetroRampage
//
//  Created by Petr Chmelar on 07/07/2019.
//  Copyright © 2019 Matee s.r.o. All rights reserved.
//

public struct World {
    public let size: Vector
    public var player: Player
    
    public init() {
        self.size = Vector(x: 8, y: 8)
        self.player = Player(position: Vector(x: 4, y: 4))
    }
}

public extension World {
    mutating func update(timeStep: Double) {
        player.position += player.velocity * timeStep // Move at 1 FPS
        player.position.x.formTruncatingRemainder(dividingBy: 8)
        player.position.y.formTruncatingRemainder(dividingBy: 8)
    }
}
