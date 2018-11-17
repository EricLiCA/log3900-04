import * as express from 'express';

import { User } from '../models/User';
import { ConnectedUsersService } from '../connected-users-service.ts/connected-users-service';

export class UsersRoute {

    public async getAll(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        User.getAll().then((results) => {
            res.send(results.map((user: User) => {
                return {
                    id: user.Id,
                    username: user.Username,
                    userLevel: user.UserLevel,
                    profileImage: user.ProfileImage,
                };
            }));
        });
    }

    public async get(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        User.get(req.params.id).then((user) => {
            if (user === undefined) {
                res.sendStatus(404);
            } else {
                res.send({
                    id: user.Id,
                    username: user.Username,
                    userLevel: user.UserLevel,
                    profileImage: user.ProfileImage,
                });
            }
        });
    }

    public async post(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        if (req.body.username === undefined || req.body.password === undefined) {
            res.sendStatus(400);
        } else {
            User.create(req.body.username, req.body.password).then((user) => {
                if (user === undefined) {
                    res.sendStatus(404);
                } else {
                    res.status(201);
                    res.send({
                        id: user.Id,
                        username: user.Username,
                        userLevel: user.UserLevel,
                        profileImage: user.ProfileImage,
                    });
                }
            })
            .catch((err) => {
                res.sendStatus(400); // Bad request
            });
        }
    }

    public update(req: express.Request, res: express.Response, next: express.NextFunction): void {
        User.update(
            req.params.id, req.body.username, req.body.password, req.body.userLevel, req.body.profileImage,
        ).then((user) => {
            if (user === undefined) {
                res.sendStatus(400);
            } else {
                res.send({
                    id: user.Id,
                    username: user.Username,
                    userLevel: user.UserLevel,
                    profileImage: user.ProfileImage,
                });
            }
        });

    }

    public async delete(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        User.delete(req.params.id).then((user) => {
            if (user === undefined) {
                res.sendStatus(400);
            } else {
                ConnectedUsersService.deleteUser(user.Username);
                res.send({
                    id: user.Id,
                    username: user.Username,
                    userLevel: user.UserLevel,
                    profileImage: user.ProfileImage,
                });
            }
        });
    }
}
