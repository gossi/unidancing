'use strict';

const { addonV1Shim } = require('@embroider/addon-shim');
const fs = require('fs');
const path = require('path');
const process = require('process');
const funnel = require('broccoli-funnel');
const MergeTrees = require('broccoli-merge-trees');
const { BroccoliMergeFiles } = require('broccoli-merge-files');
const WatchedDir = require('broccoli-source').WatchedDir;
const markdownJson = require('markdown-json');


function treeForDatabase(folder, dbFile, distFolder) {
  if (fs.existsSync(folder)) {
    const tree = new WatchedDir(folder);

    // must end in json
    const distFile = path.join(distFolder, dbFile).replace('.js', '.json');

    const dbFileTree = new BroccoliMergeFiles([tree], {
      outputFileName: path.basename(dbFile),
      merge: async () => {
        const settings = {
          name: 'markdown-json',
          cwd: process.cwd(),
          dist: distFile,
          src: folder,
          ignore: '',
          filePattern: '**/*.md',
          metadata: false,
          server: false,
          deterministicOrder: false,
          display: false
        };

        const raw = await markdownJson(settings);
        const db = {};

        for (const [file, data] of Object.entries(raw)) {
          data.id = file.replace('.html', '');
          data.contents = data.contents.toString();
          delete data.mode;
          delete data.stats;
          db[data.id] = data;
        }

        const contents = dbFile.endsWith('json') 
          ? JSON.stringify(db) 
          : `export default ${JSON.stringify(db)};`;

        return contents;
      }
    });

    return funnel(dbFileTree, {
      destDir: path.dirname(dbFile)
    });
  }
}

const addonShim = addonV1Shim(__dirname);

module.exports = {
  ...addonShim,

  treeForApp() {
    const trees = [];
    let options = this.app.options['ember-markdown-db'];

    for (const entry of options) {
      const dbTree = treeForDatabase(entry.folder, entry.file, path.join(this.project.root, 'dist'));
      if (dbTree) {
        trees.push(dbTree);
      }
    }

    return new MergeTrees(trees, { overwrite: true });
  },
}