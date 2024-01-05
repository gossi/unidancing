import type { Collection } from 'tinacms';

export const SkillCollection: Collection = {
  name: 'skill',
  label: 'Skills',
  path: 'content/skills',
  fields: [
    {
      type: "string",
      name: "title",
      label: "Title",
      isTitle: true,
      required: true
    },
    {
      type: "rich-text",
      name: "body",
      label: "Body",
      isBody: true,
    }
  ]
};
