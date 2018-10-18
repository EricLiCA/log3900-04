import { ImagesModel } from './Images.model';

import { expect } from 'chai';

describe('ImagesModel', () => {
    it('get all the images', async () => {
        const images = await ImagesModel.getAll();
        expect(images).length.to.be.greaterThan(0);
    });
});
