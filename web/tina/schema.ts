import { defineSchema } from 'tinacms';

const schema = defineSchema({
  collections: [
    {
      name: 'exercises',
      label: 'Exercises',
      path: 'exercises',
      fields: [
        {
          type: "string",
          name: "title",
          label: "Title",
          isTitle: true,
          required: true,
        },
        {
          label: 'Locomotion',
          name: 'locomotion',
          type: 'string',
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
          type: "rich-text",
          name: "body",
          label: "Body",
          isBody: true,
        }
      ]
    },
    {
      name: 'tricks',
      label: 'Tricks',
      path: 'tricks',
      fields: [
        {
          type: "string",
          name: "title",
          label: "Title",
          isTitle: true,
          required: true
        }
      ]
    }
  ]
});

export { schema };

