import { Express, Request, Response, NextFunction } from 'express';
import  { createServer } from 'http';
import { json } from 'body-parser';
import * as express from 'express';
import * as cors from 'cors';

const port = 5010;
const app = express();

config(app);
createServer(app).listen(port);

function config(app: Express): void {
    app.use(cors());
    app.use(json());
    app.use((req: Request, res: Response, next: NextFunction) => {
        console.log(`${Date.now()} - ${req.method} request from ${req.connection.remoteAddress} at ${req.originalUrl}`)
    });
}
