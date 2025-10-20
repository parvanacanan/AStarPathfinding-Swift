//
//  aStar.swift
//  aStarPAthFinding
//
//  Created by parvana on 20.10.25.
//
import Foundation

class AStar {
    let grid: Grid

    init(grid: Grid) {
        self.grid = grid
    }

    func heuristic(_ a: Node, _ b: Node) -> Int {
        // Manhattan distance
        return abs(a.x - b.x) + abs(a.y - b.y)
    }

    func findPath(start: Node, goal: Node) -> [Node]? {
        var openSet: Set<Node> = [start]
        var cameFrom: [Node: Node] = [:]
        var gScore: [Node: Int] = [start: 0]
        var fScore: [Node: Int] = [start: heuristic(start, goal)]

        while !openSet.isEmpty {
            // ən kiçik fCost dəyəri olan node-u tapırıq
            guard let current = openSet.min(by: { (fScore[$0] ?? Int.max) < (fScore[$1] ?? Int.max) }) else {
                break
            }

            if current == goal {
                return reconstructPath(cameFrom: cameFrom, current: current)
            }

            openSet.remove(current)

            for neighbor in grid.neighbors(of: current) {
                let tentativeGScore = (gScore[current] ?? Int.max) + 1

                if tentativeGScore < (gScore[neighbor] ?? Int.max) {
                    cameFrom[neighbor] = current
                    gScore[neighbor] = tentativeGScore
                    fScore[neighbor] = tentativeGScore + heuristic(neighbor, goal)
                    openSet.insert(neighbor)
                }
            }
        }

        return nil
    }

    private func reconstructPath(cameFrom: [Node: Node], current: Node) -> [Node] {
        var totalPath = [current]
        var currentNode = current

        while let parent = cameFrom[currentNode] {
            totalPath.append(parent)
            currentNode = parent
        }

        return totalPath.reversed()
    }
}

