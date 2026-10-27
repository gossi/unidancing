import { createCache, getValue } from '@glimmer/validator';

import { useMachine } from '@unidancing/app/domain/supporting/statechart';
import { describe, expect, test } from 'vitest';
import { createMachine } from 'xstate';

describe('Supporting | Unit | Statechart | useMachine', () => {
  test('boots to the initial snapshot immediately', () => {
    const machine = createMachine({
      id: 'shim',
      initial: 'idle',
      states: { idle: {} }
    });

    const chart = useMachine({}, () => ({ machine }));

    expect(chart.state?.value).toBe('idle');
  });

  // Regression: components boot their machine inside the render computation.
  // `actor.start()` emits the initial snapshot synchronously, so the tracked
  // `state` write lands in that same frame — if the subscription ever *reads*
  // the tracked field first (e.g. in a dedupe check), Glimmer asserts
  // "modified after use in the same computation". `createCache` stands in for
  // the render frame so that ordering stays checked.
  test('boots inside a tracking computation without tripping autotracking', () => {
    const machine = createMachine({
      id: 'boot',
      initial: 'idle',
      states: { idle: {} }
    });

    const cache = createCache(() => {
      const chart = useMachine({}, () => ({ machine }));

      return chart.state?.value;
    });

    expect(getValue(cache)).toBe('idle');
  });

  // Regression: templates invoke `{{this.machine.state.matches "x"}}` via
  // Glimmer's helper machinery — `matches` is called WITHOUT the snapshot as
  // its receiver. v4's State shipped a bound-arrow `matches` (survived
  // detaching); v5's snapshot method reads `this.value` and only works if the
  // wrapper rebound it, per fresh snapshot.
  test('matches() survives being detached from the snapshot (template calls)', () => {
    const machine = createMachine({
      id: 'detached',
      initial: 'idle',
      states: {
        idle: {
          on: {
            go: {
              target: 'busy'
            }
          }
        },
        busy: {}
      }
    });

    const chart = useMachine({}, () => ({ machine }));

    const detached = chart.state?.matches;

    expect(detached?.('idle')).toBe(true);
    expect(detached?.('busy')).toBe(false);

    chart.send('go');

    // the post-transition snapshot must be rebound as well
    const detachedNext = chart.state?.matches;

    expect(detachedNext?.('busy')).toBe(true);
  });

  // xstate v5 removed the v4 `send(type, payload)` sugar (and string events
  // entirely); the wrapper normalizes both forms back into event objects to
  // keep the ember-statecharts contract the templates rely on.
  test('send() normalizes string events and payloads into event objects', () => {
    const received: unknown[] = [];

    const machine = createMachine({
      id: 'shim',
      initial: 'idle',
      states: {
        idle: {
          on: {
            go: {
              actions: ({ event }) => {
                received.push(event);
              }
            }
          }
        }
      }
    });

    const chart = useMachine({}, () => ({ machine }));

    chart.send('go');
    chart.send('go', { n: 1 });
    chart.send({ type: 'go' });

    expect(received).toEqual([{ type: 'go' }, { type: 'go', n: 1 }, { type: 'go' }]);
  });
});
