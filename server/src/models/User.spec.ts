import { User } from './User';

import { expect } from 'chai';

describe('User', () => {
    describe('getAll', () => {
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

    describe('get (by id)', () => {
        it('should return the user "polypaint"', (done) => {
            User.get('556722f1-1051-438c-9046-2d220c273f91').then((result) => {
                console.log(result);
                expect(result.Id).to.equal('556722f1-1051-438c-9046-2d220c273f91');
                expect(result.UserLevel).to.equal('admin');
                expect(result.Username).to.equal('polypaintpro');
                done();
            })
                .catch((err) => {
                    expect(false);
                });
        });
    });
});
