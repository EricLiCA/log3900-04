import { PostgresDatabase } from '../postgres-database';

export class ShapeObject {

    public static async create(newShapeObject: ShapeObject): Promise<ShapeObject> {
        const db = await PostgresDatabase.getInstance();
        const queryResponse = await db.query(
            'INSERT INTO shapeobjects("imageid", "shapetype", "index", "shapeinfo") VALUES($1, $2, $3, $4) RETURNING *',
            [newShapeObject.ImageId, newShapeObject.ShapeType, newShapeObject.Index, newShapeObject.ShapeInfo],
        )
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
