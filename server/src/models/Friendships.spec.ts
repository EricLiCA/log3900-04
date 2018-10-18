import { Friendships } from './Friendships';

import { expect } from 'chai';

describe('Friendships', () => {
    it('should get all the friends of a user', (done) => {
        const user = '442512be-d5c2-4d70-963e-1e0451cf2e80';
        Friendships.get(user).then((result) => {
            expect(result.userId).to.equal(user);
            expect(result.friends).length.to.be.greaterThan(0);
            done();
        });
    });
});
