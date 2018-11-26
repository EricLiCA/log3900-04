import { ShapeObject } from "../models/Shape-object";
import { User } from "../connected-users-service.ts/user";
import { SocketServer } from "../socket-server";
import { PostgresDatabase } from "../postgres-database";

export class Canvas {
    public id: string;
    public strokes: ShapeObject[];

    public protections: Map<User, string[]>

    constructor(_id: string) {
        this.id = _id;
        this.protections = new Map<User, string[]>();
    }

    private _size: Size;
    get size(): Size {
        return this._size;
    }
    set size(value: Size) {
        this._size = value;
        this.updateDb();
    }

    async updateDb() {
        const db = await PostgresDatabase.getInstance();
            db.query(
                `UPDATE Images SET "width" = ${this.size.width}, "height" = ${this.size.height} WHERE "Id" = '${this.id}' RETURNING *`
            ).catch((err) => {
                console.log(err);
            });
    }

    public load(): Promise<ShapeObject[]> {
        return new Promise<ShapeObject[]>(async(resolve, reject) => {

            const db = await PostgresDatabase.getInstance();
            db.query('SELECT * FROM Images WHERE "Id" = $1', [this.id]).then((query) => {
                if (query.rowCount > 0) {
                    this.size = new Size(query.rows[0].width, query.rows[0].height);
                    
                    ShapeObject.get(this.id).then(
                        (value: ShapeObject[]) => {
                            if (value === undefined)
                                value = [];
        
                            this.strokes = value;
                            resolve(value.sort((a, b) => a.Index - b.Index));
                        },
                        (rejectReason: any) =>  reject(rejectReason)
                    );

                    return;
                }
                reject("image with id " + this.id + " does not exist.");
            })
                .catch((err) => {
                    reject(err) // Bad request
                });
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
        ShapeObject.post(newObject);
        return newObject;
    }

    public remove(id: string): void {
        this.strokes.splice(this.strokes.findIndex(stroke => stroke.Id == id), 1);
        ShapeObject.delete(id);
    }

    public edit(newObject: ShapeObject): void {
        const index = this.strokes.findIndex(stroke => stroke.Id == newObject.Id);
        this.strokes.splice(index, 1)
        const newIndex = this.strokes.findIndex(stroke => stroke.Index > newObject.Index);
        this.strokes.splice(newIndex, 0, newObject);
        ShapeObject.update(newObject);
    }

    public removeProtections(user: User): void {
        if (this.protections.has(user)) {
            SocketServer.socketServerInstance.to(this.id).emit("removeProtections", this.protections.get(user));
            this.protections.delete(user);
        }
    }

    public requestProtection(user: User, ids: string[]): void {
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

    public clear(): void {
        this.protections.clear();
        this.strokes = [];
    }

}

export class Size {
    constructor(public width: number, public height: number) {}
}