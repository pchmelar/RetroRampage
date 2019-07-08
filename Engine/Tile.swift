//
//  Tile.swift
//  RetroRampage
//
//  Created by Petr Chmelar on 08/07/2019.
//  Copyright © 2019 Matee s.r.o. All rights reserved.
//

public enum Tile: Int, Decodable {
    case floor
    case wall
}

public extension Tile {
    var isWall: Bool {
        switch self {
        case .wall:
            return true
        default:
            return false
        }
    }
}
