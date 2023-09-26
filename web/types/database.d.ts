declare module '@unidancing/database' {
  export interface Model {
    id: string;
    title: string;
    excerpt: string;
    contents: string;
  }
}

declare module '@unidancing/database/moves.json' {
  import type { Games } from '@unidancing/app/games/games';
  import type { Model } from '@unidancing/database';

  type Link = {
    label: string;
    url: string;
  };

  interface Game<K = keyof Games> {
    name: K;
    label?: string;
    params?: Games[K];
  }

  interface MoveWireFormat extends Model {
    tags?: string[];
    see?: (string | Link)[];
    skills?: string[];
    video?: {
      type: string;
      url: string;
    };
    games?: Game[];
  }

  declare const database: readonly {
    data: Record<string, MoveWireFormat>;
  };

  export { Game, Link, MoveWireFormat };
  export default database;
}

declare module '@unidancing/database/exercises.json' {
  import type { Games } from '@unidancing/app/games/games';
  import type { Model } from '@unidancing/database';

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

  export { ExerciseWireFormat, Game, Link, Locomotion, Personal };
  export default database;
}

declare module '@unidancing/database/skills.json' {
  import type { Model } from '@unidancing/database';

  // eslint-disable-next-line @typescript-eslint/no-empty-interface
  interface SkillWireFormat extends Model {}

  declare const database: readonly {
    data: Record<string, Skill>;
  };

  export { SkillWireFormat };
  export default database;
}

declare module '@unidancing/database/principles.json' {
  import type { Model } from '@unidancing/database';

  interface PrincipleWireFormat extends Model {
    tags?: string[];
    see?: string[];
  }

  declare const database: readonly {
    data: Record<string, Skill>;
  };

  export { PrincipleWireFormat };
  export default database;
}
