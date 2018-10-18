CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

create type imageprotection as enum ('public', 'protected', 'private')
;

create type userpermissionlevel as enum ('admin', 'user')
;

create table if not exists users
(
	"Id" uuid default uuid_generate_v4() not null
		constraint "pk_User"
			primary key,
	"Username" varchar(32) not null
		constraint "uc_User_Username"
			unique,
	"Password" varchar(200) not null,
	"UserLevel" userpermissionlevel default 'user'::userpermissionlevel not null
)
;

create table if not exists images
(
	"Id" uuid default uuid_generate_v1() not null
		constraint "pk_Image"
			primary key,
	"OwnerId" uuid not null
		constraint "fk_Image_OwnerId"
			references users,
	"Title" varchar(128) not null,
	"ProtectionLevel" imageprotection default 'private'::imageprotection not null,
	"Password" varchar(32),
	"ThumbnailUrl" varchar(128),
	"FullImageUrl" varchar(128)
)
;

create table if not exists pending_friend_requests
(
	"RequesterId" uuid not null
		constraint "fk_PendingFriendRequest_RequesterId"
			references users,
	"ReceiverId" uuid not null
		constraint "fk_PendingFriendRequest_ReceiverId"
			references users,
	"Notified" boolean default false not null,
	constraint "pk_PendingFriendRequest"
		primary key ("RequesterId", "ReceiverId")
)
;

create table if not exists friendships
(
	"UserId" uuid not null
		constraint "fk_Friendship_UserId"
			references users,
	"FriendId" uuid not null
		constraint "fk_Friendship_FriendId"
			references users,
	constraint "pk_Friendship"
		primary key ("UserId", "FriendId")
)
;

create table if not exists image_likes
(
	"ImageId" uuid not null
		constraint "fk_ImageLike_ImageId"
			references images,
	"UserId" uuid not null
		constraint "fk_ImageLike_UserId"
			references users,
	constraint "pk_ImageLike"
		primary key ("ImageId", "UserId")
)
;

create table if not exists image_comments
(
	"ImageId" uuid not null
		constraint "fk_ImageComment_ImageId"
			references images,
	"UserId" uuid not null
		constraint "fk_ImageComment_UserId"
			references users,
	"Timestamp" timestamp default now() not null,
	"Comment" varchar(512) not null,
	constraint "pk_ImageComment"
		primary key ("ImageId", "UserId", "Timestamp")
)
;

create table if not exists sessions
(
	userid uuid not null
		constraint sessions_pkey
			primary key
		constraint sessions_users_id_fk
			references users
				on delete cascade,
	token uuid default uuid_generate_v4() not null
)
;

create unique index if not exists sessions_userid_uindex
	on sessions (userid)
;