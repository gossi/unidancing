module.exports = function () {
  return {
    buildSandboxGlobals(defaultGlobals) {
      return {
        ...defaultGlobals,
        ...{
          AbortController,
          AbortSignal,
          fetch,
          Headers: typeof Headers !== 'undefined' ? Headers : undefined
        }
      };
    }
  };
};
