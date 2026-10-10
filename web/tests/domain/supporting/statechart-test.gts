import Component from '@glimmer/component';
import { click, getContext, render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { useMachine } from '@unidancing/app/domain/supporting/statechart';
import { createMachine } from 'xstate';

import type { TestContext } from '@ember/test-helpers';

interface RenderingTestContext extends TestContext {
  element: HTMLElement;
}

const probe = createMachine({
  id: 'probe',
  initial: 'a',
  states: {
    a: { on: { go: 'b' } },
    b: { on: { go: 'a' } }
  }
});

class MachineProbe extends Component {
  machine = useMachine(this, () => ({ machine: probe }));

  get shown(): string {
    const value = this.machine.state?.value;

    return typeof value === 'string' ? value : 'none';
  }

  go = () => {
    this.machine.send('go');
  };

  <template>
    <p data-test-machine-state>{{this.shown}}</p>
    <button type="button" data-test-machine-send {{on "click" this.go}}>go</button>
  </template>
}

module('Domain | Supporting | statechart', function (hooks) {
  setupRenderingTest(hooks);

  // Regression: `resource()` is lazy — the machine must boot on first property
  // read (through the proxy `resource` returns), and `send` transitions must
  // propagate through the tracked state into the rendered UI.
  test('machine boots on first read and re-renders on send', async function (assert) {
    await render(<template><MachineProbe /></template>);

    const context = getContext() as RenderingTestContext;

    const stateText = () =>
      context.element.querySelector(':scope > [data-test-machine-state]')?.textContent?.trim();

    assert.strictEqual(stateText(), 'a', 'machine started (lazy resource boots on first read)');

    await click('[data-test-machine-send]');

    assert.strictEqual(stateText(), 'b', 'send updates rendered state');
  });
});
