import { Canvas } from "./canvas";
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
        return this.getCanvas(roomId);
    }

    public newConnection(user: User): void {

        user.socket.on('joinImage', async (imageId: string) => {
            let canvas = await this.getUserCanvas(user.socket.id);
            
            if (canvas != undefined) {
                user.socket.leave(canvas.id);
                //Tel clients user left
            }

            this.users.set(user, imageId);
            user.socket.join(imageId);
            //Tel clients user joined

            canvas = await this.getCanvas(imageId);
            
            user.socket.emit('imageData', canvas.strokes);
            user.socket.emit('allProtections', canvas.protections);

        });

        user.socket.on('leaveImage', () => {
            let canvas = this.getUserCanvas(user.socket.id);
            if (canvas != undefined) {
                //Tel clients user left
            }
            
            this.users.delete(user);
        });

        user.socket.on('addStroke', (strignifiedStroke: string) => {
            let canvas = this.getUserCanvas(user.socket.id);
            let stroke = JSON.parse(strignifiedStroke);
            //Add stroke to canvas
        });

        user.socket.on('removeStroke', (strokeId: string) => {
            let canvas = this.getUserCanvas(user.socket.id);
            //Remove stroke from canvas
        });

        user.socket.on('editStroke', (strignifiedStroke: string) => {
            let canvas = this.getUserCanvas(user.socket.id);
            let stroke = JSON.parse(strignifiedStroke);
            //Edit stroke in canvas
        });

        user.socket.on('requestProtection', (strokeIds: string) => {
            let canvas = this.getUserCanvas(user.socket.id);
            let stroke = JSON.parse(strokeIds);
            //RequestProtection
        });
    }

    public closeConnection(user: User) {
        let canvas = this.getUserCanvas(user.socket.id);
        if (canvas != undefined) {
            //Tel clients user left
        }
        
        this.users.delete(user);
    }
}