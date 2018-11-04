import { Component } from '@angular/core';
import { UserService } from '../services/user.service';
import { User } from './User';
import { ActivatedRoute, Router } from '@angular/router';

@Component({
  selector: 'users-component',
  templateUrl: './users.component.html',
  styleUrls: ['./users.component.scss']
})

export class UsersComponent {
  
  private date: Date = new Date();
  private route: ActivatedRoute;
  private users: User[];
  private userImages: String[];
  private userId: Number;

  constructor(
    private router: Router,
    private userService: UserService
  ) { }

  /** GET images from the server */
  ngOnInit() {
    this.userService.getUsers().then(result => {
      this.users = result;
    });
  }
}
