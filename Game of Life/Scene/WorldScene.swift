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
    var currentGeneration = [[CellState]]()
    var nextGeneration = [[CellState]]()
    var gridSize = 0
    var timer: Timer?
    
    func createGrid(withSize size: Int = 11) {
        gridSize = size
        
        let half = Int(size / 2)
        var centerCell = Cell()
        
        for i in 0 ..< size {
            cells.append([])
            for j in 0 ..< size {
                let cell = Cell()
                cell.position = SCNVector3(Double(i) * 1.15, 0, Double(j) * 1.15)
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
        timer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(initNewGeneration), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    @objc func initNewGeneration() {
        currentGeneration = []
        for i in 0 ..< gridSize {
            currentGeneration.append([])
            for j in 0 ..< gridSize {
                currentGeneration[i].append(cells[i][j].state)
            }
        }
        
        nextGeneration = []
        for i in 0 ..< gridSize {
            nextGeneration.append([])
            for j in 0 ..< gridSize {
                nextGeneration[i].append(newState(for: cells[i][j]))
            }
        }
        
        updateCells()
    }
    
    func newState(for cell: Cell) -> CellState {
        let neighbours = getNeighbours(of: cell)
        let alives = neighbours.filter { (cell) -> Bool in
            cell.state == .alive
        }
        
        if cell.state == .alive {
            if alives.count < 2 || alives.count >= 4 {
                return .dead
            } else {
                return .alive
            }
        } else {
            if alives.count == 3 {
                return .alive
            } else {
                return .dead
            }
        }
    }
    
    func updateCells() {
        for i in 0 ..< gridSize {
            for j in 0 ..< gridSize {
                cells[i][j].setState(to: nextGeneration[i][j])
            }
        }
    }
    
    func findIndex(of cell: Cell) -> (Int, Int) {
        for i in 0 ..< cells.count {
            for j in 0 ..< cells[i].count {
                if cell == cells[i][j] {
                    return (i, j)
                }
            }
        }
        return (-1, -1)
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
    
    func getNeighbours(of cell: Cell) -> [Cell] {
        let (i, j) = findIndex(of: cell)
        if i == -1 || j == -1 { return [] }
        
        var neighbours = [Cell]()
        
        if i - 1 >= 0 {
            neighbours.append(cells[i - 1][j])
        }
        
        if i + 1 < cells.count {
            neighbours.append(cells[i + 1][j])
        }
        
        if j - 1 >= 0 {
            neighbours.append(cells[i][j - 1])
        }
        
        if j + 1 < cells[i].count {
            neighbours.append(cells[i][j + 1])
        }
        
        if i - 1 >= 0 && j - 1 >= 0 {
            neighbours.append(cells[i - 1][j - 1])
        }
        
        if i + 1 < cells.count && j - 1 >= 0 {
            neighbours.append(cells[i + 1][j - 1])
        }
        
        if i - 1 >= 0 && j + 1 < cells[i].count {
            neighbours.append(cells[i - 1][j + 1])
        }
        
        if i + 1 < cells.count && j + 1 < cells[i].count {
            neighbours.append(cells[i + 1][j + 1])
        }
        
        return neighbours
    }
}
