import { Canvas } from "./canvas";
import { User } from "../connected-users-service.ts/user";

export class CollaborativeService {
    private static service: CollaborativeService;
    private canvas: Canvas[];
    private users: Map<User, string>;

    private constructor() {
        this.canvas = [];
        this.users = new Map<User, string>();
    }

    public static get instance(): CollaborativeService {
        if (CollaborativeService.service === undefined) {
            CollaborativeService.service = new CollaborativeService();
        }
        return this.service;
    }

    public getUsersInCanvas(canvasId: string): User[] {
        const usersInCanvas: User[] = [];
        this.users.forEach((id: string, user: User) => {
            if (id === canvasId)
                usersInCanvas.push(user);
        });
        return usersInCanvas;
    }

    public getCanvas(canvasId: string): Canvas {
        return this.canvas.find((image: Canvas) => image.id === canvasId);
    }

    public getUserCanvas(userSocketId: string): Canvas {
        let roomId: string = undefined;
        this.users.forEach((id: string, user: User) => {
            if (user.socket.id === userSocketId)
                roomId = id;
        });
        return this.getCanvas(roomId);
    }
}