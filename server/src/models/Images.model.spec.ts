import { ImagesModel } from './Images.model';

import { User } from './User';

import { expect } from 'chai';

let user: User;
let user2: User;
let image: ImagesModel;

const username = 'images_testUsername';
const username2 = 'images_testUsername2';
const password = 'test';

const title = 'images_testTitle';

describe('ImagesModel', () => {
    before(async () => {
        user = await User.create(username, password);
        user2 = await User.create(username2, password);
    });

    after(async () => {
        await User.delete(user.Id);
        await User.delete(user2.Id);
    });

    it('should create an image', async () => {
        image = await ImagesModel.create(
            user.Id,
            title,
            undefined,
            undefined,
            undefined,
            undefined,
        );
        expect(image.OwnerId).to.equal(user.Id);
    });

    it('should get images created by the owner', async () => {
        const images = await ImagesModel.getByOwnerId(user.Id);
        expect(images).length.to.be.greaterThan(0);
        expect(images[0].OwnerId).to.equal(user.Id);
    });

    it('should transfer ownership of the image', async () => {
        const image2 = await ImagesModel.update(
            image.Id,
            user2.Id,
            undefined,
            undefined,
            undefined,
            undefined,
            undefined,
        );
        expect(image2.OwnerId).to.equal(user2.Id);
        const images = await ImagesModel.getByOwnerId(user.Id);
        expect(images).to.eql([]);
    });

    it('should get all the images', async () => {
        const images = await ImagesModel.getAll();
        expect(images).length.to.be.greaterThan(0);
    });

    it('should delete the image', async () => {
        const deletedImage = await ImagesModel.delete(image.Id);
        expect(deletedImage.Id).to.equal(image.Id);
        expect(deletedImage.OwnerId).to.equal(user2.Id);
    });
});
