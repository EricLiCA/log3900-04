import { ShapeObject } from "../models/Shape-object";
import { User } from "../connected-users-service.ts/user";
import { SocketServer } from "../socket-server";

export class Canvas {
    public id: string;
    public strokes: ShapeObject[];

    public protections: Map<User, string[]>

    constructor(_id: string) {
        this.id = _id;
        this.protections = new Map<User, string[]>();
    }

    public load(): Promise<ShapeObject[]> {
        return new Promise<ShapeObject[]>((resolve, reject) => {
            ShapeObject.get(this.id).then(
                (value: ShapeObject[]) => {
                    this.strokes = value;
                    resolve(value.sort((a, b) => a.Index - b.Index));
                },
                (rejectReason: any) =>  reject(rejectReason)
            );
        });
    }

    public add(user: User, newObject: ShapeObject): ShapeObject {
        if (this.protections.has(user)) {
            this.protections.get(user).push(newObject.Id);
        } else {
            this.protections.set(user, [newObject.Id]);
        }

        newObject.Index = this.strokes[this.strokes.length - 1].Index + 1;
        this.strokes.push(newObject)
        return newObject;
    }

    public remove(id: string): void {
        this.strokes.splice(this.strokes.findIndex(stroke => stroke.Id == id), 1);
    }

    public edit(newObject: ShapeObject): void {
        const index = this.strokes.findIndex(stroke => stroke.Id == newObject.Id);
        this.strokes.splice(index, 1)
        const newIndex = this.strokes.findIndex(stroke => stroke.Index > newObject.Index);
        this.strokes.splice(newIndex, 0, newObject);
    }

    public removeProtections(user: User): void {
        if (this.protections.has(user)) {
            SocketServer.socketServerInstance.to(this.id).emit("removeProtections", this.protections.get(user));
            this.protections.delete(user);
        }
    }

    public requestProtection(user: User, ids: string[]): void {
        console.log(ids);
        this.removeProtections(user);
        this.protections.set(user, ids.filter(id => {
            let alreadyLocked = false;
            this.protections.forEach((value: string[], key: User) => {
                if (value.includes(id)) alreadyLocked = true;
            });
            return !alreadyLocked;
        }));
        SocketServer.socketServerInstance.to(this.id).emit("addProtections", user.name, this.protections.get(user));
    }

}