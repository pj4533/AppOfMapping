//
//  Dungeon.swift
//  Slaad
//
//  Created by PJ Gray on 4/29/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import SpriteKit
import os.log

protocol DungeonDelegate {
    func didTapRoom(_ room: Room?)
}

// This should be specific SpriteKit stuff -- not model stuff for the Dungeon map (maybe rename this class)
class Dungeon: SKScene, UIGestureRecognizerDelegate, SKPhysicsContactDelegate {
    
    var dungeonDelegate : DungeonDelegate?
    
    // this is the model for the map itself -- the data goes in here
    var map : DungeonMap?
    
    var tilesize : CGFloat = 64.0
    
    var dungeonNode : BSPDungeonNode?
    var cam: SKCameraNode?
    
    var partyNodes: [SKShapeNode] = []
    
    var tap: UITapGestureRecognizer?
    var pan: UIPanGestureRecognizer?
    var pinch: UIPinchGestureRecognizer?
    
    var previousPlayerPosition : CGPoint?
    var previousCameraScale: CGFloat = 0.0
    var tileMapAnchorPoint : CGPoint?
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        self.backgroundColor = UIColor(red: 0.0, green: 0.431, blue: 0.827, alpha: 1.0)

        guard let map = self.map else { fatalError("Map model not found") }
        
        self.dungeonNode = BSPDungeonNode(tileSize: CGSize(width: self.tilesize,height: self.tilesize), map: map, tileMapAnchorPoint: tileMapAnchorPoint)
        if let dungeon = self.dungeonNode {
            self.addChild(dungeon)
        }
        
        // Once we have the map model made into the scene, with correct pathfinding, figure out
        // where important landmarks should go, such as boss room and trap(s).
        
        // This finds an array of arrays containing the rooms on a path, from the starting room
        // to each room -- the most number of rooms should be the boss room -- trap room on the way to boss room
        let startingRoomPos = self.map?.rooms[0].center
        var pathsFromStartingRoom : [[Int]] = [] // rooms on path from starting room
        for room in self.map?.rooms ?? [] {
            if let path = self.dungeonNode?.tileMapCoordPath(from: startingRoomPos, endPos: room.center) {
                let allRoomsOnPathFromStartingRoom = path.map({self.roomContainingPoint($0)?.roomId})
                var roomsOnPath = Array(Set(allRoomsOnPathFromStartingRoom.compactMap({$0})))
                roomsOnPath.removeAll(where: {($0 == 1) || ($0 == room.roomId ?? 0)})
                pathsFromStartingRoom.append(roomsOnPath)
            }
        }
        
        // this finds the boss room
        var potentialBossRoomIds : [Int] = []
        var maxNumberRooms = 0
        var i = 1
        for paths in pathsFromStartingRoom {
            if paths.count > maxNumberRooms {
                potentialBossRoomIds = [ i ]
                maxNumberRooms = paths.count
            } else if paths.count == maxNumberRooms {
                potentialBossRoomIds.append(i)
            }
            i = i + 1
        }
        if (potentialBossRoomIds.count > 0) || ((potentialBossRoomIds.first ?? 1) != 1) {
            let bossRoomId = potentialBossRoomIds.randomElement() ?? 0
            self.map?.rooms[bossRoomId - 1].shouldBeBossRoom = true
            
            let trapRoomId = pathsFromStartingRoom[bossRoomId - 1].randomElement() ?? 0
            if trapRoomId > 1 {
                self.map?.rooms[trapRoomId - 1].shouldBeTrapRoom = true
            }
        }
        
//        self.addParty()
        
        self.pan = UIPanGestureRecognizer(target: self, action: #selector(pannedScreen(_:)))
        if let pan = self.pan {
            self.view?.addGestureRecognizer(pan)
        }

        self.tap = UITapGestureRecognizer(target: self, action: #selector(tappedScreen(_:)))
        if let tap = self.tap {
            self.view?.addGestureRecognizer(tap)
        }
        
        self.pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchedScreen(_:)))
        self.pinch?.delegate = self
        if let pinch = self.pinch {
            self.view?.addGestureRecognizer(pinch)
        }
    }
    
    func addParty() {
//        this is the player code

//        self.player = SKShapeNode(circleOfRadius: (self.tilesize-20) / 2.0)
//        
//        let startingRoomPos = map.rooms[0].center
//        self.player?.position = self.dungeonNode?.tileMap?.centerOfTile(atColumn: Int(startingRoomPos.x), row: Int(startingRoomPos.y-1)) ?? CGPoint(x: 0.0, y: 0.0)
//        
//        self.player?.fillColor = .gray
//        
//        if let player = self.player {
//            self.addChild(player)
//        }
    }
    
    func addCamera() {
        guard let map = self.map else { fatalError("Map model not found") }

        self.cam = SKCameraNode()
        self.camera = self.cam

        self.previousCameraScale = self.camera?.xScale ?? 0.0
        self.addChild(self.cam!)
        
        let center = self.dungeonNode?.tileMap?.centerOfTile(atColumn: Int(map.columns / 2), row: Int(map.rows / 2)) ?? CGPoint(x: 0.0, y: 0.0)
        self.cam?.position = CGPoint(x: center.x, y: center.y + 60.0)
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
//        if self.previousPlayerPosition != self.player?.position {
//            self.dungeonNode?.removeCoverTiles(at: self.player?.position, viewRadiusInTiles: 5)
//            self.previousPlayerPosition = self.player?.position
//        }
    }
    
    @objc func tappedScreen(_ tap: UITapGestureRecognizer) {
        let viewTouchPoint = tap.location(in: self.view)
        let touchPoint = self.convertPoint(fromView: viewTouchPoint)
        
        if let col = self.dungeonNode?.tileMap?.tileColumnIndex(fromPosition: touchPoint), let row = self.dungeonNode?.tileMap?.tileRowIndex(fromPosition: touchPoint) {
            for room in self.map?.rooms ?? [] {
                if room.x1 <= col && room.x2 >= col && room.y1 <= row && room.y2 >= row {
                    self.dungeonDelegate?.didTapRoom(room)
                }
            }
        }
        

//        if let moveTo = self.dungeonNode?.pointCenteredInTileContaining(touchPoint) {
//            if let path = self.dungeonNode?.path(from: self.player?.position, endPos: moveTo) {
//                var actions : [SKAction] = []
//                for point in path {
//                    actions.append(SKAction.move(to: point, duration: 0.07))
//                }
//                self.player?.run(SKAction.sequence(actions))
//            }
//        }
    }
    
    func roomContainingPoint(_ point: CGPoint) -> Room? {
        for room in self.map?.rooms ?? [] {
            if room.x1 <= Int(point.x) && room.x2 >= Int(point.x) && room.y1 <= Int(point.y) && room.y2 >= Int(point.y) {
                return room
            }
        }
        return nil
    }
    
    @objc func pinchedScreen(_ pinch: UIPinchGestureRecognizer) {
        guard let camera = self.camera else {
            return
        }
        if pinch.state == .began {
            self.previousCameraScale = camera.xScale
        }
        
        print("NEW SCALE: \(self.previousCameraScale * 1 / pinch.scale)")
        camera.setScale(self.previousCameraScale * 1 / pinch.scale)
    }

    @objc func pannedScreen(_ pan: UIPanGestureRecognizer) {
        guard let map = map else { fatalError("Map model not found") }

        // not sure what will happen if map isn't a square...
        let maxMap = (self.tilesize * CGFloat(map.columns))
        
        // calculate the min & max position for the camera ******************** does NOT work for non-default scales
        //    this used to be specific to X/Y but doesn't really matter since I use squares
        let max_camera_x: CGFloat = maxMap//((maxMap/2)  - self.frame.size.width/2)
        let max_camera_y: CGFloat = maxMap//((maxMap/2)  - self.frame.size.height/2)
        
        
        if camera != nil {
            
            
            // the change factor controls how drastically the camera position is translated
            let changeFactor =  camera!.xScale
            
            // calculate the delta translations
            let deltaTranslationX = pan.translation(in: view).x * changeFactor
            let deltaTranslationY = pan.translation(in: view).y * changeFactor
            
            
            // Update the x-axis
            //
            // left boundary check
            if (camera!.position.x - deltaTranslationX) < -max_camera_x {
                
                camera!.position.x = -max_camera_x
            }
                // right boundary check
            else if (camera!.position.x - deltaTranslationX) > max_camera_x {
                
                camera!.position.x = max_camera_x
            }
                // update the camera's x-position if it is not out of bounds
            else {
                camera!.position.x -= deltaTranslationX
            }
            
            
            // Update the y-axis
            //
            // bottom boundary check
            if (camera!.position.y + deltaTranslationY) < -max_camera_y {
                
                camera!.position.y = -max_camera_y
            }
                // top boundary check
            else if (camera!.position.y + deltaTranslationY) > max_camera_y {
                
                camera!.position.y = max_camera_y
            }
                // update the camera's y-position if it is not out of bounds
            else {
                camera!.position.y += deltaTranslationY
            }
            
            // reset the pan's translation to 0,0 such that the next update will give the delta automatically
            pan.setTranslation(CGPoint(x: 0, y: 0), in: view)
        }
    }
    
    // MARK: UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let pinch = self.pinch, let pan = self.pan, gestureRecognizer == pan, otherGestureRecognizer == pinch {
            return true
        }

        return false
    }    
}
