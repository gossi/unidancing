import { setApplication } from '@ember/test-helpers';
import * as QUnit from 'qunit';
import { setup } from 'qunit-dom';
import { setupEmberOnerrorValidation, start } from 'ember-qunit';
import { loadTests } from 'ember-qunit/test-loader';

import Application from '@unidancing/app/app';
import config from '@unidancing/app/config/environment';
import setupSinon from 'ember-sinon-qunit';

setApplication(Application.create(config.APP));
setupSinon();
setup(QUnit.assert);
setupEmberOnerrorValidation();

loadTests();
start();
