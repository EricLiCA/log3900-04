import * as express from 'express';
import { ShapeObject } from '../models/Shape-object';

export class ShapeObjectRoute {
    public async post(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        ShapeObject.post(req.body).then((newShapeObject) => {
            if (newShapeObject === undefined) {
                res.sendStatus(404);
            } else {
                res.status(201);
                res.send({
                    newShapeObject
                });
            }
        })
            .catch((err) => {
                res.sendStatus(400); // Bad request
            });
    }

    public async get(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        ShapeObject.get(req.params.imageId).then((shapeObjects) => {
            if (shapeObjects === undefined) {
                res.sendStatus(404);
            } else {
                res.send(shapeObjects.map((shapeObject) => {
                    return {
                        Id: shapeObject.Id,
                        ImageId: shapeObject.ImageId,
                        Index: shapeObject.Index,
                        ShapeInfo: shapeObject.ShapeInfo,
                        ShapeType: shapeObject.ShapeType
                    };
                }));
            }
        });
    }

    public async update(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        ShapeObject.update(req.body).then((shapeObjectToUpdate) => {
            if (shapeObjectToUpdate === undefined) {
                res.sendStatus(400);
            } else {
                res.send({
                    shapeObjectToUpdate
                });
            }
        });

    }

    public async delete(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        ShapeObject.delete(req.params.id).then((shapeObjectToUpdate) => {
            if (shapeObjectToUpdate === undefined) {
                res.sendStatus(400);
            } else {
                res.send({
                    shapeObjectToUpdate
                });
            }
        });
    }
}
