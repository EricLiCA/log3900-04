import * as express from 'express';
import { ChatService } from '../chat-service/chat-service';
import { ConnectedUsersService } from '../connected-users-service.ts/connected-users-service';

export class ChatRooms {
    public get(req: express.Request, res: express.Response, next: express.NextFunction): void {
        res.send(Array.from(ChatService.instance.getRooms().keys()));
    }

    public getUsers(req: express.Request, res: express.Response, next: express.NextFunction): void {
        res.send(Array.from(ChatService.instance.getRooms().get(req.params.room).keys()).map((id) => ConnectedUsersService.getBySocket(id).name));
    }

    public all(req: express.Request, res: express.Response, next: express.NextFunction): void {
        res.send(Array.from(ConnectedUsersService.getAll()));
    }
}
