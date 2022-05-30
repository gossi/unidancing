require('dotenv').config();
const process = require('process');

// import 'dotenv/config';
// import process from 'process';

const { CLIENT_ID, CLIENT_SECRET } = process.env;

const authEndpoint = 'https://accounts.spotify.com/authorize';
const REDIRECT_URI = 'https://localhost:3000/api/logged';

const SCOPES = ['playlist-read-collaborative', 'playlist-read-private'];

// eslint-disable-next-line node/no-unsupported-features/es-syntax
const LOGIN_URL = `${authEndpoint}?client_id=${CLIENT_ID}&response_type=code&redirect_uri=${REDIRECT_URI}&scope=${SCOPES.join(
  '%20'
)}`;

module.exports = { CLIENT_ID, CLIENT_SECRET, REDIRECT_URI, LOGIN_URL, SCOPES };
