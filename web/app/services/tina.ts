import Service from '@ember/service';

import { client } from './-tina/client';

export default class TinaService extends Service {
  client = client;
}
