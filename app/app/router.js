import EmberRouter from '@ember/routing/router';
import config from 'unidance-coach/config/environment';

export default class Router extends EmberRouter {
  location = config.locationType;
  rootURL = config.rootURL;
}

Router.map(function () {
  this.route('dance-mix');
  this.route('auth', function () {
    this.route('spotify');
  });
  this.route('courses', function () {
    this.route('improvisation');
  });
  this.route('skills', { path: 'fertigkeiten' }, function () {
    this.route('details', { path: '/:id' });
  });
  this.route('exercises', { path: 'uebungen' }, function () {
    this.route('details', { path: '/:id' });
  });
});
