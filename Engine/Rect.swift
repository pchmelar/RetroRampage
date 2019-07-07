//
//  Rect.swift
//  RetroRampage
//
//  Created by Petr Chmelar on 07/07/2019.
//  Copyright © 2019 Matee s.r.o. All rights reserved.
//

public struct Rect {
    var min: Vector
    var max: Vector
    
    public init(min: Vector, max: Vector) {
        self.min = min
        self.max = max
    }
}
