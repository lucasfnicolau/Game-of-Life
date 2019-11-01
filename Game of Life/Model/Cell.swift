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
        guard let geometry = self.geometry,
        let material = geometry.firstMaterial else { return }
        material.emission.contents = UIColor.deadCell
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
        guard let geometry = self.geometry,
        let material = geometry.firstMaterial else { return }
        
        self.state = state
        switch state {
        case .alive:
            material.emission.contents = UIColor.aliveCell
        case .dead:
            material.emission.contents = UIColor.deadCell
        default:
            break
        }
    }
}
