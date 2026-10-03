import '@formatjs/intl-durationformat/polyfill';
import 'vis-timeline/dist/vis-timeline-graph2d.min.css';
import '@hokulea/core/style.css';
import './assets/app.css';

import Application from './app';
import config from './config/environment';

Application.create(config.APP);
