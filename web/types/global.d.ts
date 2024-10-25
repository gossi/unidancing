// Types for compiled templates
declare module '@unidancing/app/templates/*' {
  import type { TemplateFactory } from 'htmlbars-inline-precompile';

  const tmpl: TemplateFactory;

  export default tmpl;
}
