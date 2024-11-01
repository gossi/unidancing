/* eslint-disable @typescript-eslint/naming-convention */
import type { JudgingSystem } from './domain-objects';

export const judgingSystem: JudgingSystem = {
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
              intervals: {
                '>=9': '9-presence',
                '>=8': '8-presence',
                '>=7': '7-presence',
                '>=6': '6-presence',
                '>=4': '4-presence',
                '>=2': '2-presence',
                '>=1': '1-presence',
                '>=0': '0-presence'
              }
            },
            {
              name: 'carriage',
              intervals: {
                '>=9': '9-carriage',
                '<9': '8-carriage',
                '<8': '7-carriage',
                '<7': '6-carriage',
                '<6': '5-carriage',
                '<5': '4-carriage',
                '<4': '3-carriage',
                '<3': '2-carriage',
                '<2': '1-carriage',
                '<1': '0-carriage'
              }
            },
            {
              name: 'style',
              intervals: {
                '>=9': '9-authenticity',
                '>=8': '8-authenticity',
                '>=7': '7-authenticity',
                '>=6': '6-authenticity',
                '>=4': '4-authenticity',
                '>=2': '2-authenticity',
                '>=1': '1-authenticity',
                '>=0': '0-authenticity'
              }
            },
            {
              name: 'clarity',
              intervals: {
                '>=9': '9-clarity',
                '>=6': '6-clarity',
                '>=3': '3-clarity',
                '>=1': '1-clarity',
                '>=0': '0-clarity'
              }
            },
            {
              name: 'variety',
              intervals: {
                '>=9': '9-variety',
                '>=6': '6-variety',
                '>=4': '4-variety',
                '>=2': '2-variety',
                '>=1': '1-variety',
                '>=0': '0-variety'
              }
            },
            {
              name: 'projection',
              intervals: {
                '<1': '0-projection',
                '<2': '1-projection',
                '<3': '2-projection',
                '<4': '3-projection',
                '<5': '4-projection',
                '<6': '5-projection',
                '<7': '6-projection',
                '<8': '7-projection',
                '<9': '8-projection',
                '>=9': '9-projection'
              }
            }
          ]
        },
        {
          name: 'choreography',
          scoring: 'average',
          criteria: [
            {
              name: 'purpose',
              intervals: {
                '>=9': '9-purpose',
                '>=8': '8-purpose',
                '>=7': '7-purpose',
                '>=6': '6-purpose',
                '>=5': '5-purpose',
                '>=4': '4-purpose',
                '>=3': '3-purpose',
                '>=2': '2-purpose',
                '>=1': '1-purpose',
                '>=0': '0-purpose'
              }
            },
            {
              name: 'harmony',
              intervals: {
                '>=9': '9-harmony',
                '>=7': '7-harmony',
                '>=5': '5-harmony',
                '>=3': '3-harmony',
                '>=1': '1-harmony',
                '>=0': '0-harmony'
              }
            },
            {
              name: 'utilization',
              intervals: {
                '>=9': '9-utilization',
                '>=8': '8-utilization',
                '>=7': '7-utilization',
                '>=6': '6-utilization',
                '>=5': '5-utilization',
                '>=2': '2-utilization',
                '>=0': '0-utilization'
              }
            },
            {
              name: 'dynamics',
              intervals: {
                '>=9': '9-dynamics',
                '>=8': '8-dynamics',
                '>=7': '7-dynamics',
                '>=6': '6-dynamics',
                '>=3': '3-dynamics',
                '>=1': '1-dynamics',
                '>=0': '0-dynamics'
              }
            },
            {
              name: 'imaginativeness',
              intervals: {
                '>=9': '9-imaginativeness',
                '>=7': '7-imaginativeness',
                '>=6': '6-imaginativeness',
                '>=5': '5-imaginativeness',
                '>=3': '3-imaginativeness',
                '>=1': '1-imaginativeness',
                '>=0': '0-imaginativeness'
              }
            }
          ]
        },
        {
          name: 'music',
          scoring: 'average',
          criteria: [
            {
              name: 'realization',
              intervals: {
                '>=9': '9-realization',
                '>=5': '5-realization',
                '>=2': '2-realization',
                '>=0': '0-realization'
              }
            },
            {
              name: 'expression',
              intervals: {
                '>=9': '9-expression',
                '>=5': '5-expression',
                '>=2': '2-expression',
                '>=0': '0-expression'
              }
            },
            {
              name: 'finesse',
              intervals: {
                '>=9': '9-finesse',
                '>=5': '5-finesse',
                '>=2': '2-finesse',
                '>=0': '0-finesse'
              }
            },
            {
              name: 'timing',
              intervals: {
                '>=9': '9-timing',
                '>=5': '5-timing',
                '>=2': '2-timing',
                '>=0': '0-timing'
              }
            }
          ]
        }
      ]
    }
  ]
};
