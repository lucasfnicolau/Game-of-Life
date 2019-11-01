//
//  WorldScene.swift
//  Game of Life
//
//  Created by Lucas Fernandez Nicolau on 31/10/19.
//  Copyright © 2019 {lfn}. All rights reserved.
//

import SceneKit

class WorldScene: SCNScene {
    var cells = [[Cell]]()
    var nextGeneration = [[CellState]]()
    var gridSize = 0
    var timer: Timer?
    
    init(gridSize size: Int = 11) {
        super.init()
        setCamera()
        setLight()
        createGrid(withSize: size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Could not instantiate")
    }
    
    func setCamera() {
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.name = "camera"
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: 5, y: 4, z: 25.0)
        rootNode.addChildNode(cameraNode)
    }
    
    func setLight() {
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x: 5, y: 5, z: -5)
        rootNode.addChildNode(lightNode)
    }
    
    func createGrid(withSize size: Int) {
        gridSize = size
        
        let half = Int(size / 2)
        var centerCell = Cell()
        
        for i in 0 ..< size {
            cells.append([])
            for j in 0 ..< size {
                let cell = Cell()
                cell.position = SCNVector3(Double(i) * 1.15, Double(j) * 1.15, 0)
                self.rootNode.addChildNode(cell)
                
                if i == half && j == half {
                    centerCell = cell
                }
                
                cells[i].append(cell)
            }
        }
        centerCamera(basedOn: centerCell)
    }
    
    func centerCamera(basedOn node: SCNNode) {
        let constraint = SCNLookAtConstraint(target: node)
        constraint.isGimbalLockEnabled = true
        guard let cameraNode = rootNode.childNode(withName: "camera", recursively: true) else { return }
        cameraNode.constraints = [constraint]
    }
    
    func initGeneration() {
        timer = Timer.scheduledTimer(timeInterval: 0.20, target: self, selector: #selector(initNewGeneration), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    @objc func initNewGeneration() {
        nextGeneration = []
        for i in 0 ..< gridSize {
            nextGeneration.append([])
            for j in 0 ..< gridSize {
                nextGeneration[i].append(cells[i][j].newState(basedOn: cells))
            }
        }
        
        updateCells()
    }
    
    func updateCells() {
        for i in 0 ..< gridSize {
            for j in 0 ..< gridSize {
                cells[i][j].setState(to: nextGeneration[i][j])
            }
        }
    }
    
    func pause() {
        timer?.invalidate()
    }
    
    func restart() {
        timer?.invalidate()
        for i in 0 ..< gridSize {
            for j in 0 ..< gridSize {
                cells[i][j].setState(to: .dead)
            }
        }
    }
}
