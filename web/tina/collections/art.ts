import type { Collection } from 'tinacms';
import { LinksField, VideoField } from '../-fields';

export const ArtCollection: Collection = {
  name: 'art',
  label: 'Arts',
  path: 'content/arts',
  ui: {
    filename: {
      slugify: (values) => `${values?.title?.toLowerCase().replace(/ /g, '-')}`,
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
      name: 'parent',
      label: 'Parent',
      type: 'reference',
      collections: ['art']
    },
    VideoField,
    LinksField,
    {
      type: "rich-text",
      name: "body",
      label: "Body",
      isBody: true,
    },
  ]
};
