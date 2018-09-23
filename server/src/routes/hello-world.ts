import * as express from 'express';

module Route {
    export class HelloWorld {
        public hello(req: express.Request, res: express.Response, next: express.NextFunction): void {
            res.send('Hello World!');
        }
    }
}

export = Route;