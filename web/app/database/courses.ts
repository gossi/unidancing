import { Model } from './base';

import type DataService from '../services/data';
import type { Exercise } from './exercises';
import type { CourseWireFormat, LessonWireFormat } from '@unidancing/database/courses.json';

export interface Lesson {
  title: string;
  description: string;
  exercises: Exercise[];
}

export class Course extends Model {
  #service: DataService;
  #raw: CourseWireFormat;

  about: string;
  learn: string[];
  examples: string[];

  #lessons?: Lesson[];

  constructor(service: DataService, base: CourseWireFormat) {
    super(base);

    this.#service = service;
    this.#raw = base;

    this.about = base.about;
    this.learn = base.learn;
    this.examples = base.examples;
  }

  get lessons() {
    if (!this.#lessons) {
      this.#lessons = this.#raw.lessons.map((lesson: LessonWireFormat) => {
        return {
          title: lesson.title,
          description: lesson.description,
          exercises: lesson.exercises
            .map((exercise: string) => {
              return this.#service.findOne('exercises', exercise) as Exercise;
            })
            .filter(Boolean)
        };
      });
    }

    return this.#lessons;
  }
}
