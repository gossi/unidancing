import { defineSchema } from 'tinacms';
import { SkillCollection } from './collections/skill';
import { TechniqueCollection } from './collections/technique';
import { ArtCollection } from './collections/art';
import { ExerciseCollection } from './collections/exercise';
import { CourseCollection } from './collections/course';
import { AwfulPracticeCollection } from './collections/aweful-practice';
import { MoveCollection } from './collections/move';
import { RoutinesCollection } from './collections/routines';

const schema = defineSchema({
  collections: [
    SkillCollection,
    TechniqueCollection,
    ArtCollection,
    MoveCollection,
    ExerciseCollection,
    CourseCollection,
    AwfulPracticeCollection,
    RoutinesCollection
  ]
});

export { schema };

