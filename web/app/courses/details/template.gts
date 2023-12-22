import RouteTemplate from 'ember-route-template';
import { pageTitle } from 'ember-page-title';
import { load } from 'ember-async-data';
import { CourseDetails } from '../-components';
import { findCourse } from '../resource';

interface Signature {
  Args: {
    model: {
      id: string;
    }
  }
}

export default RouteTemplate<Signature>(<template>
  {{#let (load (findCourse @model.id)) as |r|}}
    {{#if r.isResolved}}
      {{pageTitle r.value.title}}

      <CourseDetails @course={{r.value}} />
    {{/if}}
  {{/let}}
</template>);
