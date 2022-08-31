import { Model as Base } from '@unidancing/database';

export class Model {
  id: string;
  title: string;
  excerpt: string;
  contents: string;

  constructor(base: Base) {
    this.id = base.id;
    this.title = base.title;
    this.excerpt = base.excerpt;
    this.contents = base.contents;
  }
}
