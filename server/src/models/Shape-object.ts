import { PostgresDatabase } from '../postgres-database';

export class ShapeObject {

    public static async post(newShapeObject: ShapeObject): Promise<ShapeObject> {
        const db = await PostgresDatabase.getInstance();
        const queryResponse = await db.query(
            'INSERT INTO shapeobjects("id", "imageid", "shapetype", "index", "shapeinfo") VALUES($1, $2, $3, $4, $5) RETURNING *',
            [newShapeObject.Id, newShapeObject.ImageId, newShapeObject.ShapeType, newShapeObject.Index, newShapeObject.ShapeInfo],
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

    public static async update(shapeObjectToUpdate: ShapeObject): Promise<ShapeObject> {
        let updates = [
            ['shapetype', shapeObjectToUpdate.ShapeType],
            ['index', shapeObjectToUpdate.Index],
            ['shapeinfo', shapeObjectToUpdate.ShapeInfo]
        ];
        // Build the query : UPDATE Users SET col1 = val1, col2 = val2, ... WHERE Id = <id>;
        let queryText = 'UPDATE shapeobjects SET ';
        updates.forEach((update, i) => {
            queryText += `"${update[0]}" = $${i + 1}`;
            if (i !== updates.length - 1) {
                queryText += ',';
            }
        });
        queryText += ` WHERE "id" = $${updates.length + 1} RETURNING *`;

        const preparedQuery = {
            text: queryText,
            values: updates.map((update) => update[1]).concat([shapeObjectToUpdate.Id]),
        };

        // Query the database
        try {
            const db = await PostgresDatabase.getInstance();
            const queryResponse = await db.query(preparedQuery);
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
        } catch {
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

    public static async delete(id: string): Promise<ShapeObject> {
        const db = await PostgresDatabase.getInstance();
        const queryResponse = await db.query(
            'DELETE FROM shapeobjects WHERE "id" = $1 RETURNING *',
            [id],
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

    public Id: string;
    public ImageId: string;
    public ShapeType: string;
    public Index: string;
    public ShapeInfo: {};

    public constructor(id: string, imageId: string, shapeType: string, index: string, shapeInfo: {}) {
        this.Id = id;
        this.ImageId = imageId;
        this.ShapeType = shapeType;
        this.ShapeInfo = shapeInfo;
        this.Index = index;
    }
}
