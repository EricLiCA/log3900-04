import * as express from 'express';
import { PostgresDatabase } from '../postgres-database';
import { DAO } from './dao';

const RANDOM_IMAGE: string = 'https://i.pinimg.com/originals/f5/05/24/f50524ee5f161f437400aaf215c9e12f.jpg';

export class ImagesRoute implements DAO {

    public async getAll(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        const db = await PostgresDatabase.getInstance();
        db.query('SELECT Images.*, Users."Username" FROM Images INNER JOIN Users ON "OwnerId" = Users."Id"').then((query) => {
            if (query.rowCount > 0) {
                res.send(query.rows.map((row) => {
                    return {
                        id: row.Id,
                        ownerId: row.OwnerId,
                        title: row.Title,
                        protectionLevel: row.ProtectionLevel,
                        password: row.Password,
                        thumbnailUrl: row.ThumbnailUrl,
                        fullImageUrl: row.FullImageUrl,
                        authorName: row.Username
                    };
                }));
                return;
            }
            res.send([]);
        })
            .catch((err) => {
                res.sendStatus(400); // Bad request
            });
    }

    public async getByOwnerId(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        const db = await PostgresDatabase.getInstance();
        db.query('SELECT Images.*, Users."Username" FROM Images INNER JOIN Users ON "OwnerId" = Users."Id" where "OwnerId" = $1', [req.params.id]).then((query) => {
            if (query.rowCount > 0) {
                res.send(query.rows.map((row) => {
                    return {
                        id: row.Id,
                        ownerId: row.OwnerId,
                        title: row.Title,
                        protectionLevel: row.ProtectionLevel,
                        password: row.Password,
                        thumbnailUrl: row.ThumbnailUrl,
                        fullImageUrl: row.FullImageUrl,
                        authorName: row.Username
                    };
                }));
                return;
            }
            res.send([]);
        })
            .catch((err) => {
                res.sendStatus(400); // Bad request
        });
    }

    public async getPublicExceptMine(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        const db = await PostgresDatabase.getInstance();
        db.query('SELECT Images.*, Users."Username" FROM Images INNER JOIN Users ON "OwnerId" = Users."Id" where ("ProtectionLevel" = $1 or "ProtectionLevel" = $2) and "OwnerId" != $3', ['public', 'protected', req.params.id]).then((query) => {
            if (query.rowCount > 0) {
                res.send(query.rows.map((row) => {
                    return {
                        id: row.Id,
                        ownerId: row.OwnerId,
                        title: row.Title,
                        protectionLevel: row.ProtectionLevel,
                        password: row.Password,
                        thumbnailUrl: row.ThumbnailUrl,
                        fullImageUrl: row.FullImageUrl,
                        authorName: row.Username
                    };
                }));
                return;
            }
            res.send([]);
        })
            .catch((err) => {
                res.sendStatus(400); // Bad request
        });
    }

    public async get(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        const db = await PostgresDatabase.getInstance();
        db.query('SELECT * FROM Images WHERE "Id" = $1', [req.params.id]).then((query) => {
            if (query.rowCount > 0) {
                const result = query.rows[0];
                res.send({
                    id: result.Id,
                    ownerId: result.OwnerId,
                    title: result.Title,
                    protectionLevel: result.ProtectionLevel,
                    password: result.Password,
                    thumbnailUrl: result.ThumbnailUrl,
                    fullImageUrl: result.FullImageUrl,
                });
                return;
            }
            res.sendStatus(404);
        })
            .catch((err) => {
                res.sendStatus(400); // Bad request
            });
    }

    public async post(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        const preparedQuery = {
            text: 'INSERT INTO Images("OwnerId", "Title", "ProtectionLevel", "Password", "ThumbnailUrl", "FullImageUrl") VALUES($1, $2, $3, $4, $5, $6) RETURNING *',
            values: [req.body.ownerId, req.body.title, req.body.protectionLevel, req.body.password, req.body.thumbnailUrl, RANDOM_IMAGE],
        };
        const db = await PostgresDatabase.getInstance();
        db.query(preparedQuery).then((query) => {
            if (query.rowCount > 0) {
                const result = query.rows[0];
                res.status(201);
                res.send({
                    id: result.Id,
                    ownerId: result.OwnerId,
                    title: result.Title,
                    protectionLevel: result.ProtectionLevel,
                    password: result.Password,
                    thumbnailUrl: result.ThumbnailUrl,
                    fullImageUrl: result.FullImageUrl,
                });
                return;
            }
            res.sendStatus(204);
        })
            .catch((err) => {
                res.sendStatus(400); // Bad request
            });
    }

    public async update(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        const updates = [
            ['OwnerId', req.body.ownerId],
            ['Title', req.body.title],
            ['ProtectionLevel', req.body.protectionLevel],
            ['Password', req.body.password],
            ['ThumbnailUrl', req.body.thumbnailUrl],
            ['FullImageUrl', req.body.fullImageUrl],
        ];

        // Build the query : UPDATE Users SET col1 = val1, col2 = val2, ... WHERE Id = <id>;
        let queryText = 'UPDATE Images SET ';
        updates.forEach((update, i) => {
            queryText += `"${update[0]}" = $${i + 1}`;
            if (i !== updates.length - 1) {
                queryText += ',';
            }
        });
        queryText += ` WHERE "Id" = $${updates.length + 1} RETURNING *`;

        const preparedQuery = {
            text: queryText,
            values: updates.map((update) => update[1]).concat([req.params.id]),
        };

        // Query the database
        const db = await PostgresDatabase.getInstance();
        db.query(preparedQuery).then((query) => {
            if (query.rowCount > 0) {
                const result = query.rows[0];
                res.status(200);
                res.send({
                    id: result.Id,
                    ownerId: result.OwnerId,
                    title: result.Title,
                    protectionLevel: result.ProtectionLevel,
                    password: result.Password,
                    thumbnailUrl: result.ThumbnailUrl,
                    fullImageUrl: result.FullImageUrl,
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
        db.query('DELETE FROM Images WHERE "Id" = $1 RETURNING *', [req.params.id]).then((query) => {
            if (query.rowCount > 0) {
                const result = query.rows[0];
                res.send({
                    id: result.Id,
                    ownerId: result.OwnerId,
                    title: result.Title,
                    protectionLevel: result.ProtectionLevel,
                    password: result.Password,
                    thumbnailUrl: result.ThumbnailUrl,
                    fullImageUrl: result.FullImageUrl,
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
