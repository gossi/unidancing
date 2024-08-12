import type { Collection } from 'tinacms';
import { LinksField, VideoField } from '../-fields';

export const MoveCollection: Collection = {
  name: 'move',
  label: 'Moves',
  path: 'content/moves',
  format: 'md',
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
      type: "rich-text",
      name: "description",
      label: "Bewegungsbeschreibung"
    },
    {
      type: "rich-text",
      name: "instruction",
      label: "Anleitung"
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
    {
      name: 'tags',
      label: 'Tags',
      type: 'string',
      list: true,
      ui: {
        component: 'tags'
      }
    },
  ]
};
