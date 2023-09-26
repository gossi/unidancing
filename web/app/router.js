import EmberRouter from '@ember/routing/router';
import config from '@unidancing/app/config/environment';

export default class Router extends EmberRouter {
  location = config.locationType;
  rootURL = config.rootURL;
}

Router.map(function () {
  this.route('auth', function () {
    this.route('spotify');
  });
  this.route('courses', function () {
    this.route('improvisation');
    this.route('moves');
    this.route('emotionen');
  });
  this.route('skills', { path: 'fertigkeiten' }, function () {
    this.route('details', { path: '/:id' });
  });
  this.route('exercises', { path: 'uebungen' }, function () {
    this.route('details', { path: '/:id' });
  });
  this.route('moves', function () {
    this.route('details', { path: '/:id' });
  });
  this.route('games', { path: '/games/:id' });
  this.route('choreography', function () {
    this.route('not-todo-list');
    this.route('unidance-writing');
  });
  this.route('training', function () {
    this.route('control');
    this.route('diagnostics');
  });
});
