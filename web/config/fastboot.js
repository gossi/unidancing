module.exports = function () {
  return {
    buildSandboxGlobals(defaultGlobals) {
      return {
        ...defaultGlobals,
        ...{
          AbortController,
          fetch,
          Headers: typeof Headers !== 'undefined' ? Headers : undefined
        }
      };
    }
  };
};
