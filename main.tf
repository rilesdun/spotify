# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_providers {
    spotify = {
      version = "~> 0.2.6"
      source  = "conradludgate/spotify"
    }
  }
}

provider "spotify" {
  api_key = var.spotify_api_key
}

resource "spotify_playlist" "programmatic_playlist" {
  name        = "Programmatic Playlist"
  description = "This playlist was created & managed by Terraform"
  public      = true

  tracks = flatten([
    data.spotify_search_track.knocked_loose_laugh_tracks.tracks[*].id,
    data.spotify_search_track.knocked_loose_a_different_shade_of_blue.tracks[*].id,
    data.spotify_search_track.knocked_loose_pop_culture.tracks[*].id,
    data.spotify_search_track.saetia.tracks[*].id,
    data.spotify_search_track.pup_morbid_stuff.tracks[*].id,
    data.spotify_search_track.pup_self_titled.tracks[*].id,
    data.spotify_search_track.pup_the_dream_is_over.tracks[*].id,

  ])
}
data "spotify_search_track" "saetia" {
  artist = "Saetia"
  explicit = true
  limit = 4
}

data "spotify_search_track" "knocked_loose_laugh_tracks" {
  artist = "Knocked Loose"
  album = "Laugh Tracks"
  explicit = true
  limit = 4
}

data "spotify_search_track" "knocked_loose_pop_culture" {
  artist = "Knocked Loose"
  album = "Pop Culture"
  explicit = true
  limit = 4
}

data "spotify_search_track" "knocked_loose_a_different_shade_of_blue" {
  artist = "Knocked Loose"
  album = "A Different Shade of Blue"
  explicit = true
  limit = 4
}

data "spotify_search_track" "pup_morbid_stuff" {
  artist = "PUP"
  album = "Morbid Stuff"
  explicit = true
  limit = 4
}

data "spotify_search_track" "pup_self_titled" {
  artist = "PUP"
  album = "PUP"
  explicit = true
  year = 2013
  limit = 4
}

data "spotify_search_track" "pup_the_dream_is_over" {
  artist = "PUP"
  album = "The Dream Is Over"
  explicit = true
  year = 2016
  limit = 4
}