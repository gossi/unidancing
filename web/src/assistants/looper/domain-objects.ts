export interface LoopDescriptor {
  name?: string;
  start: number;
  end: number;
  description?: string;
}

export interface LoopTrackDescriptor {
  id: string;
  trackId: string;
  loops: LoopDescriptor[];
}
