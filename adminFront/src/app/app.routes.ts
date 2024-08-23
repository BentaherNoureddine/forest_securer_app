import { Routes } from '@angular/router';
import {HomeComponent} from "./home/home.component";
import {ReportsDetailsComponent} from "./reports-details/reports-details.component";

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

];

export default routeConfig;
