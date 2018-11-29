import { Injectable } from '@angular/core';
import * as io from 'socket.io-client';
import { Likes } from './Likes';
import { Guid } from "guid-typescript";


@Injectable({ providedIn: 'root' })
export class LikesAndCommentsService {

    private apiUrl = 'http://ec2-34-200-247-233.compute-1.amazonaws.com/v2/images';
    public socket;
    public imageId: String;
    public likes: Likes[];
    public comments: Comment[];

    constructor() {
        this.socket = io("http://ec2-34-200-247-233.compute-1.amazonaws.com/");
        this.socket.emit("setUsername", Guid.raw());
        this.likes = [];
        this.comments = [];
        this.onPreviewImage();
        this.onAddComment();
        this.onAddLike();
        this.onRemoveLike();
    }


    onPreviewImage(): void {
        this.socket.on("previewImage", (data) => {
            this.imageId = data["id"];
            this.likes = data["likes"];
            this.comments = data["comments"];
        });
    }

    onAddComment(): void {
        this.socket.on("addComment", (data) => {
            this.comments.splice(0, 0, data);
        });
    }

    onAddLike(): void {
        this.socket.on("addLike", (data) => {
            this.likes.push(data);
        });
    }

    onRemoveLike(): void {
        this.socket.on("removeLike", (data) => {
            this.likes.splice(this.likes.findIndex(likeToRemove => likeToRemove.UserId == data.UserId), 1);
        });
    }

    previewImage(): void {
        this.socket.emit("previewImage", this.imageId);
    }

    addComment(userId: String, comment: String, userName: String, profileImage: String): void {
        this.socket.emit("addComment", userId, comment, userName, profileImage);
    }

    addLike(userId: String): void {
        this.socket.emit("addLike", userId);

    }

    removeLike(userId: String): void {
        this.socket.emit("removeLike", userId);
    }


}