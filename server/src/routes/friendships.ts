import * as express from 'express';
import { PostgresDatabase } from '../postgres-database';
import { RedisService } from '../redis.service';

import { Friendships, FriendshipStatus } from '../models/Friendships';

export class FriendshipsRoute {
    public async get(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        Friendships.get(req.params.id).then((friendships) => {
            res.send(friendships.friends.map((friend) => {
                return {
                    id: friend.Id,
                    username: friend.Username,
                    userLevel: friend.UserLevel,
                    profileImage: friend.ProfileImage,
                };
            }));
        });
    }

    public async getUsersExceptFriends(
        req: express.Request, res: express.Response, next: express.NextFunction,
    ): Promise<void> {
        const db = await PostgresDatabase.getInstance();
        db.query(
            `SELECT * FROM users
            WHERE "Id" != $1 AND "Id" NOT IN (select "FriendId" from friendships where "UserId" = $1);
        `, [req.params.id]).then((query) => {
                if (query.rowCount > 0) {
                    res.send(query.rows.map((friend) => {
                        return {
                            id: friend.Id,
                            username: friend.Username,
                            userLevel: friend.UserLevel,
                            profileImage: friend.ProfileImage,
                        };
                    }));
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
                const friendshipStatus = await Friendships.create(req.params.id, req.body.friendId);
                if (friendshipStatus === FriendshipStatus.REQUESTED) {
                    res.send({
                        status: FriendshipStatus.REQUESTED,
                    });
                } else if (friendshipStatus === FriendshipStatus.ACCEPTED) {
                    res.send({
                        status: FriendshipStatus.ACCEPTED,
                    });
                } else {
                    res.sendStatus(400);
                }
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
                const friendshipStatus = await Friendships.delete(req.params.id, req.body.friendId);
                if (friendshipStatus === FriendshipStatus.REFUSED) {
                    res.send({
                        status: FriendshipStatus.REFUSED,
                    });
                } else if (friendshipStatus === FriendshipStatus.DELETED) {
                    res.send({
                        status: FriendshipStatus.DELETED,
                    });
                } else {
                    res.sendStatus(400);
                }
            } else {
                res.sendStatus(403); // forbidden
            }
        });
    }
}
