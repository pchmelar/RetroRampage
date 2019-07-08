//
//  Renderer.swift
//  RetroRampage
//
//  Created by Petr Chmelar on 07/07/2019.
//  Copyright © 2019 Matee s.r.o. All rights reserved.
//

public struct Renderer {
    public private(set) var bitmap: Bitmap
    
    public init(width: Int, height: Int) {
        self.bitmap = Bitmap(width: width, height: height, color: .black)
    }
}

public extension Renderer {
    mutating func draw(_ world: World) {
        // Calculate player's view plane
        let focalLength = 1.0
        let viewWidth = Double(bitmap.width) / Double(bitmap.height)
        let viewPlane = world.player.direction.orthogonal * viewWidth
        let viewCenter = world.player.position + world.player.direction * focalLength
        let viewStart = viewCenter - viewPlane / 2
        
        // Calculate player's line of sight as fan of rays
        let columns = bitmap.width
        let step = viewPlane / Double(columns)
        var columnPosition = viewStart
        for x in 0 ..< columns {
            let rayDirection = columnPosition - world.player.position
            let viewPlaneDistance = rayDirection.length
            let ray = Ray(
                origin: world.player.position,
                direction: rayDirection / viewPlaneDistance
            )
            let end = world.map.hitTest(ray)
            
            // Lighting (gray color for north/south walls)
            let wallColor: Color
            if end.x.rounded(.down) == end.x {
                wallColor = .white
            } else {
                wallColor = .gray
            }
            
            // Draw wall
            let wallDistance = (end - ray.origin).length
            let wallHeight = 1.0
            
            let distanceRatio = viewPlaneDistance / focalLength
            let perpendicular = wallDistance / distanceRatio
            let height = wallHeight * focalLength / perpendicular * Double(bitmap.height)
            
            bitmap.drawLine(
                from: Vector(x: Double(x), y: (Double(bitmap.height) - height) / 2),
                to: Vector(x: Double(x), y: (Double(bitmap.height) + height) / 2),
                color: wallColor
            )
            
            columnPosition += step
        }
    }
}
