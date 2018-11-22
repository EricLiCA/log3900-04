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
                row.Comment,
                row.Timestamp,
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
                    row.Comment,
                    row.Timestamp,
                    row.Username,
                    row.ProfileImage
                );
            }));
        } else {
            return Promise.resolve(undefined);
        }
    }

    public ImageId: string;
    public UserId: string;
    public Timestamp: Date;
    public Comment: string;
    public UserName: string;
    public ProfileImage: string;

    public constructor(imageId: string, userId: string, comment: string, timestamp?: Date, userName?: string, profileImage?: string) {
        this.ImageId = imageId;
        this.UserId = userId;
        this.Timestamp = timestamp;
        this.Comment = comment;
        this.UserName = userName;
        this.ProfileImage = profileImage;
    }
    
}
