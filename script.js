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

const focusLabels = {
  strategy: 'Product & Portfolio Strategy',
  creative: 'Creative & Brand Voice',
  technical: 'Technical & B2B Enablement'
};

const focusMode = new URLSearchParams(window.location.search).get('focus');

if (Object.hasOwn(focusLabels, focusMode)) {
  document.body.dataset.focusMode = focusMode;

  document.querySelectorAll('[data-focus-section]').forEach(section => {
    const modes = section.dataset.focus?.split(/\s+/) ?? [];
    section.hidden = !modes.includes(focusMode);
  });

  const focusStatus = document.querySelector('.focus-status');
  const focusName = document.querySelector('[data-focus-name]');
  focusStatus.hidden = false;
  focusName.textContent = focusLabels[focusMode];

  document.querySelector(`[data-focus-route="${focusMode}"]`)?.setAttribute('aria-current', 'page');
}
