import './assets/app.css';
import '@formatjs/intl-durationformat/polyfill';
import 'vis-timeline/dist/vis-timeline-graph2d.min.css';

import Application from '@ember/application';

import config from "./config/environment";
import loadInitializers from 'ember-load-initializers';
import Resolver from 'ember-resolver';

import '@hokulea/core/style.css';

import setupInspector from "@embroider/legacy-inspector-support/ember-source-4.12";
import compatModules from "@embroider/virtual/compat-modules";

export default class App extends Application {
  modulePrefix = config.modulePrefix;
  podModulePrefix = config.podModulePrefix;
  Resolver = Resolver.withModules(compatModules);
  inspector = setupInspector(this);
}

loadInitializers(App, config.modulePrefix, compatModules);
