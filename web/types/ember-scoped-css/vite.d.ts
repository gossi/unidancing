declare module 'ember-scoped-css/vite' {
  import type { Plugin } from 'vite';

  export function scopedCSS(options?: {
    layerName?: string;
    additionalRoots?: string[];
    [option: string]: unknown;
  }): Plugin[];
}
