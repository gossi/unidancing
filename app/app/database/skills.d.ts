export interface Skill {
  id: string;
  excerpt: string;
  contents: string;
}

declare const database: readonly {
  data: Record<string, Skill>;
};
export default database;
