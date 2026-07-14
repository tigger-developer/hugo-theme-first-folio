// ABOUTME: Lets pointer users re-conceal a revealed block spoiler by clicking its text.
// ABOUTME: Interactive descendants remain operable; native checkbox controls handle all other input.

document.addEventListener('click', (event) => {
  if (!(event.target instanceof Element)) {
    return;
  }

  const content = event.target.closest('.spoiler--block > .spoiler__content');
  if (!content || event.target.closest('a, button, input, label, select, textarea')) {
    return;
  }

  const spoiler = content.closest('.spoiler--block');
  const toggle = spoiler?.querySelector(':scope > .spoiler__toggle');
  if (!(toggle instanceof HTMLInputElement) || !toggle.checked) {
    return;
  }

  toggle.checked = false;
  toggle.focus();
});
