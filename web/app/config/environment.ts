const ENV = {
  modulePrefix: '@unidancing/app',
  environment: import.meta.env.MODE === 'production' ? 'production' : 'development',
  rootURL: '/',
  locationType: 'history',
  EmberENV: {
    FEATURES: {},
    EXTEND_PROTOTYPES: false
  },

  // See config of the Vite world: values are baked in at build time via
  // import.meta.env (Vite loads .env files; envPrefix exposes them).
  workerHostURL: import.meta.env.DEV ? 'http://127.0.0.1:8787' : 'https://connect.unidancing.art',

  APP: {
    YOUTUBE_API_KEY: import.meta.env.YOUTUBE_API_KEY as string | undefined
  }
};

export default ENV;
