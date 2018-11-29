import { Component, OnInit, Inject, ViewChild, ElementRef } from '@angular/core';
import { AuthenticationService } from 'src/admin/login.service';
import { MatDialog, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';
import { LikesAndCommentsService } from '../../services/likes-and-comments.service';
import { Image } from '../Image';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'image-preview-component',
  templateUrl: './image-preview.component.html',
  styleUrls: ['./image-preview.component.scss']
})
export class ImagePreviewComponent implements OnInit {

  @ViewChild('shareInput') shareInput: ElementRef;

  private _comment: string;
  get comment(): string {
    return this.isConnected ? this._comment : "Must be logged in to comment";
  }
  set comment(value: string) {
    this._comment = value;
  }

  private shareLink: string = "";
  private _askedForShareLink: boolean = false;
  get askedForShareLink(): boolean {
    return this._askedForShareLink;
  }
  set askedForShareLink(value: boolean) {
    this._askedForShareLink = value;
    this.http.get(`http://ec2-34-200-247-233.compute-1.amazonaws.com/v2/secret/generate/${this.image.id}`).toPromise().then(
            value => {
                this.shareLink = "http://localhost:4200/secret/" + value.toString();
            },
            rejectedReason => {
                this.shareLink = "http://localhost:4200/secret/" + rejectedReason.error['text'];
            }
        );
  }

  copyToClipboard(): void {
    this.shareInput.nativeElement.focus();
    this.shareInput.nativeElement.select();
    document.execCommand('copy');
  }

  constructor(@Inject(MAT_DIALOG_DATA) public image: Image,
    private likesAndCommentsService: LikesAndCommentsService,
    private authenticationService: AuthenticationService,
    private http: HttpClient) {
    this._comment = "";
  }

  /** GET images from the server */
  ngOnInit() {
  }

  public get isConnected(): boolean {
    return this.authenticationService.loggedIn;
  }

  public get isMine(): boolean {
    return this.authenticationService.user.id == this.image.ownerId;
  }

  addComment(): void {
    this.likesAndCommentsService.addComment(this.authenticationService.user.id,
      this._comment,
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
    if (!this.isConnected) return false;

    let liked = false;
    this.likesAndCommentsService.likes.forEach(like => {
      if (like.UserId == this.authenticationService.user.id){
        liked = true;
      }
    });
    return liked;
  }


}
