import ChoreographyNotTodoList from '../choreography/not-todo-list/listing';

export default ChoreographyNotTodoList;

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    ChoreoNotTodoList: typeof ChoreographyNotTodoList;
  }
}
