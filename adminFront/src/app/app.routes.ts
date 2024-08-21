import { Routes } from '@angular/router';
import {LoginComponent} from "./login/login.component";

export const routeConfig: Routes = [
  {
     path :'',
     component: LoginComponent,
     title : 'Login Page',

  },

];

export default routeConfig;
