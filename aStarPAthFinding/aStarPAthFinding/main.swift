//
//  main.swift
//  aStarPAthFinding
//
//  Created by parvana on 20.10.25.
//
import Foundation

// MARK: - GraphNode
class GraphNode: Hashable {
    let id: Int
    let x: Int
    let y: Int
    var gCost: Double = Double.infinity
    var parent: GraphNode?

    init(id: Int, x: Int, y: Int) {
        self.id = id
        self.x = x
        self.y = y
    }

    static func == (lhs: GraphNode, rhs: GraphNode) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Heuristics
func hZero(a: GraphNode, b: GraphNode) -> Double { return 0 }

func hEuclidean(a: GraphNode, b: GraphNode) -> Double {
    let dx = Double(a.x - b.x)
    let dy = Double(a.y - b.y)
    return sqrt(dx*dx + dy*dy)
}

func hManhattan(a: GraphNode, b: GraphNode) -> Double {
    return Double(abs(a.x - b.x) + abs(a.y - b.y))
}

// MARK: - A* algorithm
func astar(graph: Graph, heuristic: (GraphNode, GraphNode) -> Double) -> (path: [Int]?, cost: Double, expanded: Int) {

    let nodes: [Int: GraphNode] = Dictionary(uniqueKeysWithValues:
        graph.vertices.map { (id, vertex) in
            (id, GraphNode(id: id, x: vertex.cellId / 10, y: vertex.cellId % 10))
        }
    )

    guard let start = nodes[graph.source], let goal = nodes[graph.destination] else {
        return (nil, 0, 0)
    }

    var openSet = Set<GraphNode>([start])
    var gScore: [GraphNode: Double] = [start: 0]
    var parentMap: [GraphNode: GraphNode] = [:]
    var expanded = 0

    while !openSet.isEmpty {
        let current = openSet.min { (gScore[$0] ?? Double.infinity + heuristic($0, goal)) <
                                   (gScore[$1] ?? Double.infinity + heuristic($1, goal)) }!
        if current == goal {
            var path: [Int] = [current.id]
            var node: GraphNode? = current
            while let p = parentMap[node!] {
                path.append(p.id)
                node = p
            }
            return (path.reversed(), gScore[current]!, expanded)
        }

        openSet.remove(current)
        expanded += 1

        for (neighborId, weight) in graph.edges[current.id]! {
            let neighbor = nodes[neighborId]!
            let tentativeG = (gScore[current] ?? Double.infinity) + weight
            if tentativeG < (gScore[neighbor] ?? Double.infinity) {
                parentMap[neighbor] = current
                gScore[neighbor] = tentativeG
                openSet.insert(neighbor)
            }
        }
    }

    return (nil, Double.infinity, expanded)
}

// MARK: - Run A* in three modes
if let graph = GraphParser.parseFile("astar_small.txt") {

    let modes: [(String, (GraphNode, GraphNode) -> Double)] = [
        ("UCS", hZero),
        ("A* Euclidean", hEuclidean),
        ("A* Manhattan", hManhattan)
    ]

    for (modeName, heuristicFunc) in modes {
        let startTime = CFAbsoluteTimeGetCurrent()
        let result = astar(graph: graph, heuristic: heuristicFunc)
        let runtime = CFAbsoluteTimeGetCurrent() - startTime

        print("MODE: \(modeName)")
        if let path = result.path {
            print("Optimal cost: \(result.cost)")
            print("Path: \(path.map { String($0) }.joined(separator: " -> "))")
        } else {
            print("Optimal cost: NO PATH")
        }
        print("Expanded: \(result.expanded)")
        print("Runtime (s): \(String(format: "%.6f", runtime))")
        print("---------------------------")
    }

} else {
    print("❌ Failed to parse graph.")
}

