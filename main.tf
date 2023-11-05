# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  backend "s3" {
    bucket = "spotify-state-bucket"
    key    = "terraform.tfstate"
    region = "ca-central-1"
    dynamodb_table = "spotify_state_locks"
    encrypt = true
  }
  required_providers {
    spotify = {
      version = "~> 0.2.6"
      source  = "conradludgate/spotify"
    }
    aws = {
      version = "~> 5.0"
      source  = "hashicorp/aws"
    }
  }
}

provider "spotify" {
  api_key = var.spotify_api_key
}

provider "aws" {
  region = "ca-central-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_access_key
}

resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.spotify-state-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.spotify-state-bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.spotify-state-bucket.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "spotify-state-bucket" {
  bucket = "spotify-state-bucket"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name           = "spotify_state_locks"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "spotify_playlist" "programmatic_playlist" {
  name        = "Programmatic Playlist"
  description = "This playlist was created and managed by Terraform"
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