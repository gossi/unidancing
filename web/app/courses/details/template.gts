import RouteTemplate from 'ember-route-template';
import pageTitle from 'ember-page-title/helpers/page-title';
import styles from './styles.css';
import type { Course } from '../../database/courses';
import type { Link } from 'ember-link';
import Exercise from '../../exercises/-components/teaser';
import VideoPlayer from '../../components/video-player';
import { htmlSafe } from '@ember/template';

interface Signature {
  Args: {
    model: {
      course: Course;
      buildExerciseLink: (exercise: string) => Link;
    };
  };
}

const add1 = (number: number) => {
  return number +1;
}

const pickExamples = (videos: string[]) => {
  return videos.sort(() => 0.5 - Math.random()).slice(0, 2);
}

export default RouteTemplate<Signature>(<template>
  {{pageTitle @model.course.title}}

  <h1>{{@model.course.title}}</h1>

  {{#if @model.course.about}}
      <p>{{htmlSafe @model.course.about}}</p>
    {{/if}}

  <div class='grid'>
    <div>
      <h2>Lernziele</h2>

      <ul class={{styles.goals}}>
        {{#each @model.course.learn as |learn|}}
          <li>{{learn}}</li>
        {{/each}}
      </ul>
    </div>

    <div>
      <h2>Kursinhalte</h2>

      <ol class={{styles.contents}}>
        {{#each @model.course.lessons as |lesson idx|}}
          <li><a href="#lesson-{{add1 idx}}">{{lesson.title}}</a></li>
        {{/each}}
      </ol>
    </div>

  </div>

  {{#if @model.course.examples}}
  <h2>Beispiele</h2>

  <div class={{styles.examples}}>
    {{#each (pickExamples @model.course.examples) as |url|}}
      <VideoPlayer @url={{url}}/>
    {{/each}}
  </div>
  {{/if}}

  <h2 class={{styles.lessons}}>Trainingseinheiten</h2>

  {{#each @model.course.lessons as |lesson idx|}}
    <h3 class={{styles.lesson}} id="lesson-{{add1 idx}}">{{lesson.title}}</h3>

    {{#if lesson.description}}
      <p>{{lesson.description}}</p>
    {{/if}}

    <div class={{styles.units}}>
      {{#each lesson.exercises as |ex|}}
        <Exercise @exercise={{ex}} @link={{@model.buildExerciseLink ex.id}} />
      {{/each}}
    </div>
  {{/each}}
</template>);
