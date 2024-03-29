import * as express from 'express';
import { PostgresDatabase } from '../postgres-database';

export class ImageCommentsRoute {

    public async get(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        const db = await PostgresDatabase.getInstance();

        db.query('SELECT * FROM ImageComments INNER JOIN Users ON "UserId" = "Id" WHERE "ImageId" = $1 ORDER BY "Timestamp" desc', [req.params.imageId]).then((query) => {
            if (query.rowCount > 0) {
                res.send(query.rows.map((row) => {
                    return {
                        imageId: row.ImageId,
                        userId: row.UserId,
                        timestamp: row.Timestamp,
                        comment: row.Comment,
                        userName: row.Username,
                        profileImage: row.ProfileImage
                    };
                }));
                return;
            }
            res.sendStatus(404); // Not found
        })
            .catch((err) => {
                res.sendStatus(400); // Bad request
            });
    }

    public async post(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        const preparedQuery = {
            text: 'INSERT INTO ImageComments("ImageId", "UserId", "Comment") VALUES($1, $2, $3) RETURNING *',
            values: [req.body.imageId, req.body.userId, req.body.comment],
        };
        const db = await PostgresDatabase.getInstance();
        db.query(preparedQuery).then((query) => {
            if (query.rowCount > 0) {
                const result = query.rows[0];
                res.status(201);
                res.send({
                    imageId: result.ImageId,
                    userId: result.UserId,
                    timestamp: result.Timestamp,
                    comment: result.Comment,
                });
                return;
            }
            res.sendStatus(204);
        })
            .catch((err) => {
                res.sendStatus(400); // Bad request
            });
    }

    public async delete(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        const db = await PostgresDatabase.getInstance();
        db.query('DELETE FROM ImageComments WHERE "ImageId" = $1 and "UserId" = $2 RETURNING *', [req.params.imageId, req.params.userId]).then((query) => {
            if (query.rowCount > 0) {
                const result = query.rows[0];
                res.send({
                    imageId: result.ImageId,
                    userId: result.UserId,
                    timestamp: result.Timestamp,
                    comment: result.Comment,
                });
                return;
            }
            res.sendStatus(404);
        })
            .catch((err) => {
                res.sendStatus(400); // Bad request
            });
    }
}
