import { ImageComment } from "../models/image-comment";
import { ImageLike } from "../models/image-like";

export class ImageWithLikesAndComments {
    public id: string;
    public comments: ImageComment[];
    public likes: ImageLike[];

    constructor(id: string) {
        this.id = id;
    }

    public loadComments(): Promise<ImageComment[]> {
        return new Promise<ImageComment[]>((resolve, reject) => {
            ImageComment.get(this.id).then(
                (value: ImageComment[]) => {
                    this.comments = value;
                },
                (rejectReason: any) => reject(rejectReason)
            );
        });
    }

    public loadLikes(): Promise<ImageLike[]> {
        return new Promise<ImageLike[]>((resolve, reject) => {
            ImageLike.get(this.id).then(
                (value: ImageLike[]) => {
                    this.likes = value;
                    resolve(value);
                },
                (rejectReason: any) => reject(rejectReason)
            );
        });
    }

    public async addLike(userId: string): Promise<void> {
        const imageLike = await ImageLike.post(new ImageLike(this.id, userId));
        if (imageLike != undefined) {
            this.likes.push(imageLike);
        }
    }

    public async removeLike(userId: string): Promise<void> {
        const imageLike = await ImageLike.delete(new ImageLike(this.id, userId));
        if (imageLike != undefined) {
            this.likes.splice(this.likes.findIndex(likeToRemove => likeToRemove.ImageId == imageLike.ImageId && likeToRemove.UserId == imageLike.UserId), 1);
        }
    }
}