import { resource, resourceFactory } from 'ember-resources';
import { sweetenOwner } from 'ember-sweet-owner';

import type { Course } from '.';
import type { LinkManagerService } from 'ember-link';

export const findCourses = resourceFactory(() => {
  return resource(async ({ owner }): Promise<Course[]> => {
    const { services } = sweetenOwner(owner);
    const { tina } = services;

    const courseResponse = await tina.client.queries.courseConnection();

    return courseResponse.data.courseConnection.edges?.map((ex) => ex?.node) as Course[];
  });
});

export const findCourse = resourceFactory((id: string) => {
  return resource(async ({ owner }): Promise<Course> => {
    const { services } = sweetenOwner(owner);
    const { tina } = services;

    const courseResponse = await tina.client.queries.course({ relativePath: `${id}.md` });

    return courseResponse.data.course as Course;
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
