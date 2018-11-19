import { Injectable } from '@angular/core';
import * as io from 'socket.io-client';
import { Likes } from './Likes';
import { Guid } from "guid-typescript";


@Injectable({ providedIn: 'root' })
export class LikesAndCommentsService {

    private apiUrl = 'http://localhost:3000/v2/images';
    public socket;
    public imageId: String;
    public likes: Likes[];
    public comments: Comment[];

    constructor() {
        this.socket = io("http://localhost:3000/");
        let randomId = Guid.raw();
        this.socket.emit("setUsername", randomId);
        this.onPreviewImage();
    }


    onPreviewImage(): void {
        this.socket.on("previewImage", (data) => {
            this.imageId = data["id"];
            this.likes = data["likes"];
            this.comments = data["comments"];
        });
    }

    previewImage(): void {
        this.socket.emit("previewImage", this.imageId);
    }
}