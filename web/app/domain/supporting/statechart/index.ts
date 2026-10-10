// Vendored replacement for ember-statecharts (unmaintained since 2023, built
// on the legacy class-based `Resource` API which ember-resources v7 removes).
// This implements the same `useMachine` contract using function-based
// resources. See https://github.com/LevelbossMike/ember-statecharts for the
// original; deliberate deviations:
// - no `update` option (restart-on-argument-change stops the previous
//   interpreter via the resource's cleanup hook, which is safe for xstate
//   services)
// - no `config:environment` / `runloopClockService` lookup (never configured
//   in this app, and unresolvable in the strict resolver setup anyway)
//
// NOTE: ember-resources v6 `resource(context, fn)` is LAZY — `fn` runs on the
// first property read of the returned proxy, not at definition time. The
// proxy must therefore be the public value we hand back to consumers (they
// read `.state` / `.send` through it, which boots and keeps the machine
// alive); discarding it would mean the interpreter never starts.

import { tracked } from '@glimmer/tracking';

import { resource } from 'ember-resources';
import { interpret } from 'xstate';

import type {
  Event,
  EventData,
  EventFrom,
  InterpreterOptions,
  SCXML,
  SingleOrArray,
  StateFrom,
  StateMachine,
  StateValue
} from 'xstate';

// eslint-disable-next-line @typescript-eslint/no-explicit-any
type AnyMachine = StateMachine<any, any, any, any>;

export interface MachineSetup<M extends AnyMachine> {
  machine: M;
  initialState?: StateValue;
  onTransition?: (state: StateFrom<M>) => void;
  interpreterOptions?: InterpreterOptions;
}

export interface Statechart<M extends AnyMachine> {
  /**
   * The last state delivered by the interpreter. The `| undefined` union (as
   * in the original addon) also matters for mapped-type consumers: hokulea's
   * `FieldNames<DATA>` stops recursing at unions, avoiding a circular
   * `StateNode <-> StateMachine` expansion (TS2615) when a machine ends up
   * inside `@form` data.
   */
  readonly state: StateFrom<M> | undefined;

  send(
    event: SingleOrArray<Event<EventFrom<M>>> | SCXML.Event<EventFrom<M>>,
    payload?: EventData
  ): StateFrom<M> | undefined;
}

// xstate's generic machinery erases through the loose `AnyMachine` bound
// (deferred `StateFrom<M>` etc. never line up), so the internals are typed
// loosely and narrowed once at the public boundary.
/* eslint-disable @typescript-eslint/no-explicit-any, @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-unsafe-return */
class StateBox {
  @tracked state: any;

  interpreter: any;

  // stable identity across interpreter restarts (reads the live one)
  send = (event: any, payload?: any) => this.interpreter?.send(event, payload);
}

/**
 * Binds an xstate machine to a destroyable context (component, service, ...)
 * via a function-based resource. Re-evaluates `setup` when its tracked
 * dependencies change, restarting the interpreter with the new machine.
 */
export function useMachine<M extends AnyMachine>(
  context: object,
  setup: () => MachineSetup<M>
): Statechart<M> {
  const box = new StateBox();

  return resource(context, ({ on }) => {
    const { machine, initialState, onTransition, interpreterOptions } = setup();

    const interpreter: any = interpret(machine, interpreterOptions);

    interpreter.onTransition((state: { changed?: boolean }) => {
      if (state.changed || state.changed === undefined) {
        box.state = state;
      }
    });

    if (onTransition) {
      interpreter.onTransition(onTransition);
    }

    // start() synchronously delivers the initial state through onTransition
    interpreter.start(initialState ?? interpreter.machine.initialState);
    box.interpreter = interpreter;

    // v6 lifecycle: runs when the resource re-runs (deps changed) *and* when
    // the context is destroyed — replaces manual stop()/registerDestructor
    on.cleanup(() => {
      if (box.interpreter === interpreter) {
        box.interpreter = undefined;
      }

      interpreter.stop();
    });

    // resource values must be objects; property reads land on the box
    return box;
  });
}
/* eslint-enable @typescript-eslint/no-explicit-any, @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-unsafe-return */
