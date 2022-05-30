// import http from 'http';
// import express from 'express';
// import cors from 'cors';
// import { Server } from 'socket.io';
// import SpotifyWebApi from 'spotify-web-api-node';
// import { CLIENT_ID, CLIENT_SECRET, REDIRECT_URI } from '../spotify';

/* eslint-env node */
const dotenv = require('dotenv');
const express = require('express');
const cors = require('cors');
const process = require('process');
const SpotifyWebApi = require('spotify-web-api-node');

// bootstrap
dotenv.config();

// config
const { CLIENT_ID, CLIENT_SECRET } = process.env;
const REDIRECT_URI = 'http://localhost:3000/api/logged';
const SCOPES = [
  'playlist-read-collaborative',
  'playlist-read-private',
  'user-read-playback-state',
  'user-modify-playback-state',
  'streaming'
];

// server
const app = express();
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
const port = 3000;

// spotify client
const spotifyApi = new SpotifyWebApi({
  clientId: CLIENT_ID,
  clientSecret: CLIENT_SECRET,
  redirectUri: REDIRECT_URI
});

// routes
app.get('/api/login', async (req, res) => {
  const loginUrl = spotifyApi.createAuthorizeURL(SCOPES, 'kaese');
  res.redirect(loginUrl);
});

app.get('/api/logged', async (req, res) => {
  const code = req.query.code;
  try {
    const data = await spotifyApi.authorizationCodeGrant(code);

    spotifyApi.setAccessToken(data.body.access_token);
    spotifyApi.setRefreshToken(data.body.refresh_token);

    res.redirect(`http://localhost:4200/auth?token=${data.body.access_token}`);
  } catch (err) {
    console.error('uh oh', err);
  }
});

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`);
});
