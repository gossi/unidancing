import Route from '@ember/routing/route';

export default class CourseDetailsRoute extends Route {
  model(params: { id: string }) {
    return params;
  }
}
