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
// - xstate v5: no `initialState` / `interpreterOptions` (v5 actors start from
//   the machine's initial state only, restore via a `snapshot` option instead
//   of `devTools`, and no consumer here used either)
// - xstate v5 `send()` only accepts event objects; the v4 `send(type, payload)`
//   string form is normalized to `{ type, ...payload }` inside the wrapper, so
//   templates and call sites keep the ember-statecharts contract unchanged

import { tracked } from '@glimmer/tracking';
import { registerDestructor } from '@ember/destroyable';

import { createActor } from 'xstate';

import type { AnyStateMachine, EventFrom, SnapshotFrom } from 'xstate';

export interface MachineSetup<M extends AnyStateMachine> {
  machine: M;
}

export interface Statechart<M extends AnyStateMachine> {
  /**
   * The last snapshot delivered by the actor. The `| undefined` union (as
   * in the original addon) also matters for mapped-type consumers: hokulea's
   * `FieldNames<DATA>` stops recursing at unions, avoiding a circular
   * `Snapshot <-> StateMachine` expansion (TS2615) when a machine ends up
   * inside `@form` data.
   */
  readonly state: SnapshotFrom<M> | undefined;

  send(event: EventFrom<M> | string, payload?: Record<string, unknown>): void;
}

// xstate's generic machinery erases through the loose `AnyStateMachine` bound
// (deferred `SnapshotFrom<M>` etc. never line up), so the internals are typed
// loosely and narrowed once at the public boundary.
/* eslint-disable @typescript-eslint/no-explicit-any, @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-unsafe-return */
class StateBox {
  // NOTE: the `= undefined` initializer is required: with babel's
  // allowDeclareFields, a type-annotated field without initializer is erased
  // as a type-only declaration — @tracked would silently become a plain
  // property and never invalidate renders.
  @tracked state: any = undefined;

  // Untracked mirror of the latest snapshot. The subscription consults this
  // to skip no-change emissions; reading the `state` field there instead
  // would consume its tracked tag in the very render computation that boots
  // the machine (start() emits synchronously), and the follow-up write would
  // then trip Glimmer's "modified after use in the same computation"
  // assertion.
  snapshot: any = undefined;

  actor: any;

  // stable identity; reads the live actor
  send = (event: any, payload?: any) =>
    this.actor?.send(typeof event === 'string' ? { type: event, ...payload } : event);
}

/**
 * Binds an xstate machine to a destroyable context (component, service, ...).
 *
 * The machine boots immediately (like the legacy `Statechart.from()`, which
 * evaluated eagerly at creation) and the returned value is a plain object with
 * a `@tracked state` — so templates subscribe to it exactly like any other
 * tracked field, and `send` transitions re-render reliably.
 */
export function useMachine<M extends AnyStateMachine>(
  context: object,
  setup: () => MachineSetup<M>
): Statechart<M> {
  const { machine } = setup();

  const box = new StateBox();

  const actor: any = createActor(machine);

  box.actor = actor;

  const sync = (snapshot: any) => {
    // v5 snapshots have no `changed` flag (v4 used it to skip no-op
    // emissions); the identity check against the untracked mirror keeps a
    // re-emitted snapshot from dirtying the tracked field and re-rendering
    // for nothing — and never reads `box.state`, which would poison the boot
    // computation (see the `snapshot` field note on StateBox).
    if (snapshot === box.snapshot) {
      return;
    }

    // Glimmer invokes template calls like `{{this.state.matches "x"}}` as
    // detached functions (FunctionHelperManager drops the receiver). v4's
    // State carried `matches` as a bound arrow property; v5's snapshot
    // method reads `this.value` and throws without a receiver — rebind it on
    // each fresh snapshot so the templates keep working unchanged.
    snapshot.matches = snapshot.matches.bind(snapshot);

    box.snapshot = snapshot;
    box.state = snapshot;
  };

  actor.subscribe(sync);

  // start() synchronously delivers the initial snapshot to subscribers that
  // attached beforehand (as v4's did); the `getSnapshot()` sync makes the
  // guarantee explicit for any actor logic that would not emit on start.
  actor.start();

  sync(actor.getSnapshot());

  registerDestructor(context, () => {
    box.actor = undefined;
    actor.stop();
  });

  return box;
}
/* eslint-enable @typescript-eslint/no-explicit-any, @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-unsafe-return */
