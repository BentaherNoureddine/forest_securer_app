import { Routes } from '@angular/router';
import {HomeComponent} from "./home/home.component";
import {ReportsDetailsComponent} from "./reports-details/reports-details.component";
import {LoginComponent} from "./login/login.component";

export const routeConfig: Routes = [
  {
     path :'',
     component: HomeComponent,
     title : 'Reports Page',

  },
  {
    path : 'details/:id',
    component: ReportsDetailsComponent,
    title : 'Details Page'
  },
  {
    path : 'login',
    component: LoginComponent,
    title : 'Login Page'
  },



];

