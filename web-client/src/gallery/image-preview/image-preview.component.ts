import { Component , OnInit, Inject } from '@angular/core';
import { AuthenticationService } from 'src/admin/login.service';
import {MatDialog, MatDialogRef, MAT_DIALOG_DATA} from '@angular/material';
import { LikesAndCommentsService } from '../../services/likes-and-comments.service';

@Component({
  selector: 'image-preview-component',
  templateUrl: './image-preview.component.html',
  styleUrls: ['./image-preview.component.scss']
})
export class ImagePreviewComponent implements OnInit {

  constructor(@Inject(MAT_DIALOG_DATA) public image, private likesAndCommentsService: LikesAndCommentsService) { }

  /** GET images from the server */
  ngOnInit()  {

  }
}
