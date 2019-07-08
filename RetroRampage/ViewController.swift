//
//  ViewController.swift
//  RetroRampage
//
//  Created by Petr Chmelar on 07/07/2019.
//  Copyright © 2019 Matee s.r.o. All rights reserved.
//

import UIKit
import Engine

private let joystickRadius: Double = 40

class ViewController: UIViewController {
    
    private let imageView = UIImageView()
    private var displayLink: CADisplayLink!
    
    private var world = World(map: loadMap())
    private var lastFrameTime = CACurrentMediaTime()
    private let maximumTimeStep: Double = 1 / 20 // View is updated at 20 FPS max
    private let worldTimeStep: Double = 1 / 120 // World is updated at 120 FPS
    
    // Floating joystick
    private let panGesture = UIPanGestureRecognizer()
    private var inputVector: Vector {
        switch panGesture.state {
        case .began, .changed:
            let translation = panGesture.translation(in: view)
            
            // Normalize the input velocity
            var vector = Vector(x: Double(translation.x), y: Double(translation.y))
            vector /= max(joystickRadius, vector.length)
            panGesture.setTranslation(CGPoint(
                x: vector.x * joystickRadius,
                y: vector.y * joystickRadius
            ), in: view)
            return vector
        default:
            return Vector(x: 0, y: 0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupImageView()
        view.addGestureRecognizer(panGesture)
        
        // Start the game loop (timer with refresh rate period)
        displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink.add(to: .main, forMode: .common)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        displayLink.invalidate()
    }
    
    private func setupImageView() {
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        
        // Upscale using nearest-neighbor instead of bilinear filtering
        imageView.layer.magnificationFilter = .nearest
    }
    
    @objc func update(_ displayLink: CADisplayLink) {
        
        // Equal to 1 FPS, maximum 20 FPS to prevent bugs
        let timeStep = min(maximumTimeStep, displayLink.timestamp - lastFrameTime)
        
        // Handle input (Y axis for speed and X axis for rotation)
        let rotation = inputVector.x * world.player.turningSpeed * worldTimeStep
        let input = Input(
            speed: -inputVector.y,
            rotation: Rotation(sine: sin(rotation), cosine: cos(rotation))
        )
        
        // Update world
        let worldSteps = (timeStep / worldTimeStep).rounded(.up)
        for _ in 0 ..< Int(worldSteps) {
            world.update(timeStep: timeStep / worldSteps, input: input)
        }
        lastFrameTime = displayLink.timestamp
        
        // Render world
        var renderer = Renderer(
            width: Int(imageView.bounds.width),
            height: Int(imageView.bounds.height)
        )
        renderer.draw(world)
        
        imageView.image = UIImage(bitmap: renderer.bitmap)
    }

}

private func loadMap() -> Tilemap {
    let jsonURL = Bundle.main.url(forResource: "Map", withExtension: "json")!
    let jsonData = try! Data(contentsOf: jsonURL)
    return try! JSONDecoder().decode(Tilemap.self, from: jsonData)
}
