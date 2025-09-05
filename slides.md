---
theme: default
background: '#1e3a8a'
title: Continuously Integrating Your Nix Config
info: |
  ## Continuously Integrating Your Nix Config
  Learn to add continuous integration checks to your Nix configuration in this hands-on workshop.
class: text-center text-white
drawings:
  persist: false
transition: slide-left
mdc: true
---

# Continuously Integrating Your Nix Config

**Building Automated Pipelines for Reliable System Management**

<div class="abs-br m-6 flex gap-2">
  <a href="https://github.com/joaothallis/continuously-integrating-your-nix-config" target="_blank" class="text-xl slidev-icon-btn opacity-50 !border-none text-white hover:text-gray-300">
    <carbon-logo-github />
  </a>
</div>

<!--
Welcome to the workshop! This is an interactive session where you'll learn to build automated CI/CD pipelines specifically for Nix configurations. By the end, you'll have a working pipeline that tests, builds, and validates your Nix configs on every change.
-->

---
layout: center
class: text-center
---

# Welcome! 👋

## What You'll Walk Away With

<v-clicks>

- 🚀 **A working CI pipeline** for your Nix configs
- 🔧 **Automated testing** that catches errors before deployment  
- 📊 **Confidence** in your system changes
- 🛠️ **Best practices** for Nix configuration management

</v-clicks>

<div v-after class="pt-8">
  <span class="text-sm opacity-75">
    Hands-on workshop • Interactive demos • Real-world examples
  </span>
</div>

<!--
This workshop is designed to be practical. We'll be building actual CI pipelines that you can use immediately. Bring your Nix configurations - we'll be working with real examples throughout the session.
-->

---
layout: two-cols
---

# The Problem 🔥

<v-clicks>

**Without CI/CD for Nix:**
- 💥 "It works on my machine"
- 🐛 Configuration errors discovered in production
- ⏰ Manual testing is slow and incomplete
- 😰 Fear of making changes
- 🔄 Inconsistent environments across team

</v-clicks>

::right::

<v-clicks>

**Horror Stories:**
- NixOS rebuild fails after weeks of changes
- Flake doesn't build on different architecture  
- Home Manager breaks colleague's setup
- Production deployment dies at 2 AM
- Package conflicts discovered too late

</v-clicks>

<div v-after class="pt-4 text-sm opacity-75">
  Sound familiar? Let's fix this! 🛠️
</div>

<!--
These are real scenarios that Nix users face regularly. The beauty of Nix's reproducibility is only as good as our ability to validate our configurations before they reach production or other team members.
-->

---
layout: center
class: text-center
---

# Your Nix Config Deserves Better

<v-clicks>

## What if every change was:
- ✅ **Automatically tested** before merge
- 🔍 **Validated** across multiple platforms  
- 🚀 **Built** to ensure it actually works
- 📝 **Documented** with clear feedback
- 🛡️ **Secure** and dependency-checked

</v-clicks>

<div v-after class="pt-8">
  <h2 class="text-2xl text-green-400">That's what we're building today! 🎯</h2>
</div>

<!--
This slide transitions from problems to possibilities. We're setting up the vision of what's possible with proper CI/CD for Nix configurations.
-->

---
---

# Quick Nix Config Refresher 📚

<div class="grid grid-cols-2 gap-8">

<div>

## Flake Structure
```nix
{
  description = "My NixOS config";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
  };
  
  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      modules = [ ./configuration.nix ];
    };
  };
}
```

</div>

<div>

## Common Pain Points
<v-clicks>

- **Syntax errors** in `.nix` files
- **Missing dependencies** or packages
- **Architecture mismatches** (x86_64 vs aarch64)
- **Invalid configurations** that fail at rebuild
- **Flake lock inconsistencies**
- **Home Manager vs NixOS conflicts**

</v-clicks>

</div>

</div>

<!--
Before we dive into CI/CD, let's make sure everyone's on the same page about Nix configurations. These are the common issues we'll be solving with our automated pipeline.
-->

---
layout: center
---

# CI/CD for Nix: The Game Plan 🎯

<div class="grid grid-cols-3 gap-8 mt-8">

<div class="text-center">
  <div class="text-4xl mb-4">🔍</div>
  <h3 class="text-lg font-bold mb-2">Validate</h3>
  <ul class="text-sm">
    <li>Syntax checking</li>
    <li>Flake evaluation</li>
    <li>Dependency resolution</li>
  </ul>
</div>

<div class="text-center">
  <div class="text-4xl mb-4">🚀</div>
  <h3 class="text-lg font-bold mb-2">Build</h3>
  <ul class="text-sm">
    <li>System configurations</li>
    <li>Home Manager profiles</li>
    <li>Multi-architecture</li>
  </ul>
</div>

<div class="text-center">
  <div class="text-4xl mb-4">✅</div>
  <h3 class="text-lg font-bold mb-2">Test</h3>
  <ul class="text-sm">
    <li>Integration tests</li>
    <li>Service validation</li>
    <li>Regression checks</li>
  </ul>
</div>

</div>

<div class="mt-12 text-center">
  <h2 class="text-xl text-blue-400">Every commit. Every PR. Every time. 💪</h2>
</div>

<!--
This is our three-pillar approach to Nix CI/CD. We'll implement each of these stages in our pipeline, building from simple syntax validation to comprehensive testing.
-->

---
layout: center
class: text-center
---

# 🚀 Time to Build!

## Let's Create Your First Nix CI Pipeline

<div class="mt-8">
  <div class="text-lg mb-4">We'll use <span class="text-blue-400 font-bold">GitHub Actions</span> to:</div>
  
  <v-clicks>
  
  - ✅ **Check syntax** of all `.nix` files
  - 🔍 **Evaluate** flake outputs  
  - 🏗️ **Build** configurations
  - 📦 **Cache** builds for speed
  
  </v-clicks>
</div>

<div v-after class="mt-8 p-4 bg-blue-900 bg-opacity-30 rounded-lg">
  <div class="text-sm">📋 Follow along! We'll build this step by step.</div>
</div>

<!--
Now we transition from theory to practice. This is where the workshop becomes hands-on and participants will start building their own CI pipeline.
-->

---
---

# Step 1: Basic GitHub Actions Setup

Create `.github/workflows/ci.yml` in your Nix config repo:

```yaml {all|1-8|10-15|17-22|24-30} {maxHeight:'400px'}
name: CI

on:
  push:
    branches: [ main, master ]
  pull_request:
    branches: [ main, master ]

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - uses: DeterminateSystems/nix-installer-action@main

    - name: Check Nix files syntax
      run: |
        find . -name "*.nix" -exec nix-instantiate --parse {} \; > /dev/null
        echo "✅ All .nix files have valid syntax"

    - name: Evaluate flake outputs
      run: |
        nix flake show --all-systems
        nix flake check
```

<!--
This is our foundation. The nix-instantiate command checks syntax, while flake check validates the structure. We're using Determinate Systems' installer for speed and reliability.
-->

---
layout: two-cols
---

# Step 2: Add Build Testing

Let's build actual configurations to catch real issues:

```yaml
- name: Build NixOS configuration
  run: |
    # Build system configuration
    nix build .#nixosConfigurations.myhost.config.system.build.toplevel
    
- name: Build Home Manager configuration  
  run: |
    # Build home configuration
    nix build .#homeConfigurations.myuser.activationPackage
```

<div class="mt-4">
<v-click>

**⚠️ Replace `myhost` and `myuser` with your actual configuration names!**

</v-click>
</div>

::right::

<v-click>

## What This Catches:

- ✅ Missing packages/dependencies
- ✅ Invalid module configurations  
- ✅ Architecture incompatibilities
- ✅ Service definition errors
- ✅ File permission issues

</v-click>

<div v-after class="mt-8 p-3 bg-green-900 bg-opacity-20 rounded text-sm">
💡 <strong>Pro tip:</strong> This will fail fast and save you from broken rebuilds!
</div>

<!--
Building the actual configurations is where we catch the most common real-world issues. This step simulates what happens when you run nixos-rebuild or home-manager switch.
-->

---
---

# Step 3: Speed Up With Caching 🚀

Add Nix binary cache for faster builds:

```yaml {all|6-8|10-14|16-20} {maxHeight:'450px'}
jobs:
  check:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - uses: DeterminateSystems/nix-installer-action@main
    - uses: DeterminateSystems/magic-nix-cache-action@main

    # Enable flakes and add binary caches
    - name: Configure Nix
      run: |
        echo "extra-substituters = https://nix-community.cachix.org" | sudo tee -a /etc/nix/nix.conf
        echo "extra-trusted-public-keys = nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" | sudo tee -a /etc/nix/nix.conf

    - name: Check syntax & evaluate  
      run: |
        find . -name "*.nix" -exec nix-instantiate --parse {} \; > /dev/null
        nix flake show --all-systems
        nix flake check

    # Your build steps here...
```

<div class="mt-4 text-sm opacity-75">
⚡ This can reduce build times from 20+ minutes to under 5 minutes!
</div>

<!--
Caching is crucial for practical CI/CD. The magic-nix-cache-action provides automatic caching, while binary substituters like nix-community.cachix.org provide pre-built packages.
-->

---
layout: center
---

# Advanced Testing & Validation 🧪

<div class="grid grid-cols-2 gap-8">

<div>

## Code Quality Checks
```yaml
- name: Format check
  run: |
    nix fmt
    if ! git diff --exit-code; then
      echo "❌ Code not formatted"
      exit 1
    fi

- name: Lint with statix  
  run: |
    nix run nixpkgs#statix check .
```

</div>

<div>

## Security & Dependencies
```yaml
- name: Vulnerability scan
  run: |
    nix run nixpkgs#vulnix --system

- name: Check for outdated inputs
  run: |
    nix flake update --dry-run
    # Alert if major updates available
```

</div>

</div>

<div class="mt-8 text-center text-sm opacity-75">
🔍 These catch issues that basic building might miss
</div>

<!--
Advanced validation goes beyond just "does it build" to include code quality, security, and maintenance concerns. These tools help maintain high-quality Nix configurations.
-->

---
layout: two-cols
---

# Matrix Builds: Test Multiple Platforms 🚀

Test your config across different systems:

```yaml {1-10|11-20|21-25} {maxHeight:'450px'}
jobs:
  check:
    strategy:
      matrix:
        system: 
          - ubuntu-latest
          - macos-latest
        arch:
          - x86_64-linux
          - aarch64-darwin
    
    runs-on: ${{ matrix.system }}
    steps:
    - uses: actions/checkout@v4
    - uses: DeterminateSystems/nix-installer-action@main
    
    - name: Build for architecture
      run: |
        nix build .#packages.${{ matrix.arch }}.default
        nix build .#nixosConfigurations.myhost.config.system.build.toplevel --system ${{ matrix.arch }}
        
    - name: Test cross-compilation
      run: |
        nix build .#packages.aarch64-linux.default --system x86_64-linux
```

::right::

<v-click>

## Why Matrix Builds?

- ✅ **Apple Silicon** compatibility  
- ✅ **Server deployment** validation
- ✅ **Cross-compilation** testing
- ✅ **Multi-user** configurations
- ⚡ **Parallel** execution

</v-click>

<div v-after class="mt-6 p-3 bg-orange-900 bg-opacity-20 rounded text-sm">
⚠️ <strong>Note:</strong> GitHub Actions has usage limits. Consider which combinations you actually need!
</div>

<!--
Matrix builds are powerful for ensuring your Nix configurations work across different platforms. This is especially important for teams with mixed environments or when deploying to different architectures.
-->

---
layout: center
---

# When Things Go Wrong 🚨

## Common CI Failures & Quick Fixes

<div class="grid grid-cols-2 gap-6 mt-8">

<div>

### ❌ Build Timeout
```bash
Error: Action timed out after 6 hours
```
**Fix:** Add more binary caches or reduce build scope
```yaml
timeout-minutes: 60  # Don't wait forever
```

### ❌ Out of Disk Space  
```bash
No space left on device
```
**Fix:** Clean up between steps
```yaml
- name: Free disk space
  run: nix-collect-garbage -d
```

</div>

<div>

### ❌ Architecture Mismatch
```bash
cannot build on 'x86_64-linux' platform
```
**Fix:** Use proper platform specification
```yaml
nix build --system x86_64-linux
```

### ❌ Flake Lock Issues
```bash
error: input 'nixpkgs' not found
```
**Fix:** Update or commit flake.lock
```bash
nix flake update && git add flake.lock
```

</div>

</div>

<!--
These are the most common issues people encounter when setting up Nix CI/CD. Having quick fixes ready saves hours of debugging.
-->

---
layout: two-cols
---

# Best Practices 💎

<v-clicks>

## Pipeline Design
- **Start simple** - Basic syntax checking first
- **Fail fast** - Put quick checks before slow builds  
- **Cache everything** - Use all available cache layers
- **Parallel jobs** - Run independent checks concurrently

## Code Organization
- **Modular configs** - Easier to test individual parts
- **Clear naming** - `hosts/laptop.nix` not `config.nix`
- **Version pins** - Pin critical dependencies  
- **Document changes** - Good commit messages help debugging

</v-clicks>

::right::

<v-clicks>

## Team Collaboration
- **Branch protection** - Require CI to pass
- **Review requirements** - Don't merge broken configs
- **Shared caches** - Use team Cachix or similar
- **Testing environments** - Stage before production

## Monitoring & Alerts  
- **Build notifications** - Know when things break
- **Performance tracking** - Watch build times
- **Dependency updates** - Regular renovate/dependabot
- **Security scanning** - Keep configs secure

</v-clicks>

<!--
These practices come from real-world experience managing Nix configurations at scale. Following them will save you significant pain as your configurations grow.
-->

---
layout: center
class: text-center
---

# What's Next? 🚀

## Take Your Pipeline Further

<v-clicks>

- 🌐 **Deploy Automatically** - Use CI to deploy to staging/production
- 🏠 **Home Manager Integration** - Test user environment changes  
- 🐳 **Container Builds** - Package your configs as Docker images
- ☁️ **Cloud Deployments** - Auto-deploy to NixOS servers
- 📊 **Monitoring** - Track system health after deployments
- 🔒 **Secrets Management** - Integrate with sops-nix or age

</v-clicks>

<div v-after class="mt-12">
  <h2 class="text-2xl text-green-400 mb-4">You now have the foundation! 🎯</h2>
  <div class="text-lg opacity-75">Start with the basics, then expand as you learn.</div>
</div>

<!--
This gives participants clear next steps after the workshop ends. The key is to start simple and gradually add complexity as they gain confidence.
-->

---
layout: center
class: text-center
---

# Resources & Community 📚

<div class="grid grid-cols-2 gap-8 mt-8">

<div>

## 🔗 Essential Links
- **[Nix Manual](https://nixos.org/manual/nix/stable/)** - Official docs
- **[NixOS Wiki](https://nixos.wiki/)** - Community knowledge
- **[Determinate Systems](https://determinate.systems/)** - CI actions & tools
- **[Nix Community](https://github.com/nix-community)** - Shared packages & tools

## 🛠️ Helpful Tools  
- **[devenv](https://devenv.sh/)** - Development environments
- **[Cachix](https://cachix.org/)** - Binary caching service
- **[nix-direnv](https://github.com/nix-community/nix-direnv)** - Auto-loading shells

</div>

<div>

## 💬 Get Help & Share
- **[NixOS Discourse](https://discourse.nixos.org/)** - Q&A and discussions
- **[Matrix Chat](https://matrix.to/#/#nix:nixos.org)** - Real-time help  
- **[Reddit r/NixOS](https://reddit.com/r/NixOS)** - Community posts
- **[GitHub Discussions](https://github.com/NixOS/nixpkgs/discussions)** - Package issues

## 📖 Advanced Reading
- **[Nix Pills](https://nixos.org/guides/nix-pills/)** - Deep dive tutorial
- **[Zero to Nix](https://zero-to-nix.com/)** - Learning resource

</div>

</div>

<!--
Providing concrete resources helps participants continue learning after the workshop. These are carefully selected as the most helpful resources for continuing the Nix journey.
-->

---
layout: center
class: text-center
---

# Thank You! 🎉

## Questions & Discussion

<div class="mt-12">
  <div class="text-xl mb-4">You're now ready to confidently manage your Nix configs!</div>
  <div class="text-lg opacity-75 mb-8">Remember: Start simple, iterate, and don't be afraid to experiment.</div>
</div>

<div class="flex justify-center gap-8 text-sm">
  <div class="px-4 py-2 bg-blue-900 bg-opacity-30 rounded">
    🚀 Build your first pipeline
  </div>
  <div class="px-4 py-2 bg-green-900 bg-opacity-30 rounded">  
    🔧 Test with real configs
  </div>
  <div class="px-4 py-2 bg-purple-900 bg-opacity-30 rounded">
    💬 Share your learnings
  </div>
</div>

<div class="mt-8 text-sm opacity-50">
  Happy building! May your configs always evaluate successfully. ✨
</div>

<!--
A warm conclusion that reinforces the key learning outcomes and encourages continued exploration. The workshop has provided both practical skills and confidence to experiment further.
-->
