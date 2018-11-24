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
    
    private var undoStack = Stack<(String,String,CGRect,UIColor,String)>()
    private var redoStack = Stack<(String,String,CGRect,UIColor,String)>()
    private var undoLineStack = Stack<(String, Line)>()
    private var redoLineStack = Stack<(String, Line)>()
    
    public mutating func alertInsertion (shapeType: String, frame: CGRect, color: UIColor, uuid: String) {
        self.undoStack.push(("INSERTION",shapeType,frame,color, uuid))
    }
    
    public mutating func alertDeletion (shapeType: String, frame: CGRect, color: UIColor,uuid: String) {
        self.undoStack.push(("DELETION",shapeType,frame,color, uuid))
    }
    
    public mutating func alertLineInsertion (line: Line) {
        self.undoLineStack.push(("INSERTION",line))
    }
    
    public mutating func alertLineDeletion (line: Line) {
        self.undoLineStack.push(("DELETION",line))
    }
    
    public func undoAvailable() -> Bool {
        return !self.undoStack.isEmpty
    }
    
    public func redoAvailable() -> Bool {
        return !self.redoStack.isEmpty
    }
    
    public func undoLineAvailable() -> Bool {
        return !self.undoLineStack.isEmpty
    }
    
    public func redoLineAvailable() -> Bool {
        return !self.redoLineStack.isEmpty
    }
    
    public mutating func undo(){
        if (self.undoAvailable()) {
            let action = self.undoStack.pop()!
            
            if (action.0 == "INSERTION"){
                let uuid = ["uuid": action.4] as [String : Any]
                NotificationCenter.default.post(name: .deletionUndoRedo, object: nil, userInfo: uuid)
                redoStack.push(action)
            }
                
            else if(action.0 == "DELETION"){
                let shapeData = ["frame": action.2,  "color": action.3, "shapeType": action.1, "uuid": action.4] as [String : Any]
                NotificationCenter.default.post(name: .restoreUndoRedo, object: nil, userInfo: shapeData)
                redoStack.push(action)
            }
        }
    }
    
    public mutating func undoLine(){
        if (self.undoLineAvailable()) {
            let action = self.undoLineStack.pop()!
            
            if (action.0 == "INSERTION"){
                let line = ["line": action.1] as [String : Any]
                NotificationCenter.default.post(name: .deletionLineUndoRedo, object: nil, userInfo: line)
                redoLineStack.push(action)
            }
                
            else if(action.0 == "DELETION"){
                let shapeData = ["line": action.1] as [String : Any]
                NotificationCenter.default.post(name: .restoreLineUndoRedo, object: nil, userInfo: shapeData)
                redoLineStack.push(action)
            }
        }
    }
    
    public mutating func redo(){
        if (self.redoAvailable()) {
            let action = self.redoStack.pop()!

            if (action.0 == "INSERTION"){
                let shapeData = ["frame": action.2,  "color": action.3, "shapeType": action.1 ,"uuid": action.4] as [String : Any]
                NotificationCenter.default.post(name: .restoreUndoRedo, object: nil, userInfo: shapeData)
                undoStack.push(action)
            }
                
            else if(action.0 == "DELETION"){
                let uuid = ["uuid": action.4] as [String : Any]
                NotificationCenter.default.post(name: .deletionUndoRedo, object: nil, userInfo: uuid)
                undoStack.push(action)
            }
        }
    }
    
    public mutating func redoLine(){
        if (self.redoLineAvailable()) {
            let action = self.redoLineStack.pop()!

            if (action.0 == "INSERTION"){
                let shapeData = ["line": action.1] as [String : Any]
                NotificationCenter.default.post(name: .restoreLineUndoRedo, object: nil, userInfo: shapeData)
                undoLineStack.push(action)
            }
                
            else if(action.0 == "DELETION"){
                let line = ["line": action.1] as [String : Any]
                NotificationCenter.default.post(name: .deletionLineUndoRedo, object: nil, userInfo: line)
                undoLineStack.push(action)
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
