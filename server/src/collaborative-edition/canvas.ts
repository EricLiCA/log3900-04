import { ShapeObject } from "../models/Shape-object";
import { User } from "../connected-users-service.ts/user";

export class Canvas {
    public id: string;
    public strokes: ShapeObject[];

    public protections: Map<User, string>

}