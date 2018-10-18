import * as express from 'express';
import { PostgresDatabase } from '../postgres-database';

export class PendingFriendRequestRoute {

    public async getAll(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        const db = await PostgresDatabase.getInstance();
        db.query('SELECT * FROM pending_friend_requests INNER JOIN Users ON "ReceiverId" = "Id"').then((query) => {
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
}
