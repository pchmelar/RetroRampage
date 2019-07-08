//
//  Tilemap.swift
//  RetroRampage
//
//  Created by Petr Chmelar on 08/07/2019.
//  Copyright © 2019 Matee s.r.o. All rights reserved.
//

public struct Tilemap: Decodable {
    private let tiles: [Tile]
    public let things: [Thing]
    public let width: Int
}

public extension Tilemap {
    var height: Int {
        return tiles.count / width
    }
    
    var size: Vector {
        return Vector(x: Double(width), y: Double(height))
    }
    
    subscript(x: Int, y: Int) -> Tile {
        return tiles[y * width + x]
    }
    
    // Collision point is on the boundary between two or four tiles
    // Determine which tile at collision point we need to check
    func tile(at position: Vector, from direction: Vector) -> Tile {
        var offsetX = 0
        var offsetY = 0
        
        if position.x.rounded(.down) == position.x {
            offsetX = direction.x > 0 ? 0 : -1
        }
        if position.y.rounded(.down) == position.y {
            offsetY = direction.y > 0 ? 0 : -1
        }
        return self[Int(position.x) + offsetX, Int(position.y) + offsetY]
    }
    
    // Test whether the line of sight ray hits the wall
    // Returns vector indicating the point at which the ray should terminate
    func hitTest(_ ray: Ray) -> Vector {
        
        var position = ray.origin
        let slope = ray.direction.x / ray.direction.y
        
        repeat {
            let edgeDistanceX: Double
            let edgeDistanceY: Double
            
            if ray.direction.x > 0 {
                edgeDistanceX = position.x.rounded(.down) + 1 - position.x
            } else {
                edgeDistanceX = position.x.rounded(.up) - 1 - position.x
            }
            
            if ray.direction.y > 0 {
                edgeDistanceY = position.y.rounded(.down) + 1 - position.y
            } else {
                edgeDistanceY = position.y.rounded(.up) - 1 - position.y
            }
            
            // Compute distance to intersection points
            let step1 = Vector(x: edgeDistanceX, y: edgeDistanceX / slope)
            let step2 = Vector(x: edgeDistanceY * slope, y: edgeDistanceY)
            
            // Compute the position at which the ray would exit the current tile
            if step1.length < step2.length {
                position += step1
            } else {
                position += step2
            }
        } while tile(at: position, from: ray.direction).isWall == false
        return position
    }
}
