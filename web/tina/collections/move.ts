import type { Collection } from 'tinacms';
import { LinksField, VideoField } from '../-fields';

export const MoveCollection: Collection = {
  name: 'move',
  label: 'Moves',
  path: 'content/moves',
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
      name: 'art',
      label: 'Kunstform',
      type: 'reference',
      collections: ['art'],
    },
    {
      type: "string",
      name: "excerpt",
      label: "Excerpt",
      ui: {
        component: 'textarea'
      }
    },
    {
      name: 'tags',
      label: 'Tags',
      type: 'string',
      list: true,
      ui: {
        component: 'tags'
      }
    },
    VideoField,
    LinksField,
    {
      name: 'moves',
      label: 'Verwandte Moves',
      type: 'object',
      list: true,
      ui: {
        itemProps: (item) => {
          return {
            label: item?.data
          }
        }
      },
      fields: [{
        name: 'data',
        label: 'Move',
        type: 'reference',
        collections: ['move'],
      }]
    },
    {
      type: "rich-text",
      name: "body",
      label: "Body",
      isBody: true,
    },
  ]
};
