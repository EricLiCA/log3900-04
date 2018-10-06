import * as express from "express";
import { PostgresDatabase } from "../postgres-database";

export class UsersRoute {
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
                    status: "Ok",
                });
            }
            res.send({
                status: "Error",
                error: "Not found",
            });
        })
            .catch((err) => {
                res.send({
                    status: "Error",
                    error: err.routine,
                });
            });
    }
}
