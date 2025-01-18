import { resource, resourceFactory } from 'ember-resources';
import { sweetenOwner } from 'ember-sweet-owner';

// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
import { client } from '../../supporting/tina';
import { cacheResult } from '../../supporting/utils';

import type { Course } from './-types';
import type { CourseConnectionEdges } from '@/tina/types';
import type { LinkManagerService } from 'ember-link';

export const findCourses = resourceFactory(() => {
  return resource(async ({ owner }): Promise<Course[]> => {
    return cacheResult('courses', owner, async () => {
      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-member-access
      const courseResponse = await client.queries.courseConnection();

      return (
        // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
        (courseResponse.data.courseConnection.edges as CourseConnectionEdges[] | undefined)?.map(
          (ex) => ex.node
        ) as Course[]
      );
    });
  });
});

export const findCourse = resourceFactory((id: string) => {
  return resource(async ({ owner }): Promise<Course> => {
    return cacheResult(`course-${id}`, owner, async () => {
      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-member-access
      const courseResponse = await client.queries.course({ relativePath: `${id}.md` });

      // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
      return courseResponse.data.course as Course;
    });
  });
});

export const buildCourseLink = resourceFactory((course: string) => {
  return resource(({ owner }) => {
    const { services } = sweetenOwner(owner);
    const { linkManager } = services;

    return (linkManager as LinkManagerService).createLink({
      route: 'courses.details',
      models: [course]
    });
  });
});
