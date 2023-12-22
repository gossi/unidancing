import { defineSchema } from 'tinacms';
import { SkillCollection } from './collections/skill';
import { TechniqueCollection } from './collections/technique';
import { ArtCollection } from './collections/art';
import { ExerciseCollection } from './collections/exercise';
import { CourseCollection } from './collections/course';
import { AwfulPracticeCollection } from './collections/aweful-practice';
import { MoveCollection } from './collections/move';

const schema = defineSchema({
  collections: [
    SkillCollection,
    TechniqueCollection,
    ArtCollection,
    MoveCollection,
    ExerciseCollection,
    CourseCollection,
    AwfulPracticeCollection
    // {
    //   name: 'trick',
    //   label: 'Tricks',
    //   path: 'content/tricks',
    //   fields: [
    //     {
    //       type: "string",
    //       name: "title",
    //       label: "Title",
    //       isTitle: true,
    //       required: true
    //     }
    //   ]
    // }
  ]
});

export { schema };

