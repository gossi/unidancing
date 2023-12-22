import type { Collection } from 'tinacms';

export const AwfulPracticeCollection: Collection = {
  name: 'awfulpractice',
  label: 'Awful Practices',
  path: 'content/awful-practices',
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
      name: 'tags',
      label: 'Tags',
      type: 'string',
      list: true,
      options: ['choreography', 'artistry', 'tricks', 'flow', 'posture', 'competition', 'misc']
    },
    {
      type: "rich-text",
      name: "body",
      label: "Body",
      isBody: true,
    }
  ]
};
