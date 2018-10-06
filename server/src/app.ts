import * as bodyParser from "body-parser";
import * as cors from "cors";
import * as express from "express";
import * as httpLogger from "morgan";
import * as path from "path";

import { ServerStatus } from "./routes/server-status";
import { UsersRoute } from "./routes/users";

export class Application {
    /**
     * Bootstrap the application.
     *
     * @class Server
     * @method bootstrap
     * @static
     * @return {ng.auto.IInjectorService} Returns the newly created injector for this this.app.
     */
    public static bootstrap(): Application {
        return new Application();
    }

    public app: express.Application;

    /**
     * Constructor.
     *
     * @class Server
     * @constructor
     */
    constructor() {

        // Application instantiation
        this.app = express();

        // configure this.application
        this.config();

        // configure routes
        this.routes();
    }

    /**
     * The routes function.
     *
     * @class Server
     * @method routes
     */
    public routes() {
        let router: express.Router;
        router = express.Router();

        // create routes
        const serverStatus: ServerStatus = new ServerStatus();
        const usersRoute: UsersRoute = new UsersRoute();

        // hello world path
        router.get("/status/", serverStatus.status.bind(serverStatus.status));

        // Users
        router.get("/users/:id", usersRoute.get.bind(usersRoute.get));

        // use router middleware
        this.app.use("/api", router);

        // error management
        this.app.use((req: express.Request, res: express.Response, next: express.NextFunction) => {
            const err = new Error("Not Found");
            next(err);
        });

        // development error handler
        // will print stacktrace
        if (this.app.get("env") === "development") {
            this.app.use((err: any, req: express.Request, res: express.Response, next: express.NextFunction) => {
                res.status(err.status || 500);
                res.send({
                    error: err,
                    message: err.message,
                });
            });
        }

        // production error handler
        // no stacktraces leaked to user (in production env only)
        this.app.use((err: any, req: express.Request, res: express.Response, next: express.NextFunction) => {
            res.status(err.status || 500);
            res.send({
                error: {},
                message: err.message,
            });
        });
    }

    /**
     * The config function.
     *
     * @class Server
     * @method config
     */
    private config() {
        // Middlewares configuration
        this.app.use(httpLogger("dev"));
        this.app.use(bodyParser.json());
        this.app.use(bodyParser.urlencoded({ extended: true }));
        this.app.use(express.static(path.join(__dirname, "../static")));
        this.app.use(cors());
    }
}
