type Datapoint = [number, number];

export const groups = [
  {
    id: 'artistry',
    content: 'Artistik',
    className: 'artistry',
    key: 'a'
  },
  {
    id: 'comm',
    content: 'Kommunikation',
    className: 'comm',
    key: 'c'
  },
  {
    id: 'tricks',
    content: 'Tricks',
    className: 'tricks',
    key: 't'
  },
  {
    id: 'filler',
    content: 'Filler',
    className: 'filler',
    key: 'f'
  },
  {
    id: 'void',
    content: 'Void',
    className: 'void',
    key: 'v'
  },
  {
    id: 'marker',
    content: 'Marker',
    className: 'marker'
  }
];

export interface TimeTracking {
  start?: number;
  end?: number;

  groups?: {
    artistry?: Datapoint[];
    tricks?: Datapoint[];
    void?: Datapoint[];
    filler?: Datapoint[];
    communication?: Datapoint[];
  };
}
