import { helper } from '@ember/component/helper';
import { htmlSafe, isHTMLSafe } from '@ember/template';

const _htmlSafe = function ([html]: [string]) {
  if (isHTMLSafe(html)) {
    html = html.toString();
  }

  html = html || '';
  return htmlSafe(html);
};

export default helper(_htmlSafe);
