import * as bodyParser from 'body-parser';
import * as cors from 'cors';
import * as express from 'express';
import * as httpLogger from 'morgan';
import * as path from 'path';

import { ChatRooms } from './routes/chat-rooms';
import { FriendshipsRoute } from './routes/friendships';
import { ImageCommentsRoute } from './routes/image-comments';
import { ImageLikesRoute } from './routes/image-likes';
import { ImagesRoute } from './routes/images';
import { PendingFriendRequestRoute } from './routes/pending-friend-request';
import { ServerStatus } from './routes/server-status';
import { SessionsRoute } from './routes/sessions';
import { UsersRoute } from './routes/users';

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
        const sessionsRoute: SessionsRoute = new SessionsRoute();
        const friendshipsRoute: FriendshipsRoute = new FriendshipsRoute();
        const pendingFriendRequestRoute: PendingFriendRequestRoute = new PendingFriendRequestRoute();
        const imagesRoute: ImagesRoute = new ImagesRoute();
        const imageLikes: ImageLikesRoute = new ImageLikesRoute();
        const imageComments: ImageCommentsRoute = new ImageCommentsRoute();
        const chatRooms: ChatRooms = new ChatRooms();

        // hello world path
        router.get('/status', serverStatus.status);

        // Users
        router.get('/users', usersRoute.getAll);
        router.get('/users/:id', usersRoute.get);
        router.post('/users', usersRoute.post);
        router.put('/users/:id', usersRoute.update);
        router.delete('/users/:id', usersRoute.delete);

        // Sessions
        router.get('/sessions', sessionsRoute.getAll);
        router.post('/sessions', sessionsRoute.login);
        router.delete('/sessions/:id', sessionsRoute.logout);

        // Friendships
        router.get('/friendships/:id', friendshipsRoute.get);
        router.get('/usersExceptFriends/:id', friendshipsRoute.getUsersExceptFriends);
        router.post('/friendships/:id', friendshipsRoute.post);
        router.delete('/friendships/:id', friendshipsRoute.delete);

        // PendingFriendRequest
        router.get('/pendingFriendRequest', pendingFriendRequestRoute.getAll);
        router.get('/pendingFriendRequest/:id', pendingFriendRequestRoute.get);
        router.get('/pendingFriendRequestByRequesterId/:id', pendingFriendRequestRoute.getByRequesterId);
        router.delete('/pendingFriendRequest/:id', pendingFriendRequestRoute.delete);

        // Images
        router.get('/images', imagesRoute.getAll);
        router.get('/images/:id', imagesRoute.get);
        router.get('/imagesByOwnerId/:id', imagesRoute.getByOwnerId);
        router.get('/imagesPublicExceptMine/:id', imagesRoute.getPublicExceptMine);
        router.post('/images', imagesRoute.post);
        router.put('/images/:id', imagesRoute.update);
        router.delete('/images/:id', imagesRoute.delete);

        // ImageLikes
        router.get('/imageLikes/:imageId', imageLikes.get);
        router.post('/imageLikes', imageLikes.post);
        router.delete('/imageLikes/:imageId/:userId', imageLikes.delete);

        // ImageComments
        router.get('/imageComments/:imageId', imageComments.get);
        router.post('/imageComments', imageComments.post);
        router.delete('/imageComments/:imageId/:userId', imageComments.delete);

        // Chat Rooms
        router.get('/chatRooms', chatRooms.get);
        router.get('/chatRooms/:room', chatRooms.getUsers);
        router.get('/connectedUsers', chatRooms.all);

        // use router middleware
        this.app.use('/v2', router);

        // error management
        this.app.use((req: express.Request, res: express.Response, next: express.NextFunction) => {
            const err = new Error('Not Found');
            next(err);
        });

        // development error handler
        // will print stacktrace
        if (this.app.get('env') === 'development') {
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
        this.app.use(httpLogger('dev'));
        this.app.use(bodyParser.json());
        this.app.use(bodyParser.urlencoded({ extended: true }));
        this.app.use(express.static(path.join(__dirname, '../static')));
        this.app.use(cors());
    }
}
