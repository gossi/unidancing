import type { Collection, TinaField } from 'tinacms';

function makeEvaluationField(name: string, label: string) {
  return {
    name,
    label,
    type: 'object',
    fields: [
      {
        name: 'duration',
        label: 'Dauer',
        type: 'number'
      },
      {
        name: 'ratio',
        label: 'Verhältnis',
        type: 'number'
      }
    ]
  } as TinaField<false>;
}

export const RoutinesCollection: Collection = {
  name: 'routines',
  label: 'Routines',
  path: 'content/routines',
  format: 'json',
  ui: {
    allowedActions: {
      create: false,
      delete: false
    }
  },
  fields: [
    {
      type: "string",
      name: "rider",
      label: "Rider",
      required: true,
      isTitle: true
    },
    {
      type: 'string',
      name: 'type',
      label: 'Type',
      required: true,
      options: [
        {
          value: 'individual',
          label: 'Einzelkür'
        },
        {
          value: 'pair',
          label: 'Paarkür'
        },
        {
          value: 'small-group',
          label: 'Kleingruppe'
        },
        {
          value: 'large-group',
          label: 'Großgruppe'
        }
      ]
    },
    {
      name: 'event',
      label: 'Event',
      type: 'string'
    },
    {
      name: 'date',
      label: 'Date',
      type: 'datetime',
      ui: {
        dateFormat: 'YYYY-MM-DD',
        // @ts-ignore
        parse: (value) => value && value.format('YYYY-MM-DD'),
      }
    },
    {
      name: 'video',
      label: 'Video',
      type: 'string',
      required: true
    },
    {
      name: 'timeTracking',
      label: 'Time Tracking',
      type: 'object',
      fields: [
        {
          name: 'start',
          label: 'Start',
          type: 'number'
        },
        {
          name: 'end',
          label: 'Ende',
          type: 'number'
        },
        {
          name: 'scenes',
          label: 'Szenen',
          type: 'object',
          list: true,
          fields: [
            {
              name: 'start',
              label: 'Start',
              type: 'number'
            },
            {
              name: 'end',
              label: 'Ende',
              type: 'number'
            },
            {
              name: 'category',
              label: 'Kategorie',
              type: 'string'
            }
          ]
        },
        {
          name: 'duration',
          label: 'Dauer',
          type: 'number'
        },
        {
          name: 'evaluation',
          label: 'Auswertung',
          type: 'object',
          fields: [
            makeEvaluationField('artistry', 'Artistik'),
            makeEvaluationField('communication', 'Kommunikation'),
            makeEvaluationField('tricks', 'Tricks'),
            makeEvaluationField('filler', 'Filler'),
            makeEvaluationField('void', 'Void'),
            makeEvaluationField('dismounts', 'Abstiege'),
          ]
        }
      ]
    },
    {
      name: 'artistic',
      label: 'Artistik',
      type: 'object',
      fields: [
        {
          name: 'name',
          type: 'string',
          required: true
        },
        {
          name: 'score',
          type: 'number'
        },
        {
          name: 'parts',
          type: 'object',
          list: true,
          fields: [
            {
              name: 'name',
              type: 'string',
              required: true
            },
            {
              name: 'score',
              type: 'number'
            },
            {
              name: 'categories',
              type: 'object',
              list: true,
              fields: [
                {
                  name: 'name',
                  type: 'string',
                  required: true
                },
                {
                  name: 'score',
                  type: 'number'
                },
                {
                  name: 'criteria',
                  type: 'object',
                  list: true,
                  fields: [
                    {
                      name: 'name',
                      type: 'string',
                      required: true
                    },
                    {
                      name: 'value',
                      type: 'number'
                    }
                  ]
                }
              ]
            }
          ]
        }
      ]
    },
    {
      name: 'notTodoList',
      label: 'Not Todo List',
      type: 'string',
      list: true
    }
  ]
};
