//: Playground - noun: a place where people can play

import UIKit

class Vertex<T: Hashable>: Hashable {
    let value: T
    let index: Int
    var visited: Bool = false
    var edges: [Edge<T>] = []
    
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

    func dijkstra(node: Node) {
        var totalWeights = Array(repeating: Double.infinity, count: nodes.count)
        var pathsVertices = Array(repeating: [], count: nodes.count)
        totalWeights[node.index] = 0
        pathsVertices[node.index].append(node)        
        var currentNode = node
        
        while currentNode != nil && currentNode.visited == false {
            currentNode.visited = true
            
            for edge in currentNode.edges {
                let neighbor = edge.destination
                let weight = edge.weight! + totalWeights[currentNode.index]
                if weight < totalWeights[neighbor.index] {
                    totalWeights[neighbor.index] = weight
                    pathsVertices[neighbor.index] = pathsVertices[currentNode.index]
                    pathsVertices[neighbor.index].append(neighbor)
                }
            }
            
        }
        
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

print(graph)
