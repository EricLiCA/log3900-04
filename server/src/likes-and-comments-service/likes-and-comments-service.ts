import { ImageWithLikesAndComments } from "./image-with-likes-and-comments";
import { User } from "../connected-users-service.ts/user";

export class LikesAndCommentsService {
    private static service: LikesAndCommentsService;
    private images: ImageWithLikesAndComments[];
    private users: Map<User, string>;

    private constructor() {
        this.images = [];
        this.users = new Map<User, string>();
    }

    public static get instance(): LikesAndCommentsService {
        if (LikesAndCommentsService.service === undefined) {
            LikesAndCommentsService.service = new LikesAndCommentsService();
        }
        return this.service;
    }

    public getUserPreviwedImage(userSocketId: string): Promise<ImageWithLikesAndComments> {
        let roomId: string = undefined;
        this.users.forEach((id: string, user: User) => {
            if (user.socket.id === userSocketId)
                roomId = id;
        });
        return roomId == undefined ? undefined : this.getImage(roomId);
    }

    public async getImage(imageId: string): Promise<ImageWithLikesAndComments> {
        let previewedImage = this.images.find((image: ImageWithLikesAndComments) => image.id === imageId);
        if (previewedImage == undefined) {
            previewedImage = new ImageWithLikesAndComments(imageId);
            this.images.push(previewedImage);
            await Promise.all([previewedImage.loadLikes(), previewedImage.loadComments()]);
        }

        return previewedImage;
    }

    public newConnection(user: User): void {
        user.socket.on('previewImage', async (imageId: string) => {
            const previousPreviewedImage = await this.getUserPreviwedImage(user.socket.id);
            if (previousPreviewedImage != undefined) {
                user.socket.leave(previousPreviewedImage.id);
            }

            const previewedImage = await this.getImage(imageId);

            this.users.set(user, imageId);
            user.socket.join(imageId);
            user.socket.emit('previewImage', previewedImage);
        });

        user.socket.on('leaveImage', async () => {
            const previewedImage = await this.getUserPreviwedImage(user.socket.id);
            user.socket.leave(previewedImage.id);
            this.users.delete(user);
        });

        user.socket.on('addComment', async (userId: string, comment: string, userName: string, profileImage: string) => {
            const previewedImage = await this.getUserPreviwedImage(user.socket.id);
            const addedComment = await previewedImage.addComment(userId, comment);
            addedComment.UserName = userName;
            addedComment.ProfileImage = profileImage;
            if (addedComment != undefined) {
                user.socket.emit('addComment', addedComment);
                user.socket.to(this.users.get(user)).emit('addComment', addedComment);
            }
        });

        user.socket.on('addLike', async (userId: string) => {
            const previewedImage = await this.getUserPreviwedImage(user.socket.id);
            const addedLike = await previewedImage.addLike(userId);
            if (addedLike != undefined) {
                user.socket.emit('addLike', addedLike);
                user.socket.to(this.users.get(user)).emit('addLike', addedLike);
            }
        });

        user.socket.on('removeLike', async (userId: string) => {
            const previewedImage = await this.getUserPreviwedImage(user.socket.id);
            const removedLike = await previewedImage.removeLike(userId);
            if (removedLike != undefined) {
                user.socket.emit('removeLike', removedLike);
                user.socket.to(this.users.get(user)).emit('removeLike', removedLike);
            }
        });
    }

    public async closeConnection(user: User) {
        this.users.delete(user);
    }
}