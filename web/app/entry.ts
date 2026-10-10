import '@formatjs/intl-durationformat/polyfill';
import 'vis-timeline/styles/vis-timeline-graph2d.min.css';
import './assets/app.css';

import { bootRehydrated, installShoebox } from 'vite-ember-ssr/client';

import '@hokulea/core/style.css';

import Application from './app';
import config from './config/environment';

installShoebox();
bootRehydrated(Application, config);
