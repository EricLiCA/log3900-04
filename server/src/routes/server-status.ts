import * as express from "express";

export class ServerStatus {
    public status(req: express.Request, res: express.Response, next: express.NextFunction): void {
        res.send("log3900-server");
    }
}
