//
//  Input.swift
//  RetroRampage
//
//  Created by Petr Chmelar on 08/07/2019.
//  Copyright © 2019 Matee s.r.o. All rights reserved.
//

public struct Input {
    public var speed: Double
    public var rotation: Rotation
    
    public init(speed: Double, rotation: Rotation) {
        self.speed = speed
        self.rotation = rotation
    }
}
