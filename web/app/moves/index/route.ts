import Route from '@ember/routing/route';
import { MoveResource } from '../resource';

export default class MoveIndexRoute extends Route {
  resource = MoveResource.from(this);

  model() {
    return this.resource.moves;
  }
}
