module.exports = function () {
  return {
    buildSandboxGlobals(defaultGlobals) {
      return {
        ...defaultGlobals,
        ...{
          URL,
          AbortController,
          AbortSignal,
          fetch,
          Headers: typeof Headers !== 'undefined' ? Headers : undefined
        }
      };
    }
  };
};
