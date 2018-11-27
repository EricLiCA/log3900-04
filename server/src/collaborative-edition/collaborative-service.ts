import { Canvas, Size } from "./canvas";
import { User } from "../connected-users-service.ts/user";
import { ShapeObject } from "../models/Shape-object";

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

    public async getCanvas(canvasId: string): Promise<Canvas> {
        let selected = this.canvas.find((image: Canvas) => image.id === canvasId);
        if (selected == undefined) {
            selected = new Canvas(canvasId);
            this.canvas.push(selected);
            await selected.load();
        }

        return selected;
    }

    public getUserCanvas(userSocketId: string): Promise<Canvas> {
        let roomId: string = undefined;
        this.users.forEach((id: string, user: User) => {
            if (user.socket.id === userSocketId)
                roomId = id;
        });
        return roomId == undefined ? undefined : this.getCanvas(roomId);
    }

    public newConnection(user: User): void {

        user.socket.on('joinImage', async (imageId: string) => {
            let canvas = await this.getUserCanvas(user.socket.id);
            
            if (canvas != undefined) {
                user.socket.leave(canvas.id);
                canvas.removeProtections(user);
                //Tel clients user left
            }

            this.users.set(user, imageId);
            user.socket.join(imageId);
            //Tel clients user joined

            canvas = await this.getCanvas(imageId);
            
            user.socket.emit('imageData', canvas.strokes);
            user.socket.emit('resizeCanvas', canvas.size.width, canvas.size.height);
            canvas.protections.forEach((value: string[], key: User) => {
                user.socket.emit("addProtections", key.name, value);
            })

        });

        user.socket.on('leaveImage', async () => {
            let canvas = await this.getUserCanvas(user.socket.id);
            if (canvas != undefined) {
                canvas.removeProtections(user);
                //Tel clients user left
            }
            
            this.users.delete(user);
        });

        user.socket.on('addStroke', async (strignifiedStroke: string) => {
            const canvas = await this.getUserCanvas(user.socket.id);
            const stroke = JSON.parse(strignifiedStroke);
            const toSend = canvas.add(user, stroke as ShapeObject);

            user.socket.to(this.users.get(user)).emit('addStroke', toSend);
            user.socket.emit('editStroke', toSend);
        });

        user.socket.on('removeStroke', async (strokeId: string) => {
            let canvas = await this.getUserCanvas(user.socket.id);
            canvas.remove(strokeId);

            user.socket.to(this.users.get(user)).emit('removeStroke', strokeId);
        });

        user.socket.on('editStroke', async (strignifiedStroke: string) => {
            let canvas = await this.getUserCanvas(user.socket.id);
            let stroke = JSON.parse(strignifiedStroke) as ShapeObject;
            canvas.edit(stroke);

            user.socket.to(this.users.get(user)).emit('editStroke', stroke);
        });

        user.socket.on('requestProtection', async (strokeIds: string) => {
            let canvas = await this.getUserCanvas(user.socket.id);
            let ids = JSON.parse(strokeIds);
            canvas.requestProtection(user, ids as string[]);
        });

        user.socket.on('removeProtection', async () => {
            let canvas = await this.getUserCanvas(user.socket.id);
            canvas.removeProtections(user);
        });

        user.socket.on('clearCanvas', async () => {
            let canvas = await this.getUserCanvas(user.socket.id);
            user.socket.to(this.users.get(user)).emit('clearCanvas');
            canvas.clear();
        });

        user.socket.on('imageProtectionLevelChanged', async (canvasId: string) => {
            const usersInCanvas: User[] = await this.getUsersInCanvas(canvasId);
            usersInCanvas.forEach(userInCanvas => {
                userInCanvas.socket.emit("kickUser");
                this.closeConnection(user);
            });
        });

        user.socket.on('resizeCanvas', async (width: number, height: number) => {
            let canvas = await this.getUserCanvas(user.socket.id);
            canvas.size = new Size(width, height);
            user.socket.to(this.users.get(user)).emit('resizeCanvas', width, height);
        });
    }

    public async closeConnection(user: User) {
        let canvas = await this.getUserCanvas(user.socket.id);
        if (canvas != undefined) {
            canvas.removeProtections(user);
        }
        
        this.users.delete(user);
    }
}