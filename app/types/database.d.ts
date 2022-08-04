declare module '@unidance-coach/database' {
  export interface Model {
    id: string;
    title: string;
    excerpt: string;
    contents: string;
  }
}

declare module '@unidance-coach/database/exercises.json' {
  import { Model } from '@unidance-coach/database';
  import { Games } from '@unidance-coach/app/games/games';

  type Personal = 'individual' | 'pair' | 'group';
  type Locomotion = 'unicycle' | 'pedes';
  type Link = {
    label: string;
    url: string;
  };

  interface Game<K = keyof Games> {
    name: K;
    label?: string;
    params?: Games[K];
  }

  interface ExerciseWireFormat extends Model {
    personal?: Personal[];
    locomotion?: Locomotion | Locomotion[];
    tags?: string[];
    skills?: string[];
    see?: (string | Link)[];
    games?: Game[];
  }

  declare const database: readonly {
    data: Record<string, ExerciseWireFormat>;
  };

  export { Personal, Locomotion, Link, Game, ExerciseWireFormat };
  export default database;
}

declare module '@unidance-coach/database/skills.json' {
  import { Model } from '@unidance-coach/database';

  // eslint-disable-next-line @typescript-eslint/no-empty-interface
  interface SkillWireFormat extends Model {}

  declare const database: readonly {
    data: Record<string, Skill>;
  };

  export { SkillWireFormat };
  export default database;
}
