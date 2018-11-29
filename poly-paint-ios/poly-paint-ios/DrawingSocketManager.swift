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
    
    public func addShape(shape: BasicShapeView, imageID: String) {
        socketIOClient.emit("addStroke", shape.toShapeObject(imageID: imageID)!);
    }
    
    public func removeShape(shape: BasicShapeView) {
        socketIOClient.emit("removeStroke", shape.uuid!);
    }
    
    public func editShape(shape: BasicShapeView, imageID: String) {
        socketIOClient.emit("editStroke", shape.toShapeObject(imageID: imageID)!);
    }
    
    public func  requestJoinImage(imageId: String) {
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
    
    public func addLine(shape: Line, imageID: String) {
        socketIOClient.emit("addStroke", shape.toShapeObject(imageID: imageID)!);
    }
    
    public func removeLine(shape: Line) {
        socketIOClient.emit("removeStroke", shape.uuid);
    }
    
    public func editLine(shape: BasicShapeView, imageID: String) {
        socketIOClient.emit("editStroke", shape.toShapeObject(imageID: imageID)!);
    }
}
