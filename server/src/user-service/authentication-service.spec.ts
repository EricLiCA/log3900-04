import { expect } from 'chai';
import { AuthenticationService, secretLength } from './authentication-service';

describe ('AuthenticationService', () => {

    const authenticationService = AuthenticationService.instance;

    it ('should instantiate correctly', () => {
        // tslint:disable-next-line
        const secret = authenticationService['secret'];
        expect(secret.length).to.equal(secretLength);
    });

    describe ('hashPassword()', () => {

        it ('should generate a hash for any given password', async () => {
            await authenticationService.hashPassword('password').then((hash) => {
                expect(hash).to.not.equal(undefined);
            }, (onrejected) => {
                expect.fail(null, null, onrejected);
            }).catch((error) => {
                expect.fail(null, null, error.message);
            });
        });
    });

    describe ('validateCredentials()', () => {

        it ('should correctly validate credentials', async () => {
            await authenticationService.validateCredentials('email@email.com', 'LOG3900').then((approved) => {
                expect(approved).to.equal(true);
            }, (onrejected) => {
                expect.fail(null, null, onrejected);
            }).catch((error) => {
                expect.fail(null, null, error.message);
            });
        });
    });

    describe ('generateJsonwebtoken()', () => {

        it ('should generate a jsonwebtoken', async () => {
            await authenticationService.generateJsonwebtoken('email@email.com').then((token) => {
                expect(token).to.not.equal(undefined);
            }, (onrejected) => {
                expect.fail(null, null, onrejected);
            }).catch((error) => {
                expect.fail(null, null, error.message);
            });
        });
    });

    describe ('validateJsonwebtoken()', () => {

        it ('should validate a jsonwebtoken', async () => {
            let token;
            await authenticationService.generateJsonwebtoken('email@email.com').then((response) => {
                token = response;
            });
            await authenticationService.validateJsonwebtoken(token).then((payload) => {
                expect(payload).to.equal('email@email.com');
            }, (onrejected) => {
                expect.fail(null, null, onrejected);
            }).catch((error) => {
                expect.fail(null, null, error.message);
            });
        });
    });
});
