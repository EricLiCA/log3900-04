import { User } from './User';

import { expect } from 'chai';

describe('User', () => {
    let username: string = '123testUser';
    let password: string = '321testPassword';
    let id: string;
    let userLevel: string;
    let profileImage: string;

    it('should create a user with the username and password provided', (done) => {
        User.create(username, password).then((result) => {
            expect(result.Username).to.equal(username);
            expect(result.Password).to.equal(password);
            expect(result.ProfileImage).to.equal(
                // tslint:disable-next-line:max-line-length
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSjqmTWoUhezVh6rd7F0DYqkpqDGAwbYoC_hEfi0nphYL1h08gCkA',
            );
            id = result.Id;
            userLevel = result.UserLevel;
            profileImage = result.ProfileImage;
            done();
        });
    });

    it('should return the previously created user', (done) => {
        User.get(id).then((result) => {
            expect(result.Id).to.equal(id);
            expect(result.UserLevel).to.equal(userLevel);
            expect(result.Username).to.equal(username);
            expect(result.ProfileImage).to.equal(profileImage);
            done();
        })
            .catch((err) => {
                expect(false);
            });
    });

    it('should update the username of the previously created user', (done) => {
        username = '456testUser';
        User.update(id, username, undefined, undefined, undefined).then((result) => {
            expect(result.Id).to.equal(id);
            expect(result.Username).to.equal(username);
            done();
        });
    });

    it('should update the password, userLevel, and profileImage of the user', (done) => {
        password = '654testPassword';
        userLevel = 'admin';
        profileImage = 'http://placekitten.com/200/300';
        User.update(id, undefined, password, userLevel, profileImage).then((result) => {
            expect(result.Id).to.equal(id);
            expect(result.UserLevel).to.equal(userLevel);
            expect(result.Username).to.equal(username);
            expect(result.ProfileImage).to.equal(profileImage);
            done();
        });
    });

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

    it('should delete the previously created user', (done) => {
        User.delete(id).then((result) => {
            expect(result.Username).to.equal(username);
            expect(result.Password).to.equal(password);
            expect(result.Id).to.equal(id);
            expect(result.ProfileImage).to.equal(profileImage);
            done();
        });
    });
});
