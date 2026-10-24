// Public way to configure Ember: the `EmberENV` global is read when the first
// Ember module is evaluated ("The `EmberENV` hash must be created before
// loading Ember" — see the EmberENV docs block in ember-source's environment
// module). vitest loads setup files before each test module, so this runs
// before Ember is loaded — that mutes the `Ember : x.y.z` boot banner for the
// whole test run.
//
// Deliberately:
// - no `import.meta.env.MODE` guard: setup files only ever run under vitest,
//   and the runner does not guarantee the dev server resolves mode to
//   exactly 'test' — a guard here is dead weight that can silently disable
//   the muting.
// - no `@ember/-internals/environment` import: that module path is private
//   API; the global hash below is the documented configuration surface.
declare global {
  var EmberENV: Record<string, unknown> | undefined;
}

// eslint-disable-next-line unicorn/no-global-object-property-assignment -- this is exactly Ember's documented configuration surface
globalThis.EmberENV = {
  ...globalThis.EmberENV,
  LOG_VERSION: false
};

export {};
