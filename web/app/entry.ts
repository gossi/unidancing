import { bootRehydrated, installShoebox } from 'vite-ember-ssr/client';

import '@formatjs/intl-durationformat/polyfill';
import 'vis-timeline/dist/vis-timeline-graph2d.min.css';
import '@hokulea/core/style.css';
import './assets/app.css';

import Application from './app';
import config from './config/environment';

installShoebox();
bootRehydrated(Application, config);
