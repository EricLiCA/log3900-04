import * as express from 'express';
import { PostgresDatabase } from '../postgres-database';

export class ImageLikesRoute {

    public async get(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        const db = await PostgresDatabase.getInstance();

        db.query('SELECT * FROM ImageLikes WHERE "ImageId" = $1', [req.params.imageId]).then((query) => {
            if (query.rowCount > 0) {
                res.send(query.rows.map((row) => {
                    return {
                        imageId: row.ImageId,
                        userId: row.UserId,
                    };
                }));
            }
            res.sendStatus(404); // Not found
        })
            .catch((err) => {
                res.sendStatus(400); // Bad request
            });
    }

    public async post(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        const preparedQuery = {
            text: 'INSERT INTO ImageLikes("ImageId", "UserId") VALUES($1, $2) RETURNING *',
            values: [req.body.imageId, req.body.userId],
        };
        const db = await PostgresDatabase.getInstance();
        db.query(preparedQuery).then((query) => {
            if (query.rowCount > 0) {
                const result = query.rows[0];
                res.status(201);
                res.send({
                    imageId: result.ImageId,
                    userId: result.UserId,
                });
            }
            res.sendStatus(204);
        })
            .catch((err) => {
                res.sendStatus(400); // Bad request
            });
    }

    public async delete(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        const db = await PostgresDatabase.getInstance();
        db.query('DELETE FROM ImageLikes WHERE "ImageId" = $1 and "UserId" = $2 RETURNING *', [req.params.imageId, req.params.userId]).then((query) => {
            if (query.rowCount > 0) {
                const result = query.rows[0];
                res.send({
                    imageId: result.ImageId,
                    userId: result.UserId,
                });
            }
            res.sendStatus(404);
        })
            .catch((err) => {
                res.sendStatus(400); // Bad request
            });
    }
}
