module.exports = function () {
  return {
    buildSandboxGlobals(defaultGlobals) {
      return {
        ...defaultGlobals,
        ...{
          URL,
          URLSearchParams,
          AbortController,
          AbortSignal,
          fetch: typeof fetch !== 'undefined' ? fetch : undefined,
          Headers: typeof Headers !== 'undefined' ? Headers : undefined
        }
      };
    }
  };
};
