declare module '@unidancing/app/config/environment' {
  export default config;

  /**
   * Type declarations for
   *    import config from 'my-app/config/environment'
   */
  declare const config: {
    environment: string;
    modulePrefix: string;
    podModulePrefix: string;
    locationType: 'history' | 'hash' | 'none' | 'auto';
    rootURL: string;
    APP: Record<string, unknown> & {
      // eslint-disable-next-line @typescript-eslint/naming-convention
      YOUTUBE_API_KEY: string;
    };
    workerHostURL: string;
  };
}
