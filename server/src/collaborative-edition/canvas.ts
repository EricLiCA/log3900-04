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

}