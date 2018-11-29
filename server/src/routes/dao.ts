import * as express from 'express';
export interface DAO {

    getAll(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void>;
    get(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void>;
    post(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void>;
    update(req: express.Request, res: express.Response, next: express.NextFunction): void;
    delete(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void>;

}
