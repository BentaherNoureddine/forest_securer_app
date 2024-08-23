import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import {NgOptimizedImage} from "@angular/common";

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet, NgOptimizedImage],
  template:`
    <main>
      <header class="brand-name">
        <img class="brand-logo" src="../assets/example-house.jpg" alt="logo">

      </header>
      <section class="content">
        <router-outlet></router-outlet>
      </section>
    </main>`,
  styleUrl: './app.component.css'
})
export class AppComponent {
  title = 'adminFront';
}
