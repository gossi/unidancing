// Vendored replacement for ember-statecharts (unmaintained since 2023, built
// on the legacy class-based `Resource` API which ember-resources v7 removes).
// This implements the same `useMachine` contract with plain function-based
// wiring: an eagerly booted, tracked handle object — no `Resource` subclass,
// no lazy `resource()` proxy (whose property reads do not participate in
// render tracking the same way plain fields do).
//
// See https://github.com/LevelbossMike/ember-statecharts for the original;
// deliberate deviations:
// - no `update` option (the machine is booted once, like every consumer here)
// - no `config:environment` / `runloopClockService` lookup (never configured
//   in this app, and unresolvable in the strict resolver setup anyway)

import { tracked } from '@glimmer/tracking';
import { registerDestructor } from '@ember/destroyable';

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
  // NOTE: the `= undefined` initializer is required: with babel's
  // allowDeclareFields, a type-annotated field without initializer is erased
  // as a type-only declaration — @tracked would silently become a plain
  // property and never invalidate renders.
  @tracked state: any = undefined;

  interpreter: any;

  // stable identity; reads the live interpreter
  send = (event: any, payload?: any) => this.interpreter?.send(event, payload);
}

/**
 * Binds an xstate machine to a destroyable context (component, service, ...).
 *
 * The machine boots immediately (like the legacy `Statechart.from()`, which
 * evaluated eagerly at creation) and the returned value is a plain object with
 * a `@tracked state` — so templates subscribe to it exactly like any other
 * tracked field, and `send` transitions re-render reliably.
 */
export function useMachine<M extends AnyMachine>(
  context: object,
  setup: () => MachineSetup<M>
): Statechart<M> {
  const { machine, initialState, onTransition, interpreterOptions } = setup();

  const box = new StateBox();

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
  interpreter.start(initialState ?? machine.initialState);
  box.interpreter = interpreter;

  registerDestructor(context, () => {
    box.interpreter = undefined;
    interpreter.stop();
  });

  return box;
}
/* eslint-enable @typescript-eslint/no-explicit-any, @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-unsafe-return */
