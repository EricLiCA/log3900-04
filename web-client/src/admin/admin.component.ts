import { Component } from '@angular/core';
import { AuthenticationService } from './login.service';
import { UserService } from 'src/services/user.service';
import { User } from 'src/users/User';

@Component({
  selector: 'admin-component',
  templateUrl: './admin.component.html',
  styleUrls: ['./admin.component.scss']
})
export class AdminComponent {

  private management = this.authenticationService.management;
  private permission = this.authenticationService.permission;
  private radioData: string;
  private admin = this.authenticationService.admin;
  private users: User[] = [];
  constructor(private authenticationService: AuthenticationService,
              private userService: UserService) {
  }

  ngOnInit() {
    this.userService.getUsers().then(users => {
      this.users = users;
    });
    this.radioData = "admin";
  }

  protected getRadioValue(s: string): void {
    this.radioData = s;
  }

  protected changeAccount(newUsername: String, newPassword: String, password: String): void {
    if(newUsername.length > 0){
        this.authenticationService.changeUsername(newUsername, password);
    }
    if(newPassword.length > 0){
        this.authenticationService.changPassword(password, newPassword);
    }
  }

  protected createAccount(accountName: String, password1: String, password2: String): void {
    if((this.management ||this.admin) && accountName.length > 0 && password1.length > 0 && password1 == password2){
        this.authenticationService.createUser(accountName, password1);
    }
  }

  protected deleteAccount(accountName: String): void {
    if((this.management ||this.admin) && accountName.length > 0){
      let userToDelete: String;
      this.users.forEach((user: User) => {
        if(user.username === accountName) {
          userToDelete = user.id;
        }
      });
      this.authenticationService.deleteUser(userToDelete);
    }
  }

  protected changePermissions(accountName: String): void {
    if((this.permission || this.admin) && accountName.length > 0){
      let userToChange: User;
      this.users.forEach((user: User) => {
        if(user.username === accountName) {
          userToChange = user;
        }
      });
      userToChange.userLevel = this.radioData;
      this.authenticationService.changeUserPermissions(userToChange);
    }
  }
}
