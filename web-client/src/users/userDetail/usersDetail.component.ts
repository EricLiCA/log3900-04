import { Component, Input } from '@angular/core';
import { UserService } from '../../services/user.service';
import { ActivatedRoute, ParamMap } from '@angular/router';
import { Observable } from 'rxjs';
import { Image } from 'src/gallery/Image';
import { User } from '../User';

@Component({
  selector: 'usersDetail-component',
  templateUrl: './usersDetail.component.html',
  styleUrls: ['./usersDetail.component.scss']
})

export class UsersDetailComponent {
  
  private date: Date = new Date();
  private userImages: Image[];
  private currentUser: User;

  constructor(
    private route: ActivatedRoute,
    private userService: UserService
  ) { }

  /** GET images from the server */
  ngOnInit() {
    const id = this.route.snapshot.paramMap.get('id');
    this.userService.getUserImages(id).then((imageUrls: Image[]) => {
      this.userImages = imageUrls;
    });

    this.userService.getUserById(id).then((user: User) => {
      this.currentUser = user;
    })

  }
}
