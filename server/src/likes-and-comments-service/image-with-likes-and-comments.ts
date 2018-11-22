import { ImageComment } from "../models/image-comment";
import { ImageLike } from "../models/image-like";

export class ImageWithLikesAndComments {
    public id: string;
    public comments: ImageComment[];
    public likes: ImageLike[];

    constructor(id: string) {
        this.id = id;
        this.likes = [];
        this.comments = [];
    }

    public loadComments(): Promise<ImageComment[]> {
        return new Promise<ImageComment[]>((resolve, reject) => {
            ImageComment.get(this.id).then(
                (value: ImageComment[]) => {
                    if (value != undefined) {
                        this.comments = value;
                    }
                    resolve(value);

                },
                (rejectReason: any) => reject(rejectReason)
            );
        });
    }

    public loadLikes(): Promise<ImageLike[]> {
        return new Promise<ImageLike[]>((resolve, reject) => {
            ImageLike.get(this.id).then(
                (value: ImageLike[]) => {
                    if (value != undefined) {
                        this.likes = value;
                    }
                    resolve(value);
                },
                (rejectReason: any) => reject(rejectReason)
            );
        });
    }

    public async addComment(userId: string, comment: string): Promise<ImageComment> {
        const imageComment = await ImageComment.post(new ImageComment(this.id, userId, comment));
        if (imageComment != undefined) {
            this.comments.splice(0,0,imageComment);
        }
        return Promise.resolve(imageComment);
    }

    public async addLike(userId: string): Promise<ImageLike> {
        const imageLike = await ImageLike.post(new ImageLike(this.id, userId));
        if (imageLike != undefined) {
            this.likes.push(imageLike);
        }
        return Promise.resolve(imageLike);
    }

    public async removeLike(userId: string): Promise<ImageLike> {
        const imageLike = await ImageLike.delete(new ImageLike(this.id, userId));
        if (imageLike != undefined) {
            this.likes.splice(this.likes.findIndex(likeToRemove => likeToRemove.ImageId == imageLike.ImageId && likeToRemove.UserId == imageLike.UserId), 1);
        }
        return Promise.resolve(imageLike);
    }
}