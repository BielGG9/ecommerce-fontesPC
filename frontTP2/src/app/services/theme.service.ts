import { Injectable, signal } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class ThemeService {
  private readonly THEME_KEY = 'admin-dark-mode';

  // Read initial value from localStorage
  isDarkMode = signal<boolean>(localStorage.getItem(this.THEME_KEY) === 'true');

  toggleTheme(): void {
    const nextValue = !this.isDarkMode();
    this.isDarkMode.set(nextValue);
    localStorage.setItem(this.THEME_KEY, String(nextValue));
  }

  setTheme(isDark: boolean): void {
    this.isDarkMode.set(isDark);
    localStorage.setItem(this.THEME_KEY, String(isDark));
  }
}
