//  UndoRedoManager.swift
//
//
//  Created by JP Cech on 11/16/18.
//

import Foundation
import UIKit

enum Action {
    case Delete
    case Insert
}

public struct UndoRedoManager {
    
    private var undoStack = Stack<(String,BasicShapeView?, Line?)>()
    private var redoStack = Stack<(String,BasicShapeView?, Line?)>()
    
    
    public mutating func alertInsertion (shape: BasicShapeView) {
        self.undoStack.push(("INSERTION",shape, nil))
    }
    
    public mutating func alertDeletion (shape: BasicShapeView) {
        self.undoStack.push(("DELETION",shape,nil))
    }
    
    public mutating func alertLineInsertion (line: Line) {
        self.undoStack.push(("INSERTION",nil,line))
    }
    
    public mutating func alertLineDeletion (line: Line) {
        self.undoStack.push(("DELETION",nil,line))
    }
    
    public func undoAvailable() -> Bool {
        return !self.undoStack.isEmpty
    }
    
    public func redoAvailable() -> Bool {
        return !self.redoStack.isEmpty
    }
    
    public mutating func undo(){
        if (self.undoAvailable()) {
            let action = self.undoStack.pop()!
            
            if (action.0 == "INSERTION"){
                if(action.1 != nil) {
                    let uuid = ["uuid": action.1!.uuid] as [String : Any]
                    NotificationCenter.default.post(name: .deletionUndoRedo, object: nil, userInfo: uuid)
                    redoStack.push(action)
                }
                else {
                    let line = ["line": action.2!] as [String : Any]
                    NotificationCenter.default.post(name: .deletionLineUndoRedo, object: nil, userInfo: line)
                    redoStack.push(action)
                }
            }
                
            else if(action.0 == "DELETION"){
                if(action.1 != nil) {
                    let shapeData = ["shape": action.1!] as [String : Any]
                    NotificationCenter.default.post(name: .restoreUndoRedo, object: nil, userInfo: shapeData)
                    redoStack.push(action)
                }
                else {
                    let shapeData = ["line": action.2!] as [String : Any]
                    NotificationCenter.default.post(name: .restoreLineUndoRedo, object: nil, userInfo: shapeData)
                    redoStack.push(action)
                }
            }
        }
    }
    
    public mutating func redo(){
        if (self.redoAvailable()) {
            let action = self.redoStack.pop()!
            
            if (action.0 == "INSERTION"){
                if(action.1 != nil){
                    let shapeData = ["shape": action.1!] as [String : Any]
                    NotificationCenter.default.post(name: .restoreUndoRedo, object: nil, userInfo: shapeData)
                    undoStack.push(action)
                }
                else {
                    let shapeData = ["line": action.2!] as [String : Any]
                    NotificationCenter.default.post(name: .restoreLineUndoRedo, object: nil, userInfo: shapeData)
                    undoStack.push(action)
                }
            }

            else if(action.0 == "DELETION"){
                if (action.1 != nil) {
                    let uuid = ["uuid": action.1!.uuid] as [String : Any]
                    NotificationCenter.default.post(name: .deletionUndoRedo, object: nil, userInfo: uuid)
                    undoStack.push(action)
                }
                else {
                    let line = ["line": action.2!] as [String : Any]
                    NotificationCenter.default.post(name: .deletionLineUndoRedo, object: nil, userInfo: line)
                    undoStack.push(action)
                }
            }
        }
    }
}

extension Notification.Name {
    static let restoreUndoRedo = Notification.Name("restorenUndoRedo")
    static let deletionUndoRedo = Notification.Name("deletionUndoRedo")
    static let restoreLineUndoRedo = Notification.Name("restorenLineUndoRedo")
    static let deletionLineUndoRedo = Notification.Name("deletionLineUndoRedo")
}
