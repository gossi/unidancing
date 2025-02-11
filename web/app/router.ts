/* eslint-disable @typescript-eslint/no-invalid-this */
import EmberRouter from '@embroider/router';

import config from '@unidancing/app/config/environment';

export default class Router extends EmberRouter {
  location = config.locationType;
  rootURL = config.rootURL;
}

Router.map(function () {
  this.route('auth', function () {
    this.route('spotify');
  });
  this.route('assistants', { path: '/assistants/:assistant' });
  this.route('courses', function () {
    this.route('details', { path: '/:id' });
  });
  this.route('arts', { path: 'kuenste' }, function () {
    this.route('details', { path: '/:id' });
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
  this.route('games', { path: '/games/:game' });
  this.route('choreography', function () {
    this.route('not-todo-list');
    this.route('unidance-writing');
    this.route('routines', function () {
      this.route('test');
      this.route('test_load', { path: '/test/:data' });
      this.route('results', { path: '/results/:data' });
      this.route('training', function () {
        this.route('index', { path: '/:data' });
        this.route('results', { path: '/results/:data' });
      });
      this.route('details', { path: '/*path' });
    });
  });
  this.route('training', function () {
    this.route('athletic-profile', { path: '/leistungsprofil' });
    this.route('planning', function () {
      this.route('units');
      this.route('plans');
      this.route('assistants');
      this.route('games');
    });
    this.route('control');
    this.route('diagnostics', function () {
      this.route('time-tracking');
      this.route('body-language');
    });
  });
});
