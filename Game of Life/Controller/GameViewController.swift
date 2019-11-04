//
//  GameViewController.swift
//  Game of Life
//
//  Created by Lucas Fernandez Nicolau on 31/10/19.
//  Copyright © 2019 {lfn}. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import Foundation

enum Challenge: Int {
    case bronze = 0
    case prata
    case ouro
}

var challenge: Challenge = .bronze

class GameViewController: UIViewController {

    var scene: WorldScene?
    var playButton: UIBarButtonItem!
    var pauseButton: UIBarButtonItem!
    @IBOutlet weak var restartButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(playPause(_:)))
        playButton.tintColor = .aliveCell
        navigationItem.rightBarButtonItem = playButton
        pauseButton = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(playPause(_:)))
        pauseButton.tintColor = .aliveCell
        pauseButton.tag = 1
        
        guard let scnView = self.view as? SCNView else { return }
        
        scene = WorldScene()
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        scnView.defaultCameraController.inertiaEnabled = true
        scnView.defaultCameraController.maximumVerticalAngle = 89
        scnView.defaultCameraController.minimumVerticalAngle = -89
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
    }
    
    @objc func playPause(_ sender: UIBarButtonItem) {
        if sender.tag == 0 {
            navigationItem.rightBarButtonItem = pauseButton
            scene?.initGeneration()
        } else {
            navigationItem.rightBarButtonItem = playButton
            scene?.pause()
        }
    }
    
    @IBAction func restart() {
        navigationItem.rightBarButtonItem = playButton
        scene?.restart()
    }
    
    @objc func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        guard let scnView = self.view as? SCNView else { return }
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            let result = hitResults[0]
            guard let cell = result.node as? Cell else { return }
            cell.changeState()
        }
    }
    
    @IBAction func challengeChanged(_ sender: UISegmentedControl) {
        challenge = Challenge(rawValue: sender.selectedSegmentIndex) ?? .bronze
        restart()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

}
