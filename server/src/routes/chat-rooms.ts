import * as express from 'express';
import { ChatService } from '../chat-service/chat-service';

export class ChatRooms {
    public get(req: express.Request, res: express.Response, next: express.NextFunction): void {
        res.send(ChatService.instance.getRooms());
    }
}
