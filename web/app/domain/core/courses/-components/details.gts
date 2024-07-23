import { Page } from '@hokulea/ember';

import { VideoPlayer } from '../../../supporting/ui';
import { ExerciseTeaser } from '../../exercises';
import styles from './details.css';

import type { Exercise } from '../../exercises';
import type { Course } from '..';
import type { Maybe } from '@/tina/types';
import type { TOC } from '@ember/component/template-only';

export interface CourseDetailsSignature {
  Args: {
    course: Course;
  };
}

const add1 = (number: number) => {
  return number +1;
}

const pickExamples = (videos: string[]) => {
  return videos.sort(() => 0.5 - Math.random()).slice(0, 2);
}

const asStringArray = (strings: Maybe<string>[]): string[] => {
  return strings as string[];
}

const asExercise = (exercise?: Maybe<Exercise>): Exercise => {
  return exercise as Exercise;
}

const CourseDetails: TOC<CourseDetailsSignature> = <template>
  <Page @title={{@course.title}} @description={{@course.about}}>
    <div class='grid'>
      <div>
        <h2>Lernziele</h2>

        <ul class={{styles.goals}}>
          {{#each @course.learn as |learn|}}
            <li>{{learn}}</li>
          {{/each}}
        </ul>
      </div>

      <div>
        <h2>Kursinhalte</h2>

        <ol class={{styles.contents}}>
          {{#each @course.lessons as |lesson idx|}}
            <li><a href="#lesson-{{add1 idx}}">{{lesson.title}}</a></li>
          {{/each}}
        </ol>
      </div>

    </div>

    {{#if @course.examples}}
    <h2>Beispiele</h2>

    <div class={{styles.examples}}>
      {{#each (pickExamples (asStringArray @course.examples)) as |url|}}
        <VideoPlayer @url={{url}}/>
      {{/each}}
    </div>
    {{/if}}

    <h2 class={{styles.lessons}}>Trainingseinheiten</h2>

    {{#each @course.lessons as |lesson idx|}}
      <h3 class={{styles.lesson}} id="lesson-{{add1 idx}}">{{lesson.title}}</h3>

      {{#if lesson.description}}
        <p>{{lesson.description}}</p>
      {{/if}}

      <div class={{styles.units}}>
        {{#each lesson.exercises as |ex|}}
          <ExerciseTeaser @exercise={{(asExercise ex.data)}} />
        {{/each}}
      </div>
    {{/each}}

    {{!-- {{#each @art.techniques as |technique|}}

    {{/each}} --}}

  </Page>


</template>

export { CourseDetails };
