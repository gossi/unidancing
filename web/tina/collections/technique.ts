import type { Collection } from 'tinacms';
import { LinksField } from '../-fields';

export const TechniqueCollection: Collection = {
  name: 'technique',
  label: 'Techniques',
  path: 'content/techniques',
  ui: {
    filename: {
      slugify: (values) => `${values?.title?.toLowerCase().replace(/ /g, '-')}`
    },
  },
  fields: [
    {
      type: "string",
      name: "title",
      label: "Title",
      isTitle: true,
      required: true
    },
    {
      type: "rich-text",
      name: "body",
      label: "Body",
      isBody: true,
    },
    {
      name: 'art',
      label: 'Kunstform',
      type: 'reference',
      collections: ['art']
    },
    LinksField
  ]
};
