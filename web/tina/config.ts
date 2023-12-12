import { defineConfig } from 'tinacms';
import { schema } from './schema';
import process from 'node:process';

// Your hosting provider likely exposes this as an environment variable
const branch = process.env.CF_PAGES_BRANCH || 'main';

export default defineConfig({
  branch,
  clientId: process.env.TINA_CLIENT_ID,
  token: process.env.TINA_TOKEN,

  build: {
    outputFolder: "admin",
    publicFolder: "public",
  },
  media: {
    tina: {
      mediaRoot: "",
      publicFolder: "public",
    },
  },
  schema
});
