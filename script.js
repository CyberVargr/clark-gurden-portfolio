const toggle = document.querySelector('.nav-toggle');
const nav = document.querySelector('#site-nav');

toggle?.addEventListener('click', () => {
  const open = toggle.getAttribute('aria-expanded') === 'true';
  toggle.setAttribute('aria-expanded', String(!open));
  nav.classList.toggle('open', !open);
});

nav?.addEventListener('click', event => {
  if (event.target.matches('a')) {
    toggle?.setAttribute('aria-expanded', 'false');
    nav.classList.remove('open');
  }
});

document.addEventListener('keydown', event => {
  if (event.key === 'Escape' && nav?.classList.contains('open')) {
    nav.classList.remove('open');
    toggle?.setAttribute('aria-expanded', 'false');
    toggle?.focus();
  }
});

document.querySelector('#year').textContent = new Date().getFullYear();
