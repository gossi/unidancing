import Controller from '@ember/controller';
import { service } from '@ember/service';
import SpotifyService from '../services/spotify';

export default class ApplicationController extends Controller {
  @service declare spotify: SpotifyService;
}
