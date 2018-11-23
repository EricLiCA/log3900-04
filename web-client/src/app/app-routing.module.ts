import { Routes, RouterModule } from '@angular/router';
import { NgModule, Component } from '@angular/core';
import { AdminComponent } from '../admin/admin.component';
import { GalleryComponent } from '../gallery/gallery.component';
import { UsersComponent } from '../users/users.component';
import { UsersDetailComponent } from 'src/users/userDetail/usersDetail.component';
import { SecretComponent } from 'src/secret/secret.component';

const appRoutes: Routes = [
    { path: 'gallery', component: GalleryComponent },
    { path: 'users', component: UsersComponent },
    { path: 'admin', component: AdminComponent },
    { path: 'secret/:secret', component: SecretComponent },
    { path: '', redirectTo: '/gallery', pathMatch: 'full' },
    { path: 'userDetail/:id', component: UsersDetailComponent },
    { path: '**', redirectTo: '/gallery' }
];

@NgModule({
    imports: [
        RouterModule.forRoot(appRoutes)
    ],
    exports: [RouterModule]
})
export class AppRoutingModule {

}
