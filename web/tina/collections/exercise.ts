import type { Collection, TinaField } from 'tinacms';
import { LinksField, VideoField } from '../-fields';
import { data as loops } from '../../app/domain/core/assistants/looper/data';

const loopOptions = loops
  .flatMap((loop) => {
    if (loop.loops.length === 1) {
      return {
        value: loop.id,
        label: loop.id
      }
    }

    if (loop.loops.length > 1) {
      return loop.loops.map(variant => ({
        value: `${loop.id}.${variant.name}`,
        label: `${loop.id} (${variant.name})`,
      }))
    }

    return undefined;
  })
  .filter(o => o !== undefined);

const GoalField: TinaField = {
  name: 'goal',
  label: 'Ziel',
  type: 'string',
  ui: {
    component: 'textarea'
  }
}

const MediaField: TinaField = {
  name: 'media',
  label: 'Media / Material',
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
          label: 'Dance Mix'
        }
      },
      fields: [
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
    },
    {
      name: 'song',
      label: 'Song',
      ui: {
        defaultItem: {
          play: 'dance'
        }
      },
      fields: [
        {
          name: 'id',
          label: 'Spotifv Track ID',
          description: 'In Spotify `Teilen > Songlink kopieren` dort findet sich die ID',
          type: 'string',
          required: true
        },
        {
          name: 'play',
          label: 'Abspielen ab',
          type: 'string',
          required: true,
          ui: {
            component: "radio-group"
          },
          options: [
            {
              value: "beginning",
              label: "Von Anfang"
            },
            {
              value: "dance",
              label: "Erstes Drittel (Perfekt zum Tanzen)"
            },
            {
              value: 'custom',
              label: 'Selbst festgelegen'
            }
          ]
        },
        {
          name: 'start',
          label: 'Startzeit [s]',
          type: 'number'
        }
      ]
    },
    {
      name: 'loop',
      label: 'Loop',
      ui: {
        itemProps: (item) => {
          return {
            label: `Loop${item?.name ? `: ${item?.name}` : ' (Bitte auswählen)' }`
          }
        }
      },
      fields: [
        {
          name: 'name',
          label: 'Name',
          type: 'string',
          ui: {
            component: 'radio-group'
          },
          options: loopOptions,
        }
      ]
    },
    {
      name: 'material',
      label: 'Material',
      fields: [
        {
          name: 'material',
          label: 'Material',
          type: 'string',
          list: true
          // ui: {
          //   component: 'textarea'
          // }
        }
      ]
    }
  ]
};

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
      required: true
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
      type: "rich-text",
      name: "body",
      label: "Body",
      isBody: true,
    },
    MediaField,
    {
      name: 'instruction',
      label: 'Ablauf',
      type: 'object',
      list: true,
      ui: {
        itemProps: (item) => {
          return {
            label: item?.move ?? item?.title
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
          name: 'move',
          label: 'Move',
          type: 'reference',
          collections: ['move']
        },
        {
          name: 'duration',
          label: 'Dauer [min]',
          type: 'number'
        },
        {
          name: 'content',
          label: 'Inhalt',
          type: "rich-text"
        },
        {
          name: 'method',
          label: 'Sozialform / Methode',
          type: 'string',
          ui: {
            component: "radio-group"
          },
          options: [
            {
              value: 'lecture',
              label: 'Trainervortrag'
            },
            {
              value: 'individual',
              label: 'Einzelübung'
            },
            {
              value: 'pair',
              label: 'Partnerübung'
            },
            {
              value: 'group',
              label: 'Gruppenübung'
            },
            {
              value: 'discussion',
              label: 'Diskussion'
            },
            {
              value: 'frontal-teaching',
              label: 'Frontalunterricht'
            },
            {
              value: 'showcase',
              label: 'Showcase'
            }
          ]
        },
        GoalField,
        MediaField
      ]
    },
    {
      label: 'Schwierigkeit',
      name: 'difficulty',
      type: 'string',
      required: true,
      ui: {
        component: "radio-group"
      },
      options: [
        {
          value: 'beginner',
          label: 'Einsteiger',
        },
        {
          value: 'intermediate',
          label: 'Mittel',
        },
        {
          value: 'advanced',
          label: 'Fortgeschritten'
        }
      ],
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
    VideoField,
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
    }
  ]
};
