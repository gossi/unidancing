import { modifier } from 'ember-modifier';

const selectWhenFocus = modifier((element: HTMLInputElement | HTMLTextAreaElement) => {
  const handler = () => {
    window.setTimeout(() => element.setSelectionRange(0, element.value.length), 0);
  };

  element.addEventListener('focus', handler);

  return () => {
    element.removeEventListener('focus', handler);
  };
});

async function copyToClipboard(text: string) {
  await window.navigator.clipboard.writeText(text);
}

export { copyToClipboard, selectWhenFocus };
