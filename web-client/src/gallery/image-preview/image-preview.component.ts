import { Component, OnInit, Inject } from '@angular/core';
import { AuthenticationService } from 'src/admin/login.service';
import { MatDialog, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';
import { LikesAndCommentsService } from '../../services/likes-and-comments.service';

@Component({
  selector: 'image-preview-component',
  templateUrl: './image-preview.component.html',
  styleUrls: ['./image-preview.component.scss']
})
export class ImagePreviewComponent implements OnInit {

  comment: string;
  constructor(@Inject(MAT_DIALOG_DATA) public image,
    private likesAndCommentsService: LikesAndCommentsService,
    private authenticationService: AuthenticationService) {
    this.comment = "";
  }

  /** GET images from the server */
  ngOnInit() {
  }

  addComment(): void {
    this.likesAndCommentsService.addComment(this.authenticationService.user.id,
      this.comment,
      this.authenticationService.user.userName,
      this.authenticationService.user.profileImage);
  }

  addLike(): void {
    this.likesAndCommentsService.addLike(this.authenticationService.user.id);
  }

  removeLike(): void {
    this.likesAndCommentsService.removeLike(this.authenticationService.user.id);
  }

  isLiked(): boolean {
    let liked = false;
    this.likesAndCommentsService.likes.forEach(like => {
      if (like.UserId == this.authenticationService.user.id){
        liked = true;
      }
    });
    return liked;
  }


}
