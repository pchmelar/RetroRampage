//
//  ViewController.swift
//  RetroRampage
//
//  Created by Petr Chmelar on 07/07/2019.
//  Copyright © 2019 Matee s.r.o. All rights reserved.
//

import UIKit
import Engine

class ViewController: UIViewController {
    
    private let imageView = UIImageView()
    private var displayLink: CADisplayLink!
    
    private var world = World()
    private var lastFrameTime = CACurrentMediaTime()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
        
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
        // Move at 1 FPS
        let timeStep = displayLink.timestamp - lastFrameTime
        world.update(timeStep: timeStep)
        lastFrameTime = displayLink.timestamp
        
        // Render world
        let size = Int(min(imageView.bounds.width, imageView.bounds.height))
        var renderer = Renderer(width: size, height: size)
        renderer.draw(world)
        
        imageView.image = UIImage(bitmap: renderer.bitmap)
    }

}
