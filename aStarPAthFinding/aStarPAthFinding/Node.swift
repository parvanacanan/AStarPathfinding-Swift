//
//  Node.swift
//  aStarPAthFinding
//
//  Created by parvana on 20.10.25.
//

import Foundation

class Node: Equatable, Hashable {
    let x: Int
    let y: Int
    var gCost: Int = 0
    var hCost: Int = 0
    var parent: Node?

    var fCost: Int {
        return gCost + hCost
    }

    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    // Equatable protokolu üçün
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }

    // Hashable protokolu üçün
    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

