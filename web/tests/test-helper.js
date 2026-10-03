import 'qunit/qunit/qunit.css';

import { setApplication } from '@ember/test-helpers';
import * as QUnit from 'qunit';
import { setup } from 'qunit-dom';
import { setupEmberOnerrorValidation, start as qunitStart } from 'ember-qunit';

import Application from '@unidancing/app/app';
import config from '@unidancing/app/config/environment';
import setupSinon from 'ember-sinon-qunit';

export function start() {
  setApplication(
    Application.create({
      ...config.APP,
      autoboot: false,
      location: 'none',
      rootElement: '#ember-testing'
    })
  );
  setupSinon();
  setup(QUnit.assert);
  setupEmberOnerrorValidation();

  qunitStart();
}
