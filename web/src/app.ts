import IntlService from 'ember-intl/services/intl';
import LinkManagerService from 'ember-link/services/link-manager';
import PageTitleService from 'ember-page-title/services/page-title';
import PortalService from 'ember-stargate/services/-portal';
import EmberApp from 'ember-strict-application-resolver';

import { ArtsManifest } from '#arts';
import { AssistantsManifest } from '#assistants';
import { ChoreographyManifest } from '#choreography';
import { CoursesManifest } from '#courses';
import { ExercisesManifest } from '#exercises';
import { GamesManifest } from '#games';
import { HomeManifest } from '#home';
import { MovesManifest } from '#moves';
import { SkillsManifest } from '#skills';
import { SpotifyManifest } from '#support/spotify';
import { TrainingManifest } from '#training';

import HokuleaService from '@hokulea/ember/services/-hokulea';

import Router from './router';
import AppDataCacheService from './services/app-data-cache';
import ApplicationController from './ui/application/controller';
import ApplicationRoute from './ui/application/route';
import ApplicationTemplate from './ui/application/template';

export default class App extends EmberApp {
  modules = {
    './router': Router,

    // Services looked up by string (via @service declarations in the app and
    // inside addon helpers like {{pageTitle}}). Add more here if a strict
    // lookup ever fails at runtime.
    './services/-hokulea': HokuleaService,
    './services/-portal': PortalService,
    './services/intl': IntlService,
    './services/link-manager': LinkManagerService,
    './services/page-title': PageTitleService,
    './services/app-data-cache': AppDataCacheService,

    // Domains — each manifest contributes its route modules.
    ...ArtsManifest.buildRegistry(),
    ...AssistantsManifest.buildRegistry(),
    ...ChoreographyManifest.buildRegistry(),
    ...CoursesManifest.buildRegistry(),
    ...ExercisesManifest.buildRegistry(),
    ...GamesManifest.buildRegistry(),
    ...HomeManifest.buildRegistry(),
    ...MovesManifest.buildRegistry(),
    ...SkillsManifest.buildRegistry(),
    ...TrainingManifest.buildRegistry(),
    ...SpotifyManifest.buildRegistry(),

    // app shell
    './templates/application': ApplicationTemplate,
    './controllers/application': ApplicationController,
    './routes/application': ApplicationRoute
  };
}
