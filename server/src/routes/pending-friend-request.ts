import * as express from 'express';
import { PostgresDatabase } from '../postgres-database';

export class PendingFriendRequestRoute {

    public async getAll(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        console.log('GET pending friend requests');
        const db = await PostgresDatabase.getInstance();
        db.query('SELECT * FROM pending_friend_requests ').then((query) => {
            if (query.rowCount > 0) {
                res.send(query.rows);

            } else {
                res.sendStatus(404); // Not found
            }
        })
            .catch((err) => {
                console.log(err);
                res.sendStatus(400);
            });
    }

    public async get(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        const db = await PostgresDatabase.getInstance();
        db.query('SELECT * FROM Users INNER JOIN (SELECT * FROM pending_friend_requests WHERE "ReceiverId" = $1) as f ON "Id" = f."RequesterId"', [req.params.id]).then((query) => {
            if (query.rowCount > 0) {
                res.send(query.rows.map((row) => {
                    return {
                        id: row.Id,
                        userName: row.Username,
                        profileImage: row.ProfileImage,
                        notified: row.Notified,
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

    public async delete(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        const db = await PostgresDatabase.getInstance();
        db.query('DELETE FROM pending_friend_requests WHERE "RequesterId" = $1 RETURNING *', [req.params.id]).then((query) => {
            if (query.rowCount > 0) {
                const result = query.rows[0];
                res.send({
                    requesterId: result.RequesterId,
                    receiverId: result.ReceiverId,
                    notified: result.Notified,
                });
            }
            res.sendStatus(404);
        })
            .catch((err) => {
                res.sendStatus(400); // Bad request
            });
    }
}
