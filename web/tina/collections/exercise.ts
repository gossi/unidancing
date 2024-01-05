import type { Collection } from 'tinacms';
import { LinksField, VideoField } from '../-fields';

export const ExerciseCollection: Collection = {
  name: 'exercise',
  label: 'Exercises',
  path: 'content/exercises',
  fields: [
    {
      type: "string",
      name: "title",
      label: "Title",
      isTitle: true,
      required: true,
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
      label: 'Locomotion',
      name: 'locomotion',
      type: 'string',
      list: true,
      options: [
        {
          value: 'pedes',
          label: 'Pedes',
        },
        {
          value: 'unicycle',
          label: 'Unicycle',
        },
      ],
    },
    {
      label: 'Personal',
      name: 'personal',
      type: 'string',
      required: false,
      list: true,
      options: [
        {
          value: 'individual',
          label: 'Individual',
        },
        {
          value: 'pair',
          label: 'Pair',
        },
        {
          value: 'group',
          label: 'Group'
        }
      ],
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
    {
      name: 'material',
      label: 'Material',
      type: 'string',
      list: true
    },
    {
      name: 'skills',
      label: 'Skills',
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
        label: 'Skill',
        type: 'reference',
        collections: ['skill'],
      }]
    },
    {
      name: 'exercises',
      label: 'Exercises',
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
        label: 'Exercise',
        type: 'reference',
        collections: ['exercise'],
      }]
    },
    LinksField,
    {
      name: 'games',
      label: 'Games',
      type: 'object',
      list: true,
      templates: [
        {
          name: 'dancemix',
          label: 'Dance Mix',
          ui: {
            itemProps: (item) => {
              return {
                label: `Dance Mix${item?.label !== 'Dance Mix' ? `: ${item.label}` : ''}`
              }
            },
            defaultItem: {
              name: 'dance-mix',
              label: 'Dance Mix'
            }
          },
          fields: [
            {
              name: 'name',
              label: 'Name',
              type: 'string',
              options: [{
                value: 'dance-mix',
                label: 'Dance Mix'
              }]
            },
            {
              name: 'label',
              label: 'Label',
              type: 'string'
            },
            {
              name: 'duration',
              label: 'Dauer',
              type: 'number'
            },
            {
              name: 'pause',
              label: 'Pause',
              type: 'number'
            },
            {
              name: 'amount',
              label: 'Anzahl',
              type: 'number'
            },
            {
              name: 'playlist',
              label: 'Playlist',
              type: 'string',
              options: [
                {
                  value: 'epic',
                  label: 'Epic'
                },
                {
                  value: 'mood',
                  label: 'Stimmung'
                }
              ]
            }
          ]
        }
      ]
    },
    {
      name: 'art',
      label: 'Art',
      type: 'reference',
      collections: ['art'],
    },
    {
      name: 'technique',
      label: 'Technique',
      type: 'reference',
      collections: ['technique'],
    },
    VideoField,
    {
      type: "rich-text",
      name: "body",
      label: "Body",
      isBody: true,
    }
  ]
};
