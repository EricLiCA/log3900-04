import { PostgresDatabase } from '../postgres-database';

export class ImageComment {

    public static async post(imageComment: ImageComment): Promise<ImageComment> {
        const db = await PostgresDatabase.getInstance();
        const queryResponse = await db.query(
            'INSERT INTO ImageComments("ImageId", "UserId", "Comment") VALUES($1, $2, $3) RETURNING *',
            [imageComment.ImageId, imageComment.UserId, imageComment.Comment],
        )
        if (queryResponse.rowCount > 0) {
            const row = queryResponse.rows[0];
            return Promise.resolve(new ImageComment(
                row.ImageId,
                row.UserId,
                row.Timestamp,
                row.Comment,
                null
            ));
        } else {
            return Promise.resolve(undefined);
        }
    }

    public static async get(imageId: string): Promise<ImageComment[]> {
        const db = await PostgresDatabase.getInstance();
        const queryResponse = await db.query('SELECT * FROM ImageComments INNER JOIN Users ON "UserId" = "Id" WHERE "ImageId" = $1 ORDER BY "Timestamp" desc', [imageId]);
        if (queryResponse.rowCount > 0) {
            return Promise.resolve(queryResponse.rows.map((row) => {
                return new ImageComment(
                    row.ImageId,
                    row.UserId,
                    row.Timestamp,
                    row.Comment,
                    row.Username,
                );
            }));
        } else {
            return Promise.resolve(undefined);
        }
    }

    public ImageId: string;
    public UserId: string;
    public Timestamp: Date;
    public Comment: Date;
    public UserName: string;

    public constructor(imageId: string, userId: string, timestamp: Date, comment: Date, userName: string) {
        this.ImageId = imageId;
        this.UserId = userId;
        this.Timestamp = timestamp;
        this.Comment = comment;
        this.UserName = userName;
    }
    
}
