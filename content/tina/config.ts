import config from '../../web/tina/config';

const configWithCustomization = {
  ...config,
  media: {
    ...config.media,
    tina: {
      ...config.media?.tina,
      publicFolder: 'web/public'
    }
  }
};

export default configWithCustomization;