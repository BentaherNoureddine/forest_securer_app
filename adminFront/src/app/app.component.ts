import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet],
  template:`
    <main>
      <header class="brand-name">
        <img class="brand-logo" src="/assets/forest_logo.png" alt="logo" aria-hidden="true">
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
