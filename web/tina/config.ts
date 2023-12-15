import { defineConfig } from 'tinacms';
import { schema } from './schema';
// this does not run in a browser
// environment, keep it commented, you fool!
// import process from 'node:process';


// Your hosting provider likely exposes this as an environment variable
const branch = process.env.CF_PAGES_BRANCH || 'main';
const prod = process.env.PROD ?? false;

export default defineConfig({
  branch,
  clientId: process.env.TINA_CLIENT_ID,
  token: process.env.TINA_TOKEN,
  localContentPath: "../../content",

  // build: {
  //   outputFolder: "admin",
  //   publicFolder: "public",
  // },
  build: {
    outputFolder: "admin",
    publicFolder: prod ? "dist" : 'public',
  },
  media: {
    tina: {
      mediaRoot: "",
      publicFolder: "public",
    },
  },
  schema
});
