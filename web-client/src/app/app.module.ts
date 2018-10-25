import { BrowserModule } from '@angular/platform-browser';
import { MDBBootstrapModulesPro } from 'ng-uikit-pro-standard';
import { MDBSpinningPreloader } from 'ng-uikit-pro-standard';
import { NgModule } from '@angular/core';

import { AppComponent } from './app.component';
import { GalleryComponent } from '../gallery/gallery.component';
import { UsersComponent } from '../users/users.component';
import { AdminComponent } from '../admin/admin.component';

@NgModule({
  declarations: [
    AppComponent,
    GalleryComponent,
    UsersComponent,
    AdminComponent,
  ],
  imports: [
    BrowserModule,
    MDBBootstrapModulesPro.forRoot(),
  ],
  providers: [
    MDBSpinningPreloader,
  ],
  bootstrap: [
    AppComponent
  ]
})
export class AppModule { }
