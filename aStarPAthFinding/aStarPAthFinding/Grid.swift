import Foundation

class Grid {
    var width: Int
    var height: Int
    var nodes: [[Node]]

    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        self.nodes = []

        for x in 0..<width {
            var row: [Node] = []
            for y in 0..<height {
                row.append(Node(x: x, y: y))
            }
            nodes.append(row)
        }
    }

    func nodeAt(x: Int, y: Int) -> Node? {
        guard x >= 0 && y >= 0 && x < width && y < height else {
            return nil
        }
        return nodes[x][y]
    }

    func neighbors(of node: Node) -> [Node] {
        var result: [Node] = []
        let directions = [
            (1, 0), (-1, 0),
            (0, 1), (0, -1)
        ]

        for (dx, dy) in directions {
            if let neighbor = nodeAt(x: node.x + dx, y: node.y + dy) {
                result.append(neighbor)
            }
        }
        return result
    }
}

