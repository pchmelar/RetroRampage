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

public extension Rect {
    func intersection(with rect: Rect) -> Vector? {
        let left = Vector(x: max.x - rect.min.x, y: 0)
        if left.x <= 0 {
            return nil
        }
        let right = Vector(x: min.x - rect.max.x, y: 0)
        if right.x >= 0 {
            return nil
        }
        let up = Vector(x: 0, y: max.y - rect.min.y)
        if up.y <= 0 {
            return nil
        }
        let down = Vector(x: 0, y: min.y - rect.max.y)
        if down.y >= 0 {
            return nil
        }
        return [left, right, up, down].sorted(by: { $0.length < $1.length }).first
    }
}
