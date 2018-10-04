-- Exported from QuickDBD: https://www.quickdatatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/schema/kdJL4nUy4U2Uu1hCryLe1w
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.

-- Modify this code to update the DB schema diagram.
-- To reset the sample schema, replace everything with
-- two dots ('..' - without quotes).

CREATE TABLE "Image" (
    "Id" UUID   NOT NULL,
    "OwnerId" UUID   NOT NULL,
    "Title" VARCHAR(128)   NOT NULL,
    "ProtectionType" Enum   NOT NULL,
    "Password" varchar(32)   NOT NULL,
    "ThumbnailUrl" VARCHAR(128)   NOT NULL,
    "FullImageUrl" VARCHAR(128)   NOT NULL,
    CONSTRAINT "pk_Image" PRIMARY KEY (
        "Id"
     )
);

CREATE TABLE "PendingFriendRequest" (
    "RequesterId" UUID   NOT NULL,
    "ReceiverId" UUID   NOT NULL,
    "Notified" BOOLEAN   NOT NULL,
    CONSTRAINT "pk_PendingFriendRequest" PRIMARY KEY (
        "RequesterId","ReceiverId"
     )
);

CREATE TABLE "Friendship" (
    "UserId" UUID   NOT NULL,
    "FriendId" UUID   NOT NULL,
    CONSTRAINT "pk_Friendship" PRIMARY KEY (
        "UserId","FriendId"
     )
);

-- Table documentation comment 1 (try the PDF/RTF export)
-- Table documentation comment 2
CREATE TABLE "User" (
    "Id" UUID   NOT NULL,
    -- Field documentation comment 3
    "Username" varchar(32)   NOT NULL,
    "Password" varchar(200)   NOT NULL,
    CONSTRAINT "pk_User" PRIMARY KEY (
        "Id"
     ),
    CONSTRAINT "uc_User_Username" UNIQUE (
        "Username"
    )
);

CREATE TABLE "ImageLike" (
    "ImageId" UUID   NOT NULL,
    "UserId" UUID   NOT NULL,
    CONSTRAINT "pk_ImageLike" PRIMARY KEY (
        "ImageId","UserId"
     )
);

CREATE TABLE "ImageComment" (
    "ImageId" UUID   NOT NULL,
    "UserId" UUID   NOT NULL,
    "Timestamp" Timestamp   NOT NULL,
    "Comment" VARCHAR(512)   NOT NULL,
    CONSTRAINT "pk_ImageComment" PRIMARY KEY (
        "ImageId","UserId","Timestamp"
     )
);

ALTER TABLE "Image" ADD CONSTRAINT "fk_Image_OwnerId" FOREIGN KEY("OwnerId")
REFERENCES "User" ("Id");

ALTER TABLE "PendingFriendRequest" ADD CONSTRAINT "fk_PendingFriendRequest_RequesterId" FOREIGN KEY("RequesterId")
REFERENCES "User" ("Id");

ALTER TABLE "PendingFriendRequest" ADD CONSTRAINT "fk_PendingFriendRequest_ReceiverId" FOREIGN KEY("ReceiverId")
REFERENCES "User" ("Id");

ALTER TABLE "Friendship" ADD CONSTRAINT "fk_Friendship_UserId" FOREIGN KEY("UserId")
REFERENCES "User" ("Id");

ALTER TABLE "Friendship" ADD CONSTRAINT "fk_Friendship_FriendId" FOREIGN KEY("FriendId")
REFERENCES "User" ("Id");

ALTER TABLE "ImageLike" ADD CONSTRAINT "fk_ImageLike_ImageId" FOREIGN KEY("ImageId")
REFERENCES "Image" ("Id");

ALTER TABLE "ImageLike" ADD CONSTRAINT "fk_ImageLike_UserId" FOREIGN KEY("UserId")
REFERENCES "User" ("Id");

ALTER TABLE "ImageComment" ADD CONSTRAINT "fk_ImageComment_ImageId" FOREIGN KEY("ImageId")
REFERENCES "Image" ("Id");

ALTER TABLE "ImageComment" ADD CONSTRAINT "fk_ImageComment_UserId" FOREIGN KEY("UserId")
REFERENCES "User" ("Id");

