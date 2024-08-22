import { Routes } from '@angular/router';
import {LoginComponent} from "./login/login.component";
import {ReportsComponent} from "./reports/reports.component";
import {HomeComponent} from "./home/home.component";

export const routeConfig: Routes = [
  {
     path :'',
     component: HomeComponent,
     title : 'Reports Page',

  },

];

export default routeConfig;
