import Controller from '@ember/controller';
import { service, Registry as Services } from '@ember/service';

export default class DanceMixController extends Controller {
  @service declare spotify: Services['spotify'];
}
