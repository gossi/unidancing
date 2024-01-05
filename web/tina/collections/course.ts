import type { Collection } from 'tinacms';

export const CourseCollection: Collection = {
  name: 'course',
  label: 'Kurse',
  path: 'content/courses',
  ui: {
    filename: {
      slugify: (values) => `${values?.title?.toLowerCase().replace(/ /g, '-')}`,
    },
  },
  fields: [
    {
      name: "title",
      label: "Title",
      type: "string",
      isTitle: true,
      required: true
    },
    {
      name: 'description',
      label: 'Description',
      type: 'string'
    },
    {
      name: 'about',
      label: 'About',
      type: 'string',
      ui: {
        component: 'textarea'
      }
    },
    {
      name: 'learn',
      label: 'Lernziele',
      type: 'string',
      list: true
    },
    {
      name: 'examples',
      label: 'Beispiele',
      description: 'Youtube Links',
      type: 'string',
      list: true
    },
    {
      name: 'lessons',
      label: 'Lesson',
      type: 'object',
      list: true,
      templates: [
        {
          name: 'lesson',
          label: 'Lesson',
          ui: {
            itemProps: (item) => {
              return {
                label: item?.title
              }
            }
          },
          fields: [
            {
              name: 'title',
              label: 'Titel',
              type: 'string'
            },
            {
              name: 'description',
              label: 'Description',
              type: 'string'
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
            }
          ]
        }
      ]
    }
  ]
}
