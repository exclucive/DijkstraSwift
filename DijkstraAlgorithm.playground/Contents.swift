//: Playground - noun: a place where people can play

import UIKit

class Vertex<T: Hashable>: Hashable {
    let value: T
    let index: Int
    var visited: Bool = false
    var edges: [Edge<T>] = []
    var totalWeight: Double = Double.infinity
    var pathFromStartpoint:[Vertex<T>] = []
    
    init(value: T, index: Int) {
        self.value = value
        self.index = index
    }

    var hashValue: Int {
        return value.hashValue
    }
    
    static func == (lhs: Vertex<T>, rhs: Vertex<T>) -> Bool {
        return lhs.index == rhs.index
    }
}

extension Vertex: CustomStringConvertible {
    var description: String {
        return "Vertex: \(value): \(index)"
    }
}

class Edge <T: Hashable> {
    var weight: Double?
    let destination: Vertex<T>
    
    init(destination: Vertex<T>, weight: Double = Double.infinity) {
        self.destination = destination
        self.weight = weight
    }
}

class Graph<T: Hashable> {
    typealias Node = Vertex<T>
    typealias Connection = Edge<T>
    
    var nodes: [Node] = [] 
    let directed: Bool
    
    init(directed: Bool) {
        self.directed = directed
    }
    
    private func clearCachedValues() {
        for node in nodes {
            node.pathFromStartpoint.removeAll()
            node.totalWeight = Double.infinity
            node.visited = false
        }
    }
    
    func addNewNode(_ value: T) -> Node {
        let newNode = Node(value: value, index: nodes.count)
        nodes.append(newNode)
        return newNode
    }
    
    func addEdge(from: Node, to: Node, weight: Double = Double.infinity) {
        let newNeighbor = Connection(destination: to)
        newNeighbor.weight = weight
        from.edges.append(newNeighbor)
        
        //
        if directed == false {
            let newNeighbor = Connection(destination: from)
            newNeighbor.weight = weight
            to.edges.append(newNeighbor)
        }
    }
    
    func dijkstra(node: Node) {
        clearCachedValues()
        
        var nextNode:Node? = node
        node.totalWeight = 0
        node.pathFromStartpoint.append(node)
        
        var restNodes:[Node] = nodes
        
        while let currentNode = nextNode {
            currentNode.visited = true
            
            guard let index = restNodes.index(of: currentNode) else {
                break
            }
            restNodes.remove(at: index)
            
            for edge in currentNode.edges where edge.destination.visited == false {
                let neighbor = edge.destination
                let weight = edge.weight! + currentNode.totalWeight
                if weight < neighbor.totalWeight {
                    neighbor.totalWeight = weight
                    neighbor.pathFromStartpoint = currentNode.pathFromStartpoint
                    neighbor.pathFromStartpoint.append(neighbor)
                }
            }
            
            if restNodes.isEmpty {
                break
            }
            
            nextNode  = restNodes.min { v1, v2 in v1.totalWeight < v2.totalWeight }
        }
    }
    
    func findPath(from: Node, to: Node) -> String {
        dijkstra(node: from)
        
        var resultStr = "\(to.totalWeight): "
        for node in to.pathFromStartpoint {
            resultStr += "\(node.value), "
        }
        
        resultStr = String(resultStr.dropLast(2))
        
        return resultStr
    }
}

extension Graph: CustomStringConvertible {
    var description: String {
        var resultStr = ""
        
        for node in nodes {
            resultStr += "\(node.value): "
            
            for edge in node.edges {
                let v = edge.destination.visited ? "(T)" : "(F)"
                resultStr += "\(edge.destination.value)" + v + ", "
            }
        
            resultStr = String(resultStr.dropLast(2)) + "\n"
        }
        
        return resultStr
    }
}


let graph = Graph<String>(directed: false)

let sanFrancisco = graph.addNewNode("San Francisco")
let losAngeles = graph.addNewNode("Los Angeles")
let sanDiego = graph.addNewNode("San Diego")
let lasVegas = graph.addNewNode("Las Vegas")

graph.addEdge(from: sanFrancisco, to: losAngeles, weight: 400)
graph.addEdge(from: sanFrancisco, to: sanDiego, weight: 600)
graph.addEdge(from: sanFrancisco, to: lasVegas, weight: 900)

graph.addEdge(from: losAngeles, to: sanDiego, weight: 150)
graph.addEdge(from: losAngeles, to: lasVegas, weight: 500)

graph.addEdge(from: sanDiego, to: lasVegas, weight: 650)

let result = graph.findPath(from: sanFrancisco, to: sanDiego)
print(result)

