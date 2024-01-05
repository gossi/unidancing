import type { TinaField } from 'tinacms';

export const LinksField: TinaField = {
  name: 'links',
  label: 'Links',
  type: 'object',
  list: true,
  ui: {
    itemProps: (item) => {
      return {
        label: item?.label
      }
    }
  },
  fields: [
    {
      name: 'label',
      label: 'Label',
      type: 'string'
    },
    {
      name: 'url',
      label: 'URL',
      type: 'string'
    }
  ]
};

export const VideoField: TinaField = {
  name: 'video',
  label: 'Video',
  description: 'Youtube URL',
  type: 'string'
}
