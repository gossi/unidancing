import { Command } from 'ember-command';
import { service, Registry as Services } from '@ember/service';

export class LoginWithSpotify extends Command {
  @service declare spotify: Services['spotify'];
  @service declare router: Services['router'];

  execute() {
    localStorage.setItem('redirectAfterLogin', this.router.currentURL);
  }
}
