import { Component } from '@angular/core';
import { AuthenticationService } from '../admin/login.service';
import { FormControl, Validators } from '@angular/forms';
import { Credentials } from 'src/admin/credentials';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {
  
  private avatar = "https://npengage.com/wp-content/plugins/all-in-one-seo-pack/images/default-user-image.png";
  loginFormModalUsername = new FormControl('', Validators.required);
  loginFormModalPassword = new FormControl('', Validators.required);
  
  protected get authenticated(): boolean {
    return this.authenticationService.loggedIn;
  }

  constructor(private authenticationService: AuthenticationService) {

  }

  protected logout():void{
    window.location.reload();
  }

  protected authenticate(username: String, password: String): void {
    this.authenticationService.authenticate(username, password).then((credentials: Credentials) => {
      this.avatar = credentials.profileImage.toString();
    });
  }

}
