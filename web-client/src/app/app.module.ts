import { BrowserModule } from '@angular/platform-browser';
import { MDBBootstrapModulesPro } from 'ng-uikit-pro-standard';
import { MDBSpinningPreloader } from 'ng-uikit-pro-standard';
import { NgModule } from '@angular/core';
import { HttpClientModule } from '@angular/common/http';

import { AppComponent } from './app.component';
import { GalleryComponent } from '../gallery/gallery.component';
import { UsersComponent } from '../users/users.component';
import { AdminComponent } from '../admin/admin.component';
import { AppRoutingModule } from './app-routing.module';
import { AuthenticationService } from '../admin/login.service';
import { ReactiveFormsModule, FormsModule } from '@angular/forms';
import { UsersDetailComponent } from 'src/users/userDetail/usersDetail.component';
import { FilterPipe } from 'src/services/filter.pipe';

@NgModule({
  declarations: [
    AppComponent,
    GalleryComponent,
    UsersComponent,
    AdminComponent,
    UsersDetailComponent,
    FilterPipe
  ],
  imports: [
    BrowserModule,
    HttpClientModule,
    MDBBootstrapModulesPro.forRoot(),
    AppRoutingModule,
    ReactiveFormsModule,
    FormsModule 
  ],
  providers: [
    MDBSpinningPreloader,
    AuthenticationService,
  ],
  bootstrap: [
    AppComponent
  ]
})
export class AppModule { }
