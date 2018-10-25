import { Component } from '@angular/core';
import { AuthenticationService } from '../admin/login.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {
  
  protected get authenticated(): boolean {
    return this.authenticationService.loggedIn;
  }

  constructor(private authenticationService: AuthenticationService) {

  }

  protected authenticate(): void {
    this.authenticationService.authenticate('user', 'pass');
  }

}
