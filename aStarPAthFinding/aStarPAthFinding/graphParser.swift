//
//  graphParser.swift
//  aStarPAthFinding
//
//  Created by parvana on 20.10.25.
//
import Foundation

struct Edge {
    let u: Int
    let v: Int
    let w: Double
}

struct Vertex {
    let id: Int
    let cellId: Int
}

class Graph {
    var vertices: [Int: Vertex] = [:]
    var edges: [Int: [(Int, Double)]] = [:]
    var source: Int = -1
    var destination: Int = -1

    func addVertex(id: Int, cellId: Int) {
        vertices[id] = Vertex(id: id, cellId: cellId)
        edges[id] = []
    }

    func addEdge(u: Int, v: Int, w: Double) {
        edges[u]?.append((v, w))
        edges[v]?.append((u, w)) // undirected
    }
}

class GraphParser {
    static func parseFile(_ path: String) -> Graph? {
        let graph = Graph()

        guard let content = try? String(contentsOfFile: path) else {
            print("❌ Could not read file.")
            return nil
        }

        for line in content.split(separator: "\n") {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if trimmed.isEmpty || trimmed.hasPrefix("#") { continue }

            if trimmed.hasPrefix("S,") {
                if let id = Int(trimmed.split(separator: ",")[1]) {
                    graph.source = id
                }
            } else if trimmed.hasPrefix("D,") {
                if let id = Int(trimmed.split(separator: ",")[1]) {
                    graph.destination = id
                }
            } else if trimmed.contains(",") {
                let parts = trimmed.split(separator: ",")
                if parts.count == 2, let id = Int(parts[0]), let cell = Int(parts[1]) {
                    graph.addVertex(id: id, cellId: cell)
                } else if parts.count == 3,
                          let u = Int(parts[0]),
                          let v = Int(parts[1]),
                          let w = Double(parts[2]) {
                    graph.addEdge(u: u, v: v, w: w)
                }
            }
        }

        return graph
    }
}

