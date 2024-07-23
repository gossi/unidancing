import { LinkTo } from '@ember/routing';

import { pageTitle } from 'ember-page-title';
import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

import Listing from '../-components/listing';

export class ChoreographyNotTodoListRoute extends Route<object> {
  <template>
    {{pageTitle 'Not Todo Liste'}}

    <h2>Not Todo Liste</h2>

    <p>
      UniDancing als technisch-kompositorische Sportart konkurriert mit Turnen,
      Eiskunstlauf, Rhythmische-Sportgymnastik, Tanzen und ähnlichen Sportarten um
      die Gunst der Zuschauer.
      Es ist die „Ästhetik der Perfektion körperlicher Abläufe und
      Synchronisationen“ (Bette, 2011, S. 25) die die Sehlust des Publikums
      bedient und hierbei schneidet UniDancing im Vergleich zu den etablierten
      Sportarten unterirdisch ab, genauer erklärt in <a
      href="https://einradfahren.de/uniscience/2016/10/23/die-freestyle-revolution-mach-kunst-kein-kitsch/"
      target="_blank">Die Freestyle (R)evolution: Mach Kunst, kein Kitsch!</a>.<br>

      Über die Jahre haben sich
      <i>Dinge</i>
      angehäuft, die sich als eher
      <b>problematisch</b>
      für eine
      <i>ansprechende</i>
      Kür gezeigt haben. Die sind hier gelistet, so können zukünftige Generationen aus den Fehlern der
      vorigen Lernen.
    </p>

    <p>
      Die Liste hier benennt und erklärt diese Dinge und das <LinkTo
      @route="games" @model="bingo">Bingo</LinkTo>
      vermittelt diese auf humoristische und selbst-ironische Art und Weise.
    </p>

    <p>
      Bette, K.-H. (2011). <i>Sportsoziologische Aufklärung – Studien zum Sport der modernen Gesellschaft</i>. transcript: Bielefeld.
    </p>

    <Listing />
  </template>
}

export default CompatRoute(ChoreographyNotTodoListRoute);
