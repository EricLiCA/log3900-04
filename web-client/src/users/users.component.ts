import { Component } from '@angular/core';
import { UserService } from '../services/user.service';
import { User } from './User';
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'users-component',
  templateUrl: './users.component.html',
  styleUrls: ['./users.component.scss']
})

export class UsersComponent {
  
  private route: ActivatedRoute;
  private users: User[];
  private userImages: String[];

  constructor(
    private userService: UserService
  ) { }

  /** GET images from the server */
  ngOnInit() {
    this.userService.getUsers().then(result => {
      this.users = result;
    });
  }

  userOnClic(user) {
    this.userService.getUserImages(user.id).then(result => {
      this.userImages = result;
    });
  }
}
