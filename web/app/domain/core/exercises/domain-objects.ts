import type {
  Exercise,
  ExerciseInstruction,
  ExerciseInstructionMedia,
  ExerciseMedia,
  ExerciseMediaDancemix,
  ExerciseMediaLoop,
  ExerciseMediaMaterial,
  ExerciseMediaSong
} from '@/tina/types';
import type { Maybe } from '@/tina/types';

export type Personal = 'individual' | 'pair' | 'group';
export type Locomotion = 'unicycle' | 'pedes';
export type Difficulty = 'beginner' | 'intermediate' | 'advanced';

// eslint-disable-next-line @typescript-eslint/no-redundant-type-constituents
export function asPersonal(personal?: Personal | string | Maybe<string>): Personal {
  return personal as Personal;
}

// eslint-disable-next-line @typescript-eslint/no-redundant-type-constituents
export function asLocomotion(locomotion?: Locomotion | string | Maybe<string>): Locomotion {
  return locomotion as Locomotion;
}

// eslint-disable-next-line @typescript-eslint/no-redundant-type-constituents
export function asDifficulty(difficulty?: Difficulty | string | Maybe<string>): Difficulty {
  return difficulty as Difficulty;
}

// eslint-disable-next-line @typescript-eslint/no-redundant-type-constituents
export function asMedia(media?: ExerciseMedia | string | Maybe<string>): ExerciseMedia {
  return media as ExerciseMedia;
}

// eslint-disable-next-line @typescript-eslint/no-redundant-type-constituents
export function asMediaCollection(
  media?: Maybe<ExerciseMedia>[] | Maybe<Maybe<ExerciseInstructionMedia>[]> | null | undefined
): ExerciseMedia[] {
  return media as ExerciseMedia[];
}

export type {
  Exercise,
  ExerciseInstructionMedia,
  ExerciseMedia,
  ExerciseMediaDancemix,
  ExerciseMediaLoop,
  ExerciseMediaMaterial,
  ExerciseMediaSong,
  ExerciseInstruction as Instruction
};
