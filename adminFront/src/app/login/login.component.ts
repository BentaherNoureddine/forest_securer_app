import {Component, inject} from '@angular/core';
import {FormsModule} from "@angular/forms";
import {ReportService} from "../service/report_service";
import {Router, RouterModule} from "@angular/router";

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [
    FormsModule,
    RouterModule
  ],
  templateUrl: './login.component.html',
  styleUrl: './login.component.css'
})
export class LoginComponent {
  email: string = '';
  password: string = '';

  constructor(private reportService: ReportService, private router: Router) {}

  login() {
    this.reportService.authenticate(this.email, this.password).subscribe(
      response => {
        if (response.status === 200) {
          console.log('Login successful');
          // Redirect or handle successful login
          this.router.navigate(['/dashboard']); // Example redirect to another route
        } else {
          console.log('Login failed');
        }
      },
      error => {
        console.error('Error during login', error);
      }
    );
  }
}
