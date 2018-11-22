import { PostgresDatabase } from '../postgres-database';

export class ImageLike {

    public static async post(imageLike: ImageLike): Promise<ImageLike> {
        const db = await PostgresDatabase.getInstance();
        const queryResponse = await db.query(
            'INSERT INTO ImageLikes("ImageId", "UserId") VALUES($1, $2) RETURNING *',
            [imageLike.ImageId, imageLike.UserId],
        )
        if (queryResponse.rowCount > 0) {
            const row = queryResponse.rows[0];
            return Promise.resolve(new ImageLike(
                row.ImageId,
                row.UserId
            ));
        } else {
            return Promise.resolve(undefined);
        }
    }

    public static async get(imageId: string): Promise<ImageLike[]> {
        const db = await PostgresDatabase.getInstance();
        const queryResponse = await db.query('SELECT * FROM ImageLikes WHERE "ImageId" = $1', [imageId]);
        if (queryResponse.rowCount > 0) {
            return Promise.resolve(queryResponse.rows.map((row) => {
                return new ImageLike(
                    row.ImageId,
                    row.UserId
                );
            }));
        } else {
            return Promise.resolve(undefined);
        }
    }

    public static async delete(imageLike: ImageLike): Promise<ImageLike> {
        const db = await PostgresDatabase.getInstance();
        const queryResponse = await db.query('DELETE FROM ImageLikes WHERE "ImageId" = $1 and "UserId" = $2 RETURNING *', [imageLike.ImageId, imageLike.UserId]);
        if (queryResponse.rowCount > 0) {
            const row = queryResponse.rows[0];
            return Promise.resolve(new ImageLike(
                row.ImageId,
                row.UserId
            ));
        }
        else {
            return Promise.resolve(undefined);
        }
    }

    public ImageId: string;
    public UserId: string;

    public constructor(imageId: string, userId: string) {
        this.ImageId = imageId;
        this.UserId = userId;
    }

}
