//
//  Ray.swift
//  RetroRampage
//
//  Created by Petr Chmelar on 08/07/2019.
//  Copyright © 2019 Matee s.r.o. All rights reserved.
//

public struct Ray {
    public var origin: Vector
    public var direction: Vector
    
    public init(origin: Vector, direction: Vector) {
        self.origin = origin
        self.direction = direction
    }
}
