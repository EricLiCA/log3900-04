import { User } from './User';

import { expect } from 'chai';

describe('User', () => {
    it('should return all users', (done) => {
        User.getAll().then((results) => {
            expect(results).length.to.be.greaterThan(0);
            expect(results[0].Id).to.not.be.empty;
            expect(results[0].Password).to.not.be.empty;
            expect(results[0].ProfileImage).to.not.be.empty;
            expect(results[0].UserLevel).to.not.be.empty;
            expect(results[0].Username).to.not.be.empty;
            done();
        })
            .catch((err) => {
                expect(false).to.be.true;
            });
    });
});
