import {Category} from "./Category";

export interface Report {

   id: number  ;
   category: string;
   title: string;
   address: string;
   description: string;
   reporterId: string;
   imagePath: string;
   location: string;
   created_at: string;
}
