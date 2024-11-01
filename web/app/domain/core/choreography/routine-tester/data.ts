import type { WireJudgingSystemResults } from './domain-objects';

const results: WireJudgingSystemResults = {
  parts: [
    {
      name: 'artistic',
      categories: [
        {
          name: 'execution',
          criteria: [
            { name: 'presence', value: 5 },
            { name: 'carriage', value: 5 },
            { name: 'style', value: 5 },
            { name: 'clarity', value: 5 },
            { name: 'variety', value: 5 },
            { name: 'projection', value: 5 }
          ]
        },
        {
          name: 'choreography',
          criteria: [
            { name: 'purpose', value: 5 },
            { name: 'harmony', value: 5 },
            { name: 'utilization', value: 5 },
            { name: 'dynamics', value: 5 },
            { name: 'imaginativeness', value: 5 }
          ]
        },
        {
          name: 'music',
          criteria: [
            { name: 'realization', value: 5 },
            { name: 'expression', value: 5 },
            { name: 'finesse', value: 5 },
            { name: 'timing', value: 5 }
          ]
        }
      ]
    }
  ]
};
