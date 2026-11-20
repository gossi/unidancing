/* eslint-disable @typescript-eslint/no-invalid-this */
import EmberRouter from '@embroider/router';

import { ArtsManifest } from '#arts';
import { AssistantsManifest } from '#assistants';
import { ChoreographyManifest } from '#choreography';
import { CoursesManifest } from '#courses';
import { ExercisesManifest } from '#exercises';
import { GamesManifest } from '#games';
import { MovesManifest } from '#moves';
import { SkillsManifest } from '#skills';
import { SpotifyManifest } from '#support/spotify';
import { TrainingManifest } from '#training';

export default class Router extends EmberRouter {
  location = 'history';
  rootURL = '/';
}

/* eslint-disable unicorn/no-top-level-side-effects */
Router.map(function () {
  /* eslint-disable unicorn/no-this-outside-of-class */
  SpotifyManifest.buildRoutes(this);
  AssistantsManifest.buildRoutes(this);
  CoursesManifest.buildRoutes(this);
  ArtsManifest.buildRoutes(this);
  SkillsManifest.buildRoutes(this);
  ExercisesManifest.buildRoutes(this);
  MovesManifest.buildRoutes(this);
  GamesManifest.buildRoutes(this);
  ChoreographyManifest.buildRoutes(this);
  TrainingManifest.buildRoutes(this);
  /* eslint-enable unicorn/no-this-outside-of-class */
});
/* eslint-enable unicorn/no-top-level-side-effects */
