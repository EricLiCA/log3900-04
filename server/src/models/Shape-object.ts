import { PostgresDatabase } from '../postgres-database';

export class ShapeObject {

    public static async create(newShapeObjects: ShapeObject[], imageId: string): Promise<ShapeObject> {
        const db = await PostgresDatabase.getInstance();
        await db.query( 'DELETE from shapeobjects where "imageid" = $1',[imageId]);
        
        let values = Array<string>();
        let index: number = 1;
        let order: string = "";
        for (let i: number = 0; i < newShapeObjects.length; i++) {
            values.push(newShapeObjects[i].Id);
            values.push(newShapeObjects[i].ImageId);
            values.push(newShapeObjects[i].ShapeType);
            values.push(newShapeObjects[i].Index);
            values.push(newShapeObjects[i].ShapeInfo);
            order += "($" + index++ + ",$" + index++ + ",$" + index++ + ",$" + index++ + ",$" + index++ + "),";
            console.log(order);
        }
        order = order.slice(0, -1);
        console.log(order);
        console.log(values);
        const queryResponse = await db.query(
            'INSERT INTO shapeobjects("id", "imageid", "shapetype", "index", "shapeinfo") VALUES ' + order + ' RETURNING *',
            values
        );
        if (queryResponse.rowCount > 0) {
            const row = queryResponse.rows[0];
            return Promise.resolve(new ShapeObject(
                row.id,
                row.imageid,
                row.shapetype,
                row.index,
                row.shapeinfo,
            ));
        } else {
            return Promise.resolve(undefined);
        }
    }

    public static async get(imageId: string): Promise<ShapeObject[]> {
        const db = await PostgresDatabase.getInstance();
        const queryResponse = await db.query('SELECT * FROM shapeobjects WHERE "imageid" = $1', [imageId]);
        if (queryResponse.rowCount > 0) {
            return Promise.resolve(queryResponse.rows.map((row) => {
                return new ShapeObject(
                    row.id,
                    row.imageid,
                    row.shapetype,
                    row.index,
                    row.shapeinfo,
                );
            }));
        } else {
            return Promise.resolve(undefined);
        }
    }

    public Id: string;
    public ImageId: string;
    public ShapeType: string;
    public Index: string;
    public ShapeInfo: string;

    public constructor(id: string, imageId: string, shapeType: string, index: string, shapeInfo: string) {
        this.Id = id;
        this.ImageId = imageId;
        this.ShapeType = shapeType;
        this.ShapeInfo = shapeInfo;
        this.Index = index;
    }
}
