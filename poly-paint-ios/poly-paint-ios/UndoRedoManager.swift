//
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
    
    public mutating func alertInsertion (shapeType: String, frame: CGRect, color: UIColor, uuid: String) {
        self.undoStack.push(("INSERTION",shapeType,frame,color, uuid))
    }
    
    public mutating func alertDeletion (shapeType: String, frame: CGRect, color: UIColor,uuid: String) {
        self.undoStack.push(("DELETION",shapeType,frame,color, uuid))
    }
    
    public mutating func undo(){
        if (!self.undoStack.isEmpty) {
            var action = self.undoStack.pop()!
            
            if (action.0 == "INSERTION"){
                let uuid = ["uuid": action.4] as [String : Any]
                NotificationCenter.default.post(name: .delete, object: nil, userInfo: uuid)
                action.0 = "DELETION"
                redoStack.push(action)
            }
                
            else if(action.0 == "DELETION"){
                let shapeData = ["frame": action.2,  "color": action.3, "shapeType": action.1] as [String : Any]
                NotificationCenter.default.post(name: .insertionUndoRedo, object: nil, userInfo: shapeData)
                action.0 = "INSERTION"
                redoStack.push(action)
            }
        }
    }
    
    public mutating func redo(){
        if (!self.redoStack.isEmpty) {
            var action = self.redoStack.pop()!
            
            if (action.0 == "INSERTION"){
                let uuid = ["uuid": action.4] as [String : Any]
                NotificationCenter.default.post(name: .delete, object: nil, userInfo: uuid)
                action.0 = "DELETION"
                undoStack.push(action)
            }
                
            else if(action.0 == "DELETION"){
                let shapeData = ["frame": action.2,  "color": action.3, "shapeType": action.1] as [String : Any]
                NotificationCenter.default.post(name: .insertionUndoRedo, object: nil, userInfo: shapeData)
                action.0 = "INSERTION"
                undoStack.push(action)
            }
        }
    }
}




extension Notification.Name {
    static let insertionUndoRedo = Notification.Name("insertionUndoRedo")
}
