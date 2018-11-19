//
//  DrawingSocketManager.swift
//  poly-paint-ios
//
//  Created by JP Cech on 11/18/18.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import Foundation
import SocketIO

class DrawingSocketManager {
    
    var socketIOClient: SocketIOClient = ChatModel.instance.socketIOClient
    
    public func addShape(shape: BasicShapeView) {
        socketIOClient.emit("addStroke", shape.toShapeObject()!);
    }
    
    public func removeShape(shape: BasicShapeView) {
        socketIOClient.emit("removeStroke", shape.uuid);
    }
    
    public func editShape(shape: BasicShapeView) {
        socketIOClient.emit("editStroke", shape.toShapeObject()!);
    }
    
    public func  requestAddPerson(imageId: String) {
        socketIOClient.emit("joinImage", imageId);
    }
    
    public func  requestQuit() {
        socketIOClient.emit("leaveImage");
    }
    
    public func lockShape(shapeIds: [String]) {
        socketIOClient.emit("requestProtection", shapeIds);
    }
    
    public func unlockShape() {
        socketIOClient.emit("removeProtection");
    }
    
    public func  clearCanvas() {
        socketIOClient.emit("clearCanvas");
    }
}
