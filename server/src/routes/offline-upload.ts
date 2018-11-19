import * as express from 'express';
import { PostgresDatabase } from '../postgres-database';
import { ShapeObject } from '../models/Shape-object';

export class OfflineUpload {
    public async put(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        const preparedQuery = {
            text: 'INSERT INTO Images("OwnerId", "Title", "ProtectionLevel", "Password", "ThumbnailUrl", "FullImageUrl") VALUES($1, $2, $3, $4, $5, $6) RETURNING *',
            values: [req.params.id, req.body.title, req.body.protectionLevel, req.body.password, req.body.thumbnailUrl, req.body.fullImageUrl],
        };
        const db = await PostgresDatabase.getInstance();
        db.query(preparedQuery).then((query) => {
            if (query.rowCount > 0) {
                (req.body.shapes as ShapeObject[]).forEach(shape => {
                    shape.ImageId = query.rows[0].Id;
                    ShapeObject.post(shape);
                });

                res.send(true);
                return;
            }
            res.send(false);
        })
            .catch((err) => {
                res.send(false);
            });
    }
}