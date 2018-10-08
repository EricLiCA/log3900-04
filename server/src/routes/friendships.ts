import * as express from 'express';
import { PostgresDatabase } from '../postgres-database';
import { RedisService } from '../redis.service';

export class FriendshipsRoute {

    public async getAll(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        const db = await PostgresDatabase.getInstance();
        db.query('SELECT * FROM friendships').then((query) => {
            if (query.rowCount > 0) {
                res.send(query.rows);
            } else {
                res.sendStatus(404); // Not found
            }
        })
            .catch((err) => {
                res.sendStatus(400); // Bad request
            });
    }

    public async get(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        const db = await PostgresDatabase.getInstance();
        db.query('SELECT * FROM friendships WHERE "UserId" = $1', [req.params.id]).then((query) => {
            if (query.rowCount > 0) {
                res.send(query.rows);
            } else {
                res.sendStatus(404); // Not found
            }
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
                        if (cachedToken !== null) {
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
                                        redisClient.hset('authTokens', sessionResult.userid, sessionResult.token);
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

    public async logout(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        const redisClient = RedisService.getInstance();
        const db = await PostgresDatabase.getInstance();
        redisClient.hget('authTokens', req.params.id, (redisErr, cachedToken) => {
            if (cachedToken !== null) {
                if (req.body.token === cachedToken) {
                    redisClient.hdel('authTokens', req.params.id);
                    db.query(
                        `DELETE FROM Sessions WHERE "userid" = $1 RETURNING *`,
                        [req.params.id],
                    ).then((queryResult) => {
                        if (queryResult.rowCount > 0) {
                            const result = queryResult.rows[0];
                            res.send({
                                id: result.userid,
                            });
                        } else {
                            res.sendStatus(404);
                        }
                    })
                        .catch((err) => {
                            res.sendStatus(400);
                        });
                }
            } else {
                db.query(
                    `SELECT token FROM Sessions WHERE "userid" = $1`,
                    [req.params.id],
                ).then((queryResult) => {
                    if (queryResult.rowCount > 0) {
                        const result = queryResult.rows[0];
                        if (result.token === req.body.token) {
                            redisClient.hdel('authTokens', req.params.id);
                            db.query(
                                `DELETE FROM Sessions WHERE "userid" = $1 RETURNING *`,
                                [req.params.id],
                            ).then((deleteQueryResult) => {
                                if (deleteQueryResult.rowCount > 0) {
                                    const deleteResult = deleteQueryResult.rows[0];
                                    res.send({
                                        id: deleteResult.userid,
                                    });
                                } else {
                                    res.sendStatus(404);
                                }
                            }).catch((err) => {
                                res.sendStatus(400);
                            });
                        }
                    } else {
                        res.sendStatus(404);
                    }
                }).catch((err) => {
                    res.sendStatus(400);
                });
            }
        });
    }
}
