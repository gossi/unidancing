import RouteTemplate from 'ember-route-template';
import { pageTitle } from 'ember-page-title';

export default RouteTemplate(<template>
  {{pageTitle 'Zeitaufteilung'}}

  <h1>Zeitaufteilung</h1>

  <p>Die Zeitaufteilung gibt einen interessanten Aufschluss über die Choreographie. Gemessen wird
    wieviel Zeit mit
    <b>Tricks</b>,
    <b>Artistik</b>,
    <b>Filler</b>
    und
    <b>Void</b>
    (nichts) verbracht wird. Aus diesem Test liegen vier Kenngrößen vor.</p>

  <dl>
    <dt>Tricks</dt>
    <dd>Die Zeit, die für Tricks verwendet wird.</dd>

    <dt>Artistik</dt>
    <dd>Die Zeit, die für Artistik verwendet wird.</dd>

    <dt>Filler</dt>
    <dd>Die Zeit, die für überflüssige Zeit in Tricks verwendet wird. Die überflüssige Zeit macht
      die Bewegung für den Zuschauer berechenbar und damit uninteressant. Darunter zählen zum
      Beispiel zu lange Glidings, an deren Ende ein weiterer Trick (z.B. Tipspin) folgt, ein
      Übergang von Wheel-Walk ins Cross-Over (das Bein stochert ewig, ehe es das Pedal trifft) oder
      zu viele Hüpfer während einer Hopping-Serie.</dd>

    <dd>Außerdem werden auch unnötige Ausgleichsbewegungen zur Herstellung des Gleichgewichts als
      Filler gezählt.</dd>

    <dt>Void</dt>
    <dd>Die Zeit, in der nichts passiert. Der Fahrer fährt vor sich hin, aber weder ein Trick noch
      Artistik werden gezeigt.</dd>
  </dl>

  <h3>Durchführung</h3>
  <p>
    Die Zeiten werden während einer Videoaufnahme gestoppt. Im Ergebnis steht zu jedem Messkriterium
    die gemessene Zeit. Die Messwerte werden in Relation zur Kürlänge gesetzt.
  </p>

  <h3>Auswertung</h3>
  <p>
    Tricks und Artistik sollten sich die Waage halten (plusminus ~10\%). Filler und keine Aktivität
    sollten nicht auftreten. Das sind wichtige Indikator für die Attraktivität einer Kür.
  </p>

  <h3>Fiktives Beispiel</h3>

  <p>Zum Start ein ausgedachtes Beispiel mit selbst erdachten Werten.</p>

  <p>Kürlänge: 4 Minuten (240 Sekunden)</p>

  <p>
    Die Tricks überwiegen eindeutig in dieser Kür (aber halten sich noch im Rahmen). Hingegen ist
    von der Artistik wenig zu sehen. Auffällig ist, dass insgesamt sehr wenig passiert und bei der
    Kür eher Flaute herrscht, die auch noch von vielen Filler Bewegungen verstärkt wird.
  </p>

  <h3>Beispiel: Kazuhiro Shimoyama</h3>

  <p>Auswertung von Kazuhiro Shimoyamas Kür an der Unicon 16 in Brixen (Italien).</p>

  <p>Kürlänge: 4 Minuten (240 Sekunden)</p>

  <table>
    <caption>Zeitaufteilung Kazuhiro Shimoyamas Kür an der Unicon 16 in Brixen (Italien)</caption>
    <thead>
      <tr>
        <th>Messkriterium</th>
        <th>Zeit [s]</th>
        <th>Verhältnis [%]</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>Tricks</td>
        <td>93</td>
        <td>38,8</td>
      </tr>
      <tr>
        <td>Artistik</td>
        <td>157</td>
        <td>65,4</td>
      </tr>
      <tr>
        <td>Filler</td>
        <td>2</td>
        <td>0,001</td>
      </tr>
      <tr>
        <td>Void</td>
        <td>0</td>
        <td>0</td>
      </tr>
    </tbody>
  </table>

  <p>Die Durchdringung von Artistik bei annähernd nicht vorhandenen Filler und Void ist
    beeindruckend. Die Pause von Artistik kommt nur durch die Tricks zustande, die seine volle
    Aufmerksamkeit erfordern, sonst findet Artistik auch während Tricks statt.</p>
</template>);
