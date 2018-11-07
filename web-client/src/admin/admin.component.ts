import { Component } from '@angular/core';
import { AuthenticationService } from './login.service';

@Component({
  selector: 'admin-component',
  templateUrl: './admin.component.html',
  styleUrls: ['./admin.component.scss']
})
export class AdminComponent {

  private successUsername: Boolean;
  private successPassword: Boolean;

  constructor(private authenticationService: AuthenticationService) {
  }

  protected changeAccount(newUsername: String, newPassword: String, password: String): void {
    if(newUsername.length > 0){
        this.successUsername = this.authenticationService.changeUsername(newUsername, password);
    }
    if(newPassword.length > 0){
        this.successPassword = this.authenticationService.changPassword(password, newPassword);
    }
  }
}
