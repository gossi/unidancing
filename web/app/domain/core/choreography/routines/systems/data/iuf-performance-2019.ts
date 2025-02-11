/* eslint-disable @typescript-eslint/naming-convention */
import type { JudgingSystemDescriptor } from '../../systems/domain-objects';

export const IUF_PERFORMANCE_2019: JudgingSystemDescriptor = {
  name: 'iuf-performance-2019',
  scoring: 'average',
  parts: [
    {
      name: 'performance',
      scoring: 'sum',
      categories: [
        {
          name: 'execution',
          scoring: 'average',
          criteria: [
            {
              name: 'presence',
              intervals: [
                {
                  marker: 9,
                  expression: 'x >= 9'
                },
                {
                  marker: 8,
                  expression: '9 > x >= 8'
                },
                {
                  marker: 7,
                  expression: '8 > x >= 7'
                },
                {
                  marker: 6,
                  expression: '7 > x >= 6'
                },
                {
                  marker: 4,
                  expression: '6 > x >= 4'
                },
                {
                  marker: 2,
                  expression: '4 > x >= 2'
                },
                {
                  marker: 1,
                  expression: '2 > x >= 1'
                },
                {
                  marker: 0,
                  expression: 'x < 1'
                }
              ]
            },
            {
              name: 'carriage',
              intervals: [
                {
                  marker: 9,
                  expression: 'x >= 9'
                },
                {
                  marker: 8,
                  expression: '9 > x >= 8'
                },
                {
                  marker: 7,
                  expression: '8 > x >= 7'
                },
                {
                  marker: 6,
                  expression: '7 > x >= 6'
                },
                {
                  marker: 5,
                  expression: '6 > x >= 5'
                },
                {
                  marker: 4,
                  expression: '5 > x >= 4'
                },
                {
                  marker: 3,
                  expression: '4 > x >= 3'
                },
                {
                  marker: 2,
                  expression: '3 > x >= 2'
                },
                {
                  marker: 1,
                  expression: '2 > x >= 1'
                },
                {
                  marker: 0,
                  expression: 'x < 1'
                }
              ]
            },
            {
              name: 'authenticity',
              intervals: [
                {
                  marker: 9,
                  expression: 'x >= 9'
                },
                {
                  marker: 8,
                  expression: '9 > x >= 8'
                },
                {
                  marker: 7,
                  expression: '8 > x >= 7'
                },
                {
                  marker: 6,
                  expression: '7 > x >= 6'
                },
                {
                  marker: 4,
                  expression: '6 > x >= 4'
                },
                {
                  marker: 2,
                  expression: '4 > x >= 2'
                },
                {
                  marker: 1,
                  expression: '2 > x >= 1'
                },
                {
                  marker: 0,
                  expression: 'x < 1'
                }
              ]
            },
            {
              name: 'clarity',
              intervals: [
                {
                  marker: 9,
                  expression: 'x >= 9'
                },
                {
                  marker: 6,
                  expression: '9 > x >= 6'
                },
                {
                  marker: 3,
                  expression: '6 > x >= 3'
                },
                {
                  marker: 1,
                  expression: '3 > x >= 1'
                },
                {
                  marker: 0,
                  expression: 'x < 1'
                }
              ]
            },
            {
              name: 'variety',
              intervals: [
                {
                  marker: 9,
                  expression: 'x >= 9'
                },
                {
                  marker: 6,
                  expression: '9 > x >= 6'
                },
                {
                  marker: 4,
                  expression: '6 > x >= 4'
                },
                {
                  marker: 2,
                  expression: '4 > x >= 2'
                },
                {
                  marker: 1,
                  expression: '2 > x >= 1'
                },
                {
                  marker: 0,
                  expression: 'x < 1'
                }
              ]
            },
            {
              name: 'projection',
              intervals: [
                {
                  marker: 9,
                  expression: 'x >= 9'
                },
                {
                  marker: 8,
                  expression: '9 > x >= 8'
                },
                {
                  marker: 7,
                  expression: '8 > x >= 7'
                },
                {
                  marker: 6,
                  expression: '7 > x >= 6'
                },
                {
                  marker: 5,
                  expression: '6 > x >= 5'
                },
                {
                  marker: 4,
                  expression: '5 > x >= 4'
                },
                {
                  marker: 3,
                  expression: '4 > x >= 3'
                },
                {
                  marker: 2,
                  expression: '3 > x >= 2'
                },
                {
                  marker: 1,
                  expression: '2 > x >= 1'
                },
                {
                  marker: 0,
                  expression: 'x < 1'
                }
              ]
            }
          ]
        },
        {
          name: 'choreography',
          scoring: 'average',
          criteria: [
            {
              name: 'purpose',
              intervals: [
                {
                  marker: 9,
                  expression: 'x >= 9'
                },
                {
                  marker: 8,
                  expression: '9 > x >= 8'
                },
                {
                  marker: 7,
                  expression: '8 > x >= 7'
                },
                {
                  marker: 6,
                  expression: '7 > x >= 6'
                },
                {
                  marker: 5,
                  expression: '6 > x >= 5'
                },
                {
                  marker: 4,
                  expression: '5 > x >= 4'
                },
                {
                  marker: 3,
                  expression: '4 > x >= 3'
                },
                {
                  marker: 2,
                  expression: '3 > x >= 2'
                },
                {
                  marker: 1,
                  expression: '2 > x >= 1'
                },
                {
                  marker: 0,
                  expression: 'x < 1'
                }
              ]
            },
            {
              name: 'harmony',
              intervals: [
                {
                  marker: 9,
                  expression: 'x >= 9'
                },
                {
                  marker: 7,
                  expression: '9 > x >= 7'
                },
                {
                  marker: 5,
                  expression: '7 > x >= 5'
                },
                {
                  marker: 3,
                  expression: '5 > x >= 3'
                },
                {
                  marker: 1,
                  expression: '3 > x >= 1'
                },
                {
                  marker: 0,
                  expression: 'x < 1'
                }
              ]
            },
            {
              name: 'utilization',
              intervals: [
                {
                  marker: 9,
                  expression: 'x >= 9'
                },
                {
                  marker: 8,
                  expression: '9 > x >= 8'
                },
                {
                  marker: 7,
                  expression: '8 > x >= 7'
                },
                {
                  marker: 6,
                  expression: '7 > x >= 6'
                },
                {
                  marker: 5,
                  expression: '6 > x >= 5'
                },
                {
                  marker: 2,
                  expression: '5 > x >= 1'
                },
                {
                  marker: 0,
                  expression: 'x < 1'
                }
              ]
            },
            {
              name: 'dynamics',
              intervals: [
                {
                  marker: 9,
                  expression: 'x >= 9'
                },
                {
                  marker: 8,
                  expression: '9 > x >= 8'
                },
                {
                  marker: 7,
                  expression: '8 > x >= 7'
                },
                {
                  marker: 6,
                  expression: '7 > x >= 6'
                },
                {
                  marker: 3,
                  expression: '6 > x >= 3'
                },
                {
                  marker: 1,
                  expression: '3 > x >= 1'
                },
                {
                  marker: 0,
                  expression: 'x < 1'
                }
              ]
            },
            {
              name: 'imaginativeness',
              intervals: [
                {
                  marker: 9,
                  expression: 'x >= 9'
                },
                {
                  marker: 7,
                  expression: '9 > x >= 7'
                },
                {
                  marker: 6,
                  expression: '7 > x >= 6'
                },
                {
                  marker: 5,
                  expression: '6 > x >= 5'
                },
                {
                  marker: 3,
                  expression: '5 > x >= 3'
                },
                {
                  marker: 1,
                  expression: '3 > x >= 1'
                },
                {
                  marker: 0,
                  expression: 'x < 1'
                }
              ]
            }
          ]
        },
        {
          name: 'music',
          scoring: 'average',
          criteria: [
            {
              name: 'realization',
              intervals: [
                {
                  marker: 9,
                  expression: 'x >= 9'
                },
                {
                  marker: 5,
                  expression: '9 > x >= 5'
                },
                {
                  marker: 2,
                  expression: '5 > x >= 1'
                },
                {
                  marker: 0,
                  expression: 'x < 1'
                }
              ]
            },
            {
              name: 'expression',
              intervals: [
                {
                  marker: 9,
                  expression: 'x >= 9'
                },
                {
                  marker: 5,
                  expression: '9 > x >= 5'
                },
                {
                  marker: 2,
                  expression: '5 > x >= 1'
                },
                {
                  marker: 0,
                  expression: 'x < 1'
                }
              ]
            },
            {
              name: 'finesse',
              intervals: [
                {
                  marker: 9,
                  expression: 'x >= 9'
                },
                {
                  marker: 5,
                  expression: '9 > x >= 5'
                },
                {
                  marker: 2,
                  expression: '5 > x >= 1'
                },
                {
                  marker: 0,
                  expression: 'x < 1'
                }
              ]
            },
            {
              name: 'timing',
              intervals: [
                {
                  marker: 9,
                  expression: 'x >= 9'
                },
                {
                  marker: 5,
                  expression: '9 > x >= 5'
                },
                {
                  marker: 2,
                  expression: '5 > x >= 1'
                },
                {
                  marker: 0,
                  expression: 'x < 1'
                }
              ]
            }
          ]
        }
      ]
    }
  ]
};
