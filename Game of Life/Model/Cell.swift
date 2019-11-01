//
//  Cell.swift
//  Game of Life
//
//  Created by Lucas Fernandez Nicolau on 31/10/19.
//  Copyright © 2019 {lfn}. All rights reserved.
//

import SceneKit

class Cell: SCNNode {
    var state: CellState = .dead
    
    init(withSize size: CGFloat = 1) {
        super.init()
        self.geometry = SCNBox(width: size, height: size, length: size, chamferRadius: 0)
        geometry?.firstMaterial?.emission.contents = UIColor.deadCell
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeState() {
        guard let geometry = self.geometry,
            let material = geometry.firstMaterial else { return }
        
        switch state {
        case .alive:
            state = .dead
            material.emission.contents = UIColor.deadCell
            
        case .dead:
            state = .alive
            material.emission.contents = UIColor.aliveCell
        default:
            break
        }
    }
    
    func setState(to state: CellState) {
        self.state = state
        switch state {
        case .alive:
            geometry?.firstMaterial?.emission.contents = UIColor.aliveCell
        case .dead:
            geometry?.firstMaterial?.emission.contents = UIColor.deadCell
        default:
            break
        }
    }
    
    func newState(basedOn cells: [[Cell]]) -> CellState {
        let neighbours = self.getNeighbours(on: cells)
        let alives = neighbours.filter { (cell) -> Bool in
            cell.state == .alive
        }
        
        if self.state == .alive {
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
    
    func getNeighbours(on cells: [[Cell]]) -> [Cell] {
        let (i, j) = self.findIndex(on: cells)
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
    
    func findIndex(on cells: [[Cell]]) -> (Int, Int) {
        for i in 0 ..< cells.count {
            for j in 0 ..< cells[i].count {
                if self == cells[i][j] {
                    return (i, j)
                }
            }
        }
        return (-1, -1)
    }
}
