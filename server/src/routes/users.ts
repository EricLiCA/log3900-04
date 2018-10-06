import * as express from "express";
import { PostgresDatabase } from "../postgres-database";

export class UsersRoute {
    public async getAll(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        const db = await PostgresDatabase.getInstance();
        db.query('SELECT * FROM Users').then((query) => {
            if (query.rowCount > 0) {
                res.send(query.rows.map((row) => {
                    return {
                        id: row.Id,
                        username: row.Username,
                        userLevel: row.UserLevel,
                    };
                }));
            }
            res.sendStatus(404); // Not found
        })
            .catch((err) => {
                res.sendStatus(400); // Bad request
            });
    }

    public async get(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        const userId = req.params.id;
        const db = await PostgresDatabase.getInstance();
        db.query('SELECT * FROM Users WHERE "Id" = $1', [userId]).then((query) => {
            if (query.rowCount > 0) {
                const result = query.rows[0];
                res.send({
                    id: result.Id,
                    username: result.Username,
                    userLevel: result.UserLevel,
                });
            }
            res.sendStatus(404);
        })
            .catch((err) => {
                res.sendStatus(400); // Bad request
            });
    }
}
