# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview
Slidev presentation project for the workshop "Continuously Integrating Your Nix Config". The workshop teaches participants how to build automated CI/CD pipelines for Nix configurations including testing, building, linting, and error detection.

## Development Commands
- `yarn install` - Install dependencies  
- `yarn dev` - Start development server (opens at http://localhost:3030)
- `yarn build` - Build production slides
- `yarn export` - Export slides to static files

## Key Files
- `slides.md` - Main presentation content (currently contains template content to be replaced)
- `package.json` - Uses Slidev CLI with Vue 3
- `vercel.json` - Deployment configuration for Vercel
- `yarn.lock` - Yarn is the package manager

## Current Status
This is a fresh Slidev project that needs workshop content development. The slides.md currently contains default Slidev template content and needs to be replaced with Nix CI/CD specific material.