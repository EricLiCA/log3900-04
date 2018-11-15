import { ShapeObject } from "../models/Shape-object";
import { User } from "../connected-users-service.ts/user";

export class Canvas {
    public id: string;
    public strokes: ShapeObject[];

    public protections: Map<User, string>

    constructor(_id: string) {
        this.id = _id;
    }

    public load(): Promise<ShapeObject[]> {
        return new Promise<ShapeObject[]>((resolve, reject) => {
            ShapeObject.get(this.id).then(
                (value: ShapeObject[]) => {
                    this.strokes = value;
                    resolve(value);
                },
                (rejectReason: any) =>  reject(rejectReason)
            );
        });
    }

    public add(newObject: ShapeObject): ShapeObject {
        newObject.Index = this.strokes[this.strokes.length - 1].Index + 1;
        this.strokes.push(newObject)
        return newObject;
    }

    public remove(id: string): void {
        this.strokes.splice(this.strokes.findIndex(stroke => stroke.Id == id), 1);
    }

    public edit(newObject: ShapeObject): void {
        const index = this.strokes.findIndex(stroke => stroke.Id == newObject.Id);
        this.strokes[index] = newObject;
    }

}