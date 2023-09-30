import { ability } from 'ember-ability';

export const isAuthenticated = ability(({ services }) => () => {
  const { spotify } = services;

  return spotify.client.authenticated;
});
