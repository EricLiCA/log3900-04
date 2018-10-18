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

    /**
     * @use: requests or accepts friendship
     * @request-type: POST
     * @endpoint: <route>/:id where id = userId
     * @payload:
     * {
     *     token: <uuid>,
     *     friendId: <uuid>
     * }
     * @Returns:
     * Status 201: Created request
     * Status 400: Bad request (invalid friendId and/or :id)
     * Status 404: Not found (didn't find friendId and/or :id)
     */
    public async post(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        const redisClient = RedisService.getInstance();
        redisClient.hget('authTokens', req.params.id, async (redisErr, token) => {
            if (token !== null && token === req.body.token) {
                const db = await PostgresDatabase.getInstance();
                // Check if friend already added you
                db.query(
                    'SELECT * FROM pending_friend_requests WHERE "RequesterId" = $1 AND "ReceiverId" = $2',
                    [req.body.friendId, req.params.id],
                )
                    .then((queryResult) => {
                        if (queryResult.rowCount > 0) { // already requested
                            db.query(
                                `DELETE
                                     from pending_friend_requests
                                     WHERE "RequesterId" = $1
                                       AND "ReceiverId" = $2;
                                INSERT INTO friendships ("UserId", "FriendId")
                                VALUES ($1, $2);
                                INSERT INTO friendships ("UserId", "FriendId")
                                VALUES ($2, $1);
                                `,
                                [req.body.friendId, req.params.id],
                            )
                                .then((newFriendResult) => {
                                    res.sendStatus(200);
                                })
                                .catch((err) => {
                                    res.sendStatus(400);
                                });
                        } else {
                            db.query(
                                'INSERT INTO pending_friend_requests("RequesterId", "ReceiverId") VALUES($1, $2)',
                                [req.params.id, req.body.friendId],
                            )
                                .then();
                        }
                    })
                    .catch((err) => {
                        res.send(400); // bad request
                    });
            } else {
                res.sendStatus(403); // forbidden
            }
        });
    }

    /**
     * @use: deletes friendship between userId and friendId
     * @request-type: DELETE
     * @endpoint: <route>/:id where id = userId
     * @payload:
     * {
     *     token: <uuid>,
     *     friendId: <uuid>
     * }
     * @Returns:
     * Status 200: Deleted
     * Status 400: Bad request (invalid friendId and/or :id)
     * Status 404: Not found (didn't find friendId and/or :id)
     */
    public async delete(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        const redisClient = RedisService.getInstance();
        redisClient.hget('authTokens', req.params.id, async (redisErr, token) => {
            if (token !== null && token === req.body.token) {
                const db = await PostgresDatabase.getInstance();
                db.query(
                    `DELETE
                         FROM friendships
                         WHERE "UserId" = $1
                           AND "FriendId" = $2;
                    DELETE
                    FROM friendships
                    WHERE "UserId" = $2
                      AND "FriendId" = $1
                    `,
                    [req.params.id, req.body.friendId])
                    .then((queryResult) => {
                        if (queryResult.rowCount > 0) {
                            res.sendStatus(200);
                        } else {
                            res.sendStatus(404);
                        }
                    })
                    .catch((err) => {
                        res.sendStatus(400);
                    });
            } else {
                res.sendStatus(403); // forbidden
            }
        });
    }
}
