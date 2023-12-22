import RouteTemplate from 'ember-route-template';
import { load } from 'ember-async-data';
import { findArts } from './resource';
import { ArtTree } from './-components';
import styles from './styles.css';

export default RouteTemplate(<template>
  <h1>Künste</h1>

  <p>Kunstformen die für UniDancing und deren Umsetzung auf dem Einrad geeignet sind.</p>

  {{#let (load (findArts)) as |r|}}
    {{#if r.isResolved}}
      <div class={{styles.layout}}>
        <ArtTree @arts={{r.value}}/>

        {{outlet}}
      </div>
    {{/if}}
  {{/let}}
</template>);
