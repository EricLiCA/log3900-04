import * as express from 'express';
import { PostgresDatabase } from '../postgres-database';
import { RedisService } from '../redis.service';

export class SessionsRoute {

    public async getAll(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        const db = await PostgresDatabase.getInstance();
        db.query('SELECT * FROM Sessions').then((query) => {
            if (query.rowCount > 0) {
                res.send(query.rows.map((row) => {
                    return {
                        id: row.userid,
                    };
                }));
            }
            res.sendStatus(404); // Not found
        })
            .catch((err) => {
                res.sendStatus(400); // Bad request
            });
    }

    public async login(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        const db = await PostgresDatabase.getInstance();
        db.query('SELECT * FROM Users WHERE "Username" = $1', [req.body.username]).then((query) => {
            if (query.rowCount > 0) {
                const result = query.rows[0];
                if (req.body.password === result.Password) {
                    const redisClient = RedisService.getInstance();
                    redisClient.hget('authTokens', result.Id, (redisErr, cachedToken) => {
                        if (cachedToken !== undefined) {
                            res.send({
                                id: result.Id,
                                token: cachedToken,
                            });
                        } else {
                            db.query(
                                `INSERT INTO Sessions("userid")
                                VALUES($1)
                                ON CONFLICT ("userid")
                                DO UPDATE SET "userid" = excluded.userid
                                RETURNING *`,
                                [result.Id],
                            )
                                .then((queryResponse) => {
                                    if (queryResponse.rowCount > 0) {
                                        const sessionResult = queryResponse.rows[0];

                                        res.send({
                                            id: sessionResult.userid,
                                            token: sessionResult.token,
                                        });
                                    }
                                })
                                .catch((err) => {
                                    res.sendStatus(400);
                                });
                        }
                    });
                } else {
                    res.sendStatus(403);
                }
            } else {
                res.sendStatus(404);
            }
        })
            .catch((err) => {
                res.sendStatus(400); // Bad request
            });
    }
}
