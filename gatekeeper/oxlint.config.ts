import node from '@gossi/config-oxlint/node';
import { defineConfig } from 'oxlint';

export default defineConfig(node(import.meta.dirname));
