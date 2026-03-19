/**
 * BolgWeb – main.js
 * Handles: dark/light theme, search & filter, back-to-top, reading progress
 */

(function () {
  'use strict';

  /* ── Theme Toggle ─────────────────────────────────── */
  const THEME_KEY = 'blogweb-theme';

  function getTheme() {
    const saved = localStorage.getItem(THEME_KEY);
    if (saved) return saved;
    return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
  }

  function applyTheme(theme) {
    document.documentElement.setAttribute('data-theme', theme);
    const btn = document.getElementById('theme-toggle');
    if (btn) btn.textContent = theme === 'dark' ? '☀️' : '🌙';
  }

  function toggleTheme() {
    const current = document.documentElement.getAttribute('data-theme') || 'light';
    const next = current === 'dark' ? 'light' : 'dark';
    localStorage.setItem(THEME_KEY, next);
    applyTheme(next);
  }

  applyTheme(getTheme());

  document.addEventListener('DOMContentLoaded', function () {

    /* ── Theme button ──────────────────────────────── */
    const themeBtn = document.getElementById('theme-toggle');
    if (themeBtn) themeBtn.addEventListener('click', toggleTheme);

    /* ── Back-to-top button ────────────────────────── */
    const backTop = document.getElementById('back-top');
    if (backTop) {
      window.addEventListener('scroll', function () {
        backTop.classList.toggle('visible', window.scrollY > 300);
      });
      backTop.addEventListener('click', function () {
        window.scrollTo({ top: 0, behavior: 'smooth' });
      });
    }

    /* ── Reading-progress bar ──────────────────────── */
    const readBar = document.getElementById('read-progress');
    if (readBar) {
      window.addEventListener('scroll', function () {
        const scrollTop = window.scrollY;
        const docHeight = document.documentElement.scrollHeight - window.innerHeight;
        const pct = docHeight > 0 ? (scrollTop / docHeight) * 100 : 0;
        readBar.style.width = pct.toFixed(2) + '%';
      });
    }

    /* ── Post search & tag filter (index page) ─────── */
    const searchInput = document.getElementById('search-input');
    const tagButtons  = document.querySelectorAll('.tags-bar .tag');
    const postCards   = document.querySelectorAll('.post-item');
    const noResults   = document.getElementById('no-results');

    let activeTag = 'all';
    let searchQuery = '';

    function filterPosts() {
      let visible = 0;
      postCards.forEach(function (card) {
        const title   = (card.dataset.title   || '').toLowerCase();
        const excerpt = (card.dataset.excerpt || '').toLowerCase();
        const tags    = (card.dataset.tags    || '').toLowerCase();

        const matchesSearch = !searchQuery ||
          title.includes(searchQuery) ||
          excerpt.includes(searchQuery) ||
          tags.includes(searchQuery);

        const matchesTag = activeTag === 'all' || tags.includes(activeTag);

        if (matchesSearch && matchesTag) {
          card.style.display = '';
          visible++;
        } else {
          card.style.display = 'none';
        }
      });

      if (noResults) {
        noResults.style.display = visible === 0 ? 'block' : 'none';
      }
    }

    if (searchInput) {
      searchInput.addEventListener('input', function () {
        searchQuery = this.value.trim().toLowerCase();
        filterPosts();
      });
    }

    tagButtons.forEach(function (btn) {
      btn.addEventListener('click', function () {
        tagButtons.forEach(function (b) { b.classList.remove('active'); });
        btn.classList.add('active');
        activeTag = btn.dataset.tag || 'all';
        filterPosts();
      });
    });

    /* ── Animate skill bars (about page) ───────────── */
    const skillBars = document.querySelectorAll('.skill-progress');
    if (skillBars.length) {
      const observer = new IntersectionObserver(function (entries) {
        entries.forEach(function (entry) {
          if (entry.isIntersecting) {
            const bar = entry.target;
            bar.style.width = bar.dataset.width || '0%';
            observer.unobserve(bar);
          }
        });
      }, { threshold: 0.3 });

      skillBars.forEach(function (bar) { observer.observe(bar); });
    }

    /* ── Active nav link ───────────────────────────── */
    const currentPage = window.location.pathname.split('/').pop() || 'index.html';
    document.querySelectorAll('.nav-links a').forEach(function (link) {
      const href = link.getAttribute('href') || '';
      if (href === currentPage || (currentPage === '' && href === 'index.html')) {
        link.classList.add('active');
      }
    });

  });
})();
