export type Personal = 'individual' | 'pair' | 'group';
export type Locomotion = 'unicycle' | 'pedes';
export type Link = {
  label: string;
  url: string;
};

export type See = Link | Exercise;

export interface ExerciseWireFormat {
  id: string;
  excerpt: string;
  contents: string;
  personal: Personal[];
  locomotion: Locomotion | Locomotion[];
  tags: string[];
  skills: string[];
  see: (string | Link)[];
}

export interface Exercise {
  id: string;
  excerpt: string;
  contents: string;
  personal: Personal[];
  locomotion: Locomotion[];
  tags: string[];
  skills: Skill[];
  see: See[];
}

declare const database: readonly {
  data: Record<string, ExerciseWireFormat>;
};

export default database;
