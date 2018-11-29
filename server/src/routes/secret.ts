import * as express from 'express';
import { PostgresDatabase } from '../postgres-database';

export class Secret {
    public async get(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        const db = await PostgresDatabase.getInstance();
        db.query('SELECT "FullImageUrl" FROM Images where "secret" = $1', [req.params.secret]).then((query) => {
            if (query.rowCount > 0) {
                res.send(query.rows[0].FullImageUrl);
                return;
            }
            res.sendStatus(404); // Not Found
        })
            .catch((err) => {
                console.log(err);
                res.sendStatus(400); // Bad request
        });
    }
    
    public async generate(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        const db = await PostgresDatabase.getInstance();
        db.query('SELECT "secret" FROM Images where "Id" = $1', [req.params.id]).then((query) => {
            if (query.rowCount > 0) {
                res.send(query.rows[0].secret);
                return;
            }
            res.sendStatus(404); // Not Found
        })
            .catch((err) => {
                console.log(err);
                res.sendStatus(400); // Bad request
        });
    }
}