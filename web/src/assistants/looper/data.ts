import type { LoopTrackDescriptor } from './domain-objects';

export type Loops = LoopTrackDescriptor[];

export const data: Loops = [
  // Radioactive by Imagine Dragons
  {
    id: 'radioactive',
    trackId: '69yfbpvmkIaB10msnKT7Q5',
    loops: [
      {
        start: 27_787,
        end: 82_648,
        description: 'verse + chorus'
      }
    ]
  },
  // Vikings - Axe and Sword
  // https://open.spotify.com/track/4SnaUdWZrAIfmvwdclYWhn
  // {
  //   start: 82000,
  //   end: 115000,
  //   trackId: '4SnaUdWZrAIfmvwdclYWhn'
  // }
  // The Call
  // https://open.spotify.com/track/2iI556oF2qwtac9r1RzrXo
  {
    id: 'the-call',
    trackId: '2iI556oF2qwtac9r1RzrXo',
    loops: [
      {
        name: 'half-chorus+bridge',
        start: 70_000,
        end: 130_700,
        description: 'half first chorus (4/4) + bridge (6/8)'
      },
      {
        name: 'bridge',
        start: 90_100,
        end: 130_700,
        description: 'bridge (6/8)'
      },
      {
        name: 'chorus+bridge',
        start: 54_089,
        end: 130_700,
        description: 'full first chorus (4/4) + bridge (6/8)'
      }
    ]
  },
  // Underground by Lindsey Stirling
  // https://open.spotify.com//track/2vcEiEb8cTgyeb0biKChCY
  {
    id: 'underground',
    trackId: '2vcEiEb8cTgyeb0biKChCY',
    loops: [
      {
        start: 63_692,
        end: 130_065
      }
    ]
  },
  // Drakenblade by Epic North, Pauli Hausmann
  // https://open.spotify.com/track/7uKw84AAmdvMIdxNyMmhSi
  {
    id: 'drakenblade',
    trackId: '7uKw84AAmdvMIdxNyMmhSi',
    loops: [
      {
        start: 96_859,
        end: 149_846 // 149846
      }
    ]
  },
  // Archangel by Amaranthe
  // https://open.spotify.com/track/63aGgWIoGfl3wxykzje8eJ?si=026a43c71c744f74
  {
    id: 'archangel',
    trackId: '63aGgWIoGfl3wxykzje8eJ?si=026a43c71c744f74',
    loops: [
      {
        start: 96_446,
        end: 118_108,
        description: 'Chorus'
      },
      {
        start: 43_121,
        end: 96_444,
        description: 'Chorus + Verse'
      }
    ]
  },
  // 75 bpm Easy Melodic Pop Backing Track for Drummers by Drumless Backing Tracks
  // https://open.spotify.com/track/1aGz5VVyxzOcGcHbRtKkfL
  {
    id: 'drumless-melodic-pop',
    trackId: '1aGz5VVyxzOcGcHbRtKkfL',
    loops: [
      {
        name: 'short loop',
        start: 47_999,
        end: 80_006,
        description: '10 Takte (3 als Intro)'
      }
    ]
  },
  {
    id: 'amelie',
    trackId: '14rZjW3RioG7WesZhYESso',
    loops: [
      {
        description: 'Anfang',
        start: 0,
        end: 48_401
      },
      {
        description: 'Ref + Verse + Bridge',
        start: 48_741,
        end: 108_193
      }
    ]
  }
];
