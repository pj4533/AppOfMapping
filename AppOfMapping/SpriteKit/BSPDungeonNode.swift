// Tilemap creation originally from https://github.com/TheMechanicX32/BSP-Swift-dungeon-Generator
import UIKit
import SpriteKit
import GameplayKit
import os.log

// A class to help translate generated data into a visual tile map
class BSPDungeonNode: SKNode {
    
    var map : DungeonMap
    var tileMap : SKTileMapNode?
    var graph : GKGridGraph<GKGridGraphNode>?
    
    init(tileSize: CGSize, map: DungeonMap, tileMapAnchorPoint: CGPoint?) {
        self.map = map
        super.init()

        // Initialize a tile map and give it content to build with
        if let tileSet = SKTileSet(named: "Dungeon") {
            self.tileMap = SKTileMapNode(tileSet: tileSet, columns: self.map.columns, rows: self.map.rows, tileSize: tileSize)
            
            if let anchorPoint = tileMapAnchorPoint {
                self.tileMap?.anchorPoint = anchorPoint
            }
            
            guard let tileMap = self.tileMap else { fatalError("Missing tile map for the level") }
            tileMap.zPosition = 2
            let mapAlreadyHasDoors : Bool = self.map.doors.count > 0 ? true : false
            
            var doorUp : SKTileGroup?
            var doorDown : SKTileGroup?
            var doorLeft : SKTileGroup?
            var doorRight : SKTileGroup?
            var stairsUp : SKTileGroup?
            var dotGraphPaper : SKTileGroup?
            var graphPaper : SKTileGroup?
            for tileGroup in tileSet.tileGroups {
                if tileGroup.name == "Door Up" { doorUp = tileGroup }
                if tileGroup.name == "Door Down" { doorDown = tileGroup }
                if tileGroup.name == "Door Left" { doorLeft = tileGroup }
                if tileGroup.name == "Door Right" { doorRight = tileGroup }
                if tileGroup.name == "Stairs Up" { stairsUp = tileGroup }
                if tileGroup.name == "Dot Graph Paper" { dotGraphPaper = tileGroup }
                if tileGroup.name == "Graph Paper" { graphPaper = tileGroup }
            }
            
            // The complicated thing here is that "hallways" overlap "rooms"
            for c in 0..<tileMap.numberOfColumns {
                for r in 0..<tileMap.numberOfRows {
                    
                    var isInHallway = false, isInRoom = false
                    var leftIsRoom = false
                    var rightIsRoom = false
                    var upIsRoom = false
                    var downIsRoom = false
                    var leftIsHall = false
                    var rightIsHall = false
                    var upIsHall = false
                    var downIsHall = false

                    for h in self.map.hallways {
                        // iterate through each hallway and carve it out
                        if h.x1 <= c && h.x2 >= c && h.y1 <= r && h.y2 >= r {
                            isInHallway = true
//                            let tileNode = SKSpriteNode(color: .blue, size: tileSize)
//                            tileNode.blendMode = .multiply
//                            tileNode.position = tileMap.centerOfTile(atColumn: c, row: r)
//                            tileMap.addChild(tileNode)
                            
                            if tileMap.tileGroup(atColumn: c, row: r) == nil {
                                tileMap.setTileGroup(graphPaper, forColumn: c, row: r)
                                let node = SKShapeNode(rect: CGRect(x: 0, y: 0, width: tileMap.tileSize.width, height: tileMap.tileSize.height))
                                node.fillColor = .white
                                node.strokeColor = UIColor(red: 0.0, green: 0.431, blue: 0.827, alpha: 1.0)
                                node.lineWidth = 4.0
                                let center = tileMap.centerOfTile(atColumn: c, row: r)
                                node.position = CGPoint(x: center.x - tileMap.tileSize.width / 2.0, y: center.y - tileMap.tileSize.height / 2.0)
                                self.addChild(node)
                            }
                        }
                        if h.x1 <= (c-1) && h.x2 >= (c-1) && h.y1 <= r && h.y2 >= r {
                            leftIsHall = true
                        }
                        if h.x1 <= (c+1) && h.x2 >= (c+1) && h.y1 <= r && h.y2 >= r {
                            rightIsHall = true
                        }
                        if h.x1 <= c && h.x2 >= c && h.y1 <= (r+1) && h.y2 >= (r+1) {
                            upIsHall = true
                        }
                        if h.x1 <= c && h.x2 >= c && h.y1 <= (r-1) && h.y2 >= (r-1) {
                            downIsHall = true
                        }

                    }

                    for i in self.map.rooms {
                        // iterate through each room and carve it out
                        if i.x1 <= c && i.x2 >= c && i.y1 <= r && i.y2 >= r {
                            isInRoom = true
//                            let tileNode = SKSpriteNode(color: .red, size: tileSize)
//                            tileNode.blendMode = .multiply
//                            tileNode.position = tileMap.centerOfTile(atColumn: c, row: r)
//                            tileMap.addChild(tileNode)
                            
                            if tileMap.tileGroup(atColumn: c, row: r) == nil {
                                tileMap.setTileGroup(graphPaper, forColumn: c, row: r)
                                let node = SKShapeNode(rect: CGRect(x: 0, y: 0, width: tileMap.tileSize.width, height: tileMap.tileSize.height))
                                node.fillColor = .white
                                node.strokeColor = UIColor(red: 0.0, green: 0.431, blue: 0.827, alpha: 1.0)
                                node.lineWidth = 4.0
                                let center = tileMap.centerOfTile(atColumn: c, row: r)
                                node.position = CGPoint(x: center.x - tileMap.tileSize.width / 2.0, y: center.y - tileMap.tileSize.height / 2.0)
                                self.addChild(node)
                            }
                        }
                        
                        if i.x1 <= (c-1) && i.x2 >= (c-1) && i.y1 <= r && i.y2 >= r {
                            leftIsRoom = true
                        }
                        if i.x1 <= (c+1) && i.x2 >= (c+1) && i.y1 <= r && i.y2 >= r {
                            rightIsRoom = true
                        }
                        if i.x1 <= c && i.x2 >= c && i.y1 <= (r+1) && i.y2 >= (r+1) {
                            upIsRoom = true
                        }
                        if i.x1 <= c && i.x2 >= c && i.y1 <= (r-1) && i.y2 >= (r-1) {
                            downIsRoom = true
                        }
                    }
                    
                    // if we are importing, map already has doors so no need to recalculate
                    if !mapAlreadyHasDoors {
                        let leftIsDoor = tileMap.tileGroup(atColumn: c-1, row: r)?.name?.contains("Door") ?? false
                        let rightIsDoor = tileMap.tileGroup(atColumn: c+1, row: r)?.name?.contains("Door") ?? false
                        let upIsDoor = tileMap.tileGroup(atColumn: c, row: r+1)?.name?.contains("Door") ?? false
                        let downIsDoor = tileMap.tileGroup(atColumn: c, row: r-1)?.name?.contains("Door") ?? false
                        let anyDoor = leftIsDoor || rightIsDoor || upIsDoor || downIsDoor
                        if isInHallway && !isInRoom {
                            if upIsRoom {
                                if !leftIsHall && !rightIsHall && !anyDoor && Bool.random() {
                                    tileMap.setTileGroup(doorUp, forColumn: c, row: r)
                                    self.map.doors.append(Door(.up,CGPoint(x: c, y: r)))
                                }
                            } else if downIsRoom {
                                
                                if !leftIsHall && !rightIsHall && !anyDoor && Bool.random() {
                                    tileMap.setTileGroup(doorDown, forColumn: c, row: r)
                                    self.map.doors.append(Door(.down,CGPoint(x: c, y: r)))
                                }
                            } else if leftIsRoom {
                                if !upIsHall && !downIsHall && !anyDoor && Bool.random() {
                                    tileMap.setTileGroup(doorLeft, forColumn: c, row: r)
                                    self.map.doors.append(Door(.left,CGPoint(x: c, y: r)))
                                }
                            } else if rightIsRoom {
                                if !upIsHall && !downIsHall && !anyDoor && Bool.random() {
                                    tileMap.setTileGroup(doorRight, forColumn: c, row: r)
                                    self.map.doors.append(Door(.right,CGPoint(x: c, y: r)))
                                }
                            }
                            
                        }
                    }
                }
            }

            
            for door in self.map.doors {
                if let direction = door.direction, let point = door.point {
                    switch direction {
                    case .up:
                        self.addChild(self.doorUpNode(Int(point.x), Int(point.y)))
                    case .down:
                        self.addChild(self.doorDownNode(Int(point.x), Int(point.y)))
                    case .left:
                        self.addChild(self.doorLeftNode(Int(point.x), Int(point.y)))
                    case .right:
                        self.addChild(self.doorRightNode(Int(point.x), Int(point.y)))
                    }
                }
            }

//            self.addCoverTiles()
            self.addPathfindingGrid()
            self.addRoomLabels()
            
            // stairs up
            let startingRoomPos = self.map.rooms[0].center
            tileMap.setTileGroup(stairsUp, forColumn: Int(startingRoomPos.x), row: Int(startingRoomPos.y-1))

            
            // add dots
            for col in 0..<tileMap.numberOfColumns {
                for row in 0..<tileMap.numberOfRows {
                    if tileMap.tileGroup(atColumn: col, row: row) == nil {
                        tileMap.setTileGroup(dotGraphPaper, forColumn: col, row: row)
                    }
                }
            }

            
            self.addChild(tileMap)

        }
        
        // Delete this to reset tile map to its default size
//        tileMap.setScale(0.2)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: Helpers

    func doorRightNode(_ c: Int, _ r: Int) -> SKNode {
        let tileWidth : CGFloat = self.tileMap?.tileSize.width ?? 0.0
        let tileHeight : CGFloat = self.tileMap?.tileSize.height ?? 0.0
        let doorHeight : CGFloat = tileHeight / 2.0
        let doorWidth : CGFloat = tileWidth / 4.0
        let node = SKShapeNode(rect: CGRect(x: 0, y: 0, width: doorWidth, height: doorHeight))
        node.fillColor = .white
        node.strokeColor = UIColor(red: 0.0, green: 0.431, blue: 0.827, alpha: 1.0)
        node.lineWidth = 4.0
        let center = self.tileMap?.centerOfTile(atColumn: c, row: r) ?? CGPoint.zero
        node.position = CGPoint(x: center.x + (tileWidth/2) - (doorWidth/2), y: (center.y) - (tileHeight / 4.0))
        node.zPosition = 1
        
        return node
    }

    func doorLeftNode(_ c: Int, _ r: Int) -> SKNode {
        let tileWidth : CGFloat = self.tileMap?.tileSize.width ?? 0.0
        let tileHeight : CGFloat = self.tileMap?.tileSize.height ?? 0.0
        let doorHeight : CGFloat = tileHeight / 2.0
        let doorWidth : CGFloat = tileWidth / 4.0
        let node = SKShapeNode(rect: CGRect(x: 0, y: 0, width: doorWidth, height: doorHeight))
        node.fillColor = .white
        node.strokeColor = UIColor(red: 0.0, green: 0.431, blue: 0.827, alpha: 1.0)
        node.lineWidth = 4.0
        let center = self.tileMap?.centerOfTile(atColumn: c, row: r) ?? CGPoint.zero
        node.position = CGPoint(x: center.x - (tileWidth/2) - (doorWidth/2), y: (center.y) - (tileHeight / 4.0))
        node.zPosition = 1
        
        return node
    }
    
    func doorUpNode(_ c: Int, _ r: Int) -> SKNode {
        let tileWidth : CGFloat = self.tileMap?.tileSize.width ?? 0.0
        let tileHeight : CGFloat = self.tileMap?.tileSize.height ?? 0.0
        let doorHeight : CGFloat = tileHeight / 4.0
        let doorWidth : CGFloat = tileWidth / 2.0
        let node = SKShapeNode(rect: CGRect(x: 0, y: 0, width: doorWidth, height: doorHeight))
        node.fillColor = .white
        node.strokeColor = UIColor(red: 0.0, green: 0.431, blue: 0.827, alpha: 1.0)
        node.lineWidth = 4.0
        let center = self.tileMap?.centerOfTile(atColumn: c, row: r) ?? CGPoint.zero
        node.position = CGPoint(x: center.x - (tileWidth / 4.0), y: (center.y) + (tileHeight/2) - (doorHeight/2))
        node.zPosition = 1

        return node
    }

    func doorDownNode(_ c: Int, _ r: Int) -> SKNode {
        let tileWidth : CGFloat = self.tileMap?.tileSize.width ?? 0.0
        let tileHeight : CGFloat = self.tileMap?.tileSize.height ?? 0.0
        let doorHeight : CGFloat = tileHeight / 4.0
        let doorWidth : CGFloat = tileWidth / 2.0
        let node = SKShapeNode(rect: CGRect(x: 0, y: 0, width: doorWidth, height: doorHeight))
        node.fillColor = .white
        node.strokeColor = UIColor(red: 0.0, green: 0.431, blue: 0.827, alpha: 1.0)
        node.lineWidth = 4.0
        let center = self.tileMap?.centerOfTile(atColumn: c, row: r) ?? CGPoint.zero
        node.position = CGPoint(x: center.x - (tileWidth / 4.0), y: (center.y) - (tileHeight/2) - (doorHeight/2))
        node.zPosition = 1
        
        return node
    }

//    func doorDownNode(_ c:Int, _ r:Int) -> SKNode {
//        let width : CGFloat = self.tileMap?.tileSize.width ?? 0.0
//        let height : CGFloat = self.tileMap?.tileSize.height ?? 0.0
//        let node = SKShapeNode(rect: CGRect(x: width/4.0, y: height, width: width/2.0, height: height/8.0))
//        node.fillColor = .white
//        node.strokeColor = UIColor(red: 0.0, green: 0.431, blue: 0.827, alpha: 1.0)
//        node.lineWidth = 4.0
//        let center = self.tileMap?.centerOfTile(atColumn: c, row: r) ?? CGPoint.zero
//        node.position = CGPoint(x: center.x - (width / 2.0), y: (center.y) - (height + (height/2))  )
//
//
//        let subnode = SKShapeNode(rect: CGRect(x: (width / 4.0) + 4.0, y: height - 2.0, width: width/2.0 - 8, height: 4))
//        subnode.fillColor = .red
//        subnode.strokeColor = .red
//        subnode.lineWidth = 4.0
//        node.addChild(subnode)
//
//
//        return node
//    }
//
//    func doorUpNode(_ c:Int, _ r:Int) -> SKNode {
//        let width : CGFloat = self.tileMap?.tileSize.width ?? 0.0
//        let height : CGFloat = self.tileMap?.tileSize.height ?? 0.0
//        let node = SKShapeNode(rect: CGRect(x: width/4.0, y: 0, width: width/2.0, height: height/8.0))
//        node.fillColor = .white
//        node.strokeColor = UIColor(red: 0.0, green: 0.431, blue: 0.827, alpha: 1.0)
//        node.lineWidth = 4.0
//        let center = self.tileMap?.centerOfTile(atColumn: c, row: r) ?? CGPoint.zero
//        node.position = CGPoint(x: center.x - (width / 2.0), y: (center.y + CGFloat(height/2.0)) - (CGFloat(height)/8.0) )
//
//        let subnode = SKShapeNode(rect: CGRect(x: (width / 4.0) + 4.0, y: height - 2.0, width: width/2.0 - 8, height: 4))
//        subnode.fillColor = .red
//        subnode.strokeColor = .red
//        subnode.lineWidth = 4.0
//        node.addChild(subnode)
//
//
//        return node
//    }
    
    func addRoomLabels() {
        guard let tileMap = self.tileMap else { fatalError("Missing tile map for the level") }

        var roomLabel = 1
        for room in self.map.rooms {
            let labelNode = SKLabelNode(text: "\(roomLabel)")
            labelNode.fontColor = UIColor(red: 0.0, green: 0.431, blue: 0.827, alpha: 1.0)
            labelNode.fontName = "Poppins-Bold"
            labelNode.verticalAlignmentMode = .center
            labelNode.position = tileMap.centerOfTile(atColumn: Int(room.center.x), row: Int(room.center.y))
            tileMap.addChild(labelNode)
            roomLabel = roomLabel + 1
        }
    }
    
    func removeCoverTiles(at pos: CGPoint?, viewRadiusInTiles: Int) {
//        guard let tileMap = self.tileMap else { fatalError("Missing tile map for the level") }
//
//        guard let pos = pos else { fatalError() }
//
//        let shapeNode = SKShapeNode(circleOfRadius: CGFloat(viewRadiusInTiles) * tileMap.tileSize.width)
//        shapeNode.position = pos
//        self.tileMap?.addChild(shapeNode)
//        let centerRow = tileMap.tileRowIndex(fromPosition: pos)
//        let centerCol = tileMap.tileColumnIndex(fromPosition: pos)
//        for col in (centerCol-viewRadiusInTiles)..<(centerCol+viewRadiusInTiles+1) {
//            for row in (centerRow-viewRadiusInTiles)..<(centerRow+viewRadiusInTiles+1) {
//                let point = tileMap.centerOfTile(atColumn: col, row: row)
//                for node in tileMap.nodes(at: point) {
//                    if let node = node as? SKSpriteNode, shapeNode.contains(node.position) {
//                        node.removeFromParent()
//                    }
//                }
//            }
//        }
//        shapeNode.removeFromParent()
    }
    
    func addCoverTiles() {
        guard let tileMap = self.tileMap else { fatalError("Missing tile map for the level") }
        let tileSize = tileMap.tileSize
        
        for col in 0..<tileMap.numberOfColumns {
            for row in 0..<tileMap.numberOfRows {
                //
                let tileNode = SKSpriteNode(color: .darkGray, size: tileSize)
                tileNode.blendMode = .alpha
                tileNode.position = tileMap.centerOfTile(atColumn: col, row: row)
                tileMap.addChild(tileNode)
            }
        }
    }

    func addPathfindingGrid() {
        guard let tileMap = self.tileMap else { fatalError("Missing tile map for the level") }
        
        self.graph = GKGridGraph(fromGridStartingAt: vector2(0, 0), width: Int32(tileMap.numberOfColumns), height: Int32(tileMap.numberOfRows), diagonalsAllowed: false)
        var walls = [GKGridGraphNode?](repeating: nil, count: Int(tileMap.numberOfColumns) * Int(tileMap.numberOfRows))
        
        for col in 0..<tileMap.numberOfColumns {
            for row in 0..<tileMap.numberOfRows {
                let tilegroup = self.tileMap?.tileGroup(atColumn: col, row: row)
                if (tilegroup?.name != "Graph Paper") && !(tilegroup?.name?.contains("Door") ?? false) {
                    walls.append(self.graph?.node(atGridPosition: vector2(Int32(col), Int32(row))))
                }
            }
        }
        let nonoptionalWalls = walls.compactMap { $0 }
        self.graph?.remove(nonoptionalWalls)
    }
    
    // returns CGPoint in the middle of a tile, if the tile is valid to move to
    func pointCenteredInTileContaining(_ point: CGPoint) -> CGPoint? {
        if let column = self.tileMap?.tileColumnIndex(fromPosition: point), let row = self.tileMap?.tileRowIndex(fromPosition: point) {
            
            let tilegroup = self.tileMap?.tileGroup(atColumn: column, row: row)
            if tilegroup?.name == "Graph Paper", let moveTo = self.tileMap?.centerOfTile(atColumn: column, row: row), self.tileMap?.contains(moveTo) ?? false {
                return moveTo
            }
        }
        
        return nil
    }

    func tileMapCoordPath(from startPos:CGPoint?, endPos:CGPoint?) -> [CGPoint] {
        var pointPath : [CGPoint] = []

        guard let fromNode = self.graph?.node(atGridPosition: vector2(Int32(startPos?.x ?? 0), Int32(startPos?.y ?? 0))) else { fatalError("Error in pathfinding") }
        guard let toNode = self.graph?.node(atGridPosition: vector2(Int32(endPos?.x ?? 0), Int32(endPos?.y ?? 0))) else { fatalError("Error in pathfinding") }
        
        if let path = self.graph?.findPath(from: fromNode, to: toNode) as? [GKGridGraphNode] {
            for node in path {                
                // note this returns in tileMap coords
                pointPath.append(CGPoint(x: Int(node.gridPosition.x), y: Int(node.gridPosition.y)))
//                if let point = self.tileMap?.centerOfTile(atColumn: Int(node.gridPosition.x), row: Int(node.gridPosition.y)) {
//                    pointPath.append(point)
//                }
            }
        }
        
        return pointPath
    }
    
    func screenCoordPath(from startPos:CGPoint?, endPos:CGPoint?) -> [CGPoint]? {
        guard let startPoint = startPos else { fatalError("Error in pathfinding") }
        guard let endPoint = endPos else { fatalError("Error in pathfinding") }
        guard let startCol = self.tileMap?.tileColumnIndex(fromPosition: startPoint) else { fatalError("Error in pathfinding") }
        guard let startRow = self.tileMap?.tileRowIndex(fromPosition: startPoint) else { fatalError("Error in pathfinding") }
        guard let endCol = self.tileMap?.tileColumnIndex(fromPosition: endPoint) else { fatalError("Error in pathfinding") }
        guard let endRow = self.tileMap?.tileRowIndex(fromPosition: endPoint) else { fatalError("Error in pathfinding") }

        return tileMapCoordPath(from: CGPoint(x: startCol, y: startRow), endPos: CGPoint(x: endCol, y: endRow))
    }
}
