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

class GameViewController: UIViewController {

    var scene: WorldScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let scnView = self.view as? SCNView else { return }
        
        scene = WorldScene()
        scnView.scene = scene
        
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.name = "camera"
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: 3, y: 25.0, z: 0.0)
        let angle90: CGFloat = .pi / 2
        cameraNode.eulerAngles = SCNVector3(angle90, 10, 10)
        scene?.rootNode.addChildNode(cameraNode)
        
        scene?.createGrid()
        
        setLight()
        
        setButtons()
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
    }
    
    func setButtons() {
        guard let scnView = self.view as? SCNView else { return }
        let playBtn = UIButton(frame: CGRect(x: 20, y: 20, width: 75, height: 75))
        playBtn.setImage(UIImage(named: "play"), for: .normal)
        playBtn.addTarget(self, action: #selector(begin), for: .touchUpInside)
        scnView.addSubview(playBtn)
    }
    
    func setLight() {
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x: 5, y: -5, z: -5)
        scene?.rootNode.addChildNode(lightNode)
    }
    
    @objc func begin() {
        scene?.initGeneration()
    }
    
    @objc func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        guard let scnView = self.view as? SCNView else { return }
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            let result = hitResults[0]
            guard let node = result.node as? Cell else { return }
            let (i, j) = scene?.findIndex(of: node) ?? (0, 0)
            let cell = scene?.cells[i][j]
            cell?.changeState()
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
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
