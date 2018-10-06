import { expect } from 'chai';
import { spy } from 'sinon';
import { User } from './user';

describe('User', () => {

    const randomStub = spy( Math, 'random');

    beforeEach(() => {
        randomStub.resetHistory();
    });

    after(() => {
        randomStub.restore();
    });

    describe('if the user is authenticated', () => {

        it('should not instantiate if email is not specified', () => {
            expect( () => {
                // tslint:disable-next-line
                new User(true);
            }).to.throw( Error );
        });

        it('should instantiate correctly', () => {

            const user = new User(true, 'email@email.com');
            expect(user.email).to.equal('email@email.com');
            // expect(user.id)   /* WILL BE CHECKED ONCE DATABASE FETCHING IS IMPLEMENTED */
            // expect(user.name) /* WILL BE CHECKED ONCE DATABASE FETCHING IS IMPLEMENTED */
        });
    });

    describe('if the user is not authenticated', () => {

        it('should instantiate correctly', () => {
            const user = new User(false);
            const randomNumber = randomStub.firstCall.returnValue;
            expect(user.email).to.equal(undefined);
            expect(user.name).to.equal(`Anonymous #${Math.ceil(randomNumber * 10000)}`);
        });
    });

    describe('connect()', () => {

        it('should connect the user', () => {
            const user = new User(false);
            expect(user.email).to.equal(undefined);

            user.connect('email@email.com');

            expect(user.email).to.equal('email@email.com');
            // expect(user.id)   /* WILL BE CHECKED ONCE DATABASE FETCHING IS IMPLEMENTED */
            // expect(user.name) /* WILL BE CHECKED ONCE DATABASE FETCHING IS IMPLEMENTED */
        });
    });
});
