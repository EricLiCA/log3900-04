import * as express from 'express';
import { PostgresDatabase } from '../postgres-database';

export class PendingFriendRequestRoute {

    public async getAll(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        console.log("GET pending friend requests")
        const db = await PostgresDatabase.getInstance();
        db.query('SELECT * FROM pending_friend_requests WHERE "ReceiverId" = $1', [req.params.id])
            .then((pendingFriendRequests) => {
                res.sendStatus(200);
            })
            .catch((err) => {
                console.log(err)
                res.sendStatus(400);
            });
    }
}
