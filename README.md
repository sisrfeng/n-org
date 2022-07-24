<div align="center">

<img src="res/neorg.svg" width=300>

# Neorg - An Organized Future

<a href="https://neovim.io"> ![Neovim](https://img.shields.io/badge/Neovim%200.7+-brightgreen?style=for-the-badge) </a>
<a href="https://discord.gg/T6EgTAX7ht"> ![Discord](https://img.shields.io/badge/discord-join-7289da?style=for-the-badge&logo=discord) </a>
<a href="/LICENSE"> ![License](https://img.shields.io/badge/license-GPL%20v3-brightgreen?style=for-the-badge)</a>
<a href="#wip"> ![Status](https://img.shields.io/badge/status-WIP-informational?style=for-the-badge) </a>

Your New Life Organization Tool - All in Lua

[Summary](#summary)
•
[Showcase](#-showcase)
•
[Installation](#-installation)
•
[Setup](#-setup)
•
[Usage](#-usage)
<br>
[Modules](#-modules)
•
[Roadmap](#-roadmap)
•
[Philosophy](#-philosophy)
•
[FAQ](#-faq)

</div>

<div align="center">

<br>

## Summary

</div>

Neorg (_Neo_ - new, _org_ - organization) is a tool designed to reimagine organization as you know it.
Grab some coffee, start writing some notes, let your editor handle the rest.

### Why do we need Neorg?

There are currently projects designed to [clone org-mode from emacs](https://github.com/kristijanhusak/orgmode.nvim),
then what is the goal of this project?

Whilst those projects are amazing, it's simply not enough for us. We need our _own, **better**_ solution -
one that will surpass _every_ other text editor. It's through our frustration of no native solution for Neovim
and inconsistencies in the most popular markup formats that Neorg was born.

To learn more about the philosophy of the project check the [philosophy](#-philosophy) section.

###### :exclamation: **IMPORTANT**: Neorg is _alpha_ software. We consider it stable however be prepared for changes and potentially outdated documentation. We are advancing fast and while we are doing our best to keep the documentation up-to-date, this may not always be possible.

## 🌟 Showcase

<details>
<summary>A `.norg` file:</summary>
  <img width="700" alt="Showcase image of a Neorg document" src="https://user-images.githubusercontent.com/76052559/150838408-1a021d7b-1891-4cab-b16e-6b755e741e87.png">
</details>

<details>
<summary>Concealing module enabled:</summary>
  <img width="700" alt="Image of a Neorg document with the concealer module enabled." src="https://user-images.githubusercontent.com/76052559/150838418-b443b92d-186a-45cb-ba84-06f03cdeea8a.png">
</details>

<details>
<summary>First class treesitter support:</summary>

![First class treesitter support](https://user-images.githubusercontent.com/76052559/151668244-9805afc4-8c50-4925-85ec-1098aff5ede6.gif)

</details>

<details>
<summary>Treesitter powered editing:</summary>

![Treesitter powered editing](https://user-images.githubusercontent.com/76052559/151614059-41b590cd-07ea-437c-84b9-536de6d1adfa.gif)

</details>

<details>
<summary>Manage your tasks and projects with the GTD module:</summary>

- See your current projects

![See your current projects](https://user-images.githubusercontent.com/76052559/151700321-e6912aff-2e87-409b-986e-dff37904b51b.gif)

- Create a new task

![Create a new task](https://user-images.githubusercontent.com/76052559/151699879-3a04518b-16e6-4eb4-b765-678a15b90fb4.gif)

- Edit tasks in an efficient manner through the UI

![Edit tasks in an efficient manner through the UI](https://user-images.githubusercontent.com/76052559/151700653-89c30e99-68e0-4873-8e1a-ecd25dd271c2.gif)

And much more...

</details>

<details>
  <summary>Powerpoint-like presentations in Neovim with the presenter module:</summary>

![Powerpoint-like presentations in Neovim with the presenter module](https://user-images.githubusercontent.com/76052559/151674065-ed397716-9d26-4efc-9c2d-2dfdb5539edf.gif)

</details>

<details>
  <summary>Get syntax highlighting for any language supported by Neovim:</summary>

Plus fancy completion powered by `nvim-cmp`.

![Get syntax highlighting for any language supported by Neovim](https://user-images.githubusercontent.com/76052559/151668015-39a50439-5c95-4a18-9970-090fb68cfc0b.gif)

</details>

## 🔧 Installation

**Neorg requires at least Neovim 0.7+ to operate.**

You can install it through your favorite plugin manager:

- [Packer](https://github.com/wbthomason/packer.nvim):

  ```lua
  use {
      "nvim-neorg/neorg",
      config = function()
          require('neorg').setup {
              ... -- check out setup part...
          }
      end,
      requires = "nvim-lua/plenary.nvim"
  }
  ```

  Every time Neorg hits a new release, a new tag is created by us, so you don't have to worry about all the updates inbetween.
  That means, adding `tag = "*"` in Packer will update to latest stable release.
  
  You can also pin Neorg to one specific version through e.g. `tag = "0.0.9"`.
  
- [Packer (with lazyloading)](https://github.com/wbthomason/packer.nvim):

  Want to lazy load? Know that you'll have to jump through some hoops and hurdles to get
  it to work perfectly.
  You can use the `ft` key to load Neorg only upon entering a `.norg` file:

  ```lua
  use {
      "nvim-neorg/neorg",
      -- tag = "latest",
      ft = "norg",
      after = "nvim-treesitter", -- You may want to specify Telescope here as well
      config = function()
          require('neorg').setup {
              ...
          }
      end
  }
  ```

  Although it's proven to work for a lot of people, you might need additional setups depending on how your lazyloading system is configured.

  One important thing to ask yourself is: "is it really worth it?".
  Neorg practically lazy loads itself: only a few lines of code are run on startup, these lines check whether the current
  extension is `.norg`, if it's not then nothing else loads. You shouldn't have to worry about performance issues when it comes to startup, but
  hey, you do you :)

- [vim-plug](https://github.com/junegunn/vim-plug):

  ```vim
  Plug 'nvim-neorg/neorg' | Plug 'nvim-lua/plenary.nvim'
  ```

  You can then put this initial configuration in your `init.vim` file:

  ```vim
  lua << EOF
  require('neorg').setup {
      ...
  }
  EOF
  ```

### Treesitter

###### _Be sure to have [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) installed on your system for this step!_
Neorg will automatically attempt to install the parsers for you upon entering a `.norg` file if you have `core.defaults` loaded.
A command is also exposed to reinstall and/or update these parsers: `:Neorg sync-parsers`.

Note that the `:Neorg sync-parsers` command is only available when in a `.norg` file, and the installation isn't reproducible.
To make it permanent, you want to alter your treesitter configuration a little:

```lua
require('nvim-treesitter.configs').setup {
    ensure_installed = { "norg", --[[ other parsers you would wish to have ]] },
    highlight = { -- Be sure to enable highlights if you haven't!
        enable = true,
    }
}
```

NOTE: Putting `"norg_meta"` into your `ensure_installed` table may trigger unintended errors.
This is because `norg_meta` isn't in the native `nvim-treesitter` repositories, and the parser is
only defined while using Neorg. This is why using `:Neorg sync-parsers` is recommended.

### Troubleshooting Treesitter
- Not using packer? Make sure that Neorg's `setup()` gets called after `nvim-treesitter`'s setup.
- If on MacOS, ensure that the `CC` environment variable points to a compiler that has C++14 support.
  You can run Neovim like so: `CC=/path/to/newer/compiler nvim -c
  "TSInstallSync norg"` in your shell of choice
  to install the Neorg parser with a newer compiler. You may also want to export the `CC` variable in general:
  `export CC=/path/to/newer/compiler`.

## 📦 Setup

You've got the basic stuff out the way now, but wait! That's not all. You've installed Neorg - great! Now you have to configure it.
By default, Neorg does nothing, and gives you nothing. You must tell it what you care about!

### Default modules

Neorg runs on _modules_, which are discussed and explained in more depth later on.
Each module provides a single bit of functionality - they can then be stacked together to form
the entire Neorg environment.

The most common module you'll find is the `core.defaults` module, which is basically a "load all features" switch.
It gives you the full experience out of the box.

The code snippet to enable all default modules is very straightforward:

```lua
require('neorg').setup {
    load = {
        ["core.defaults"] = {}
    }
}
```

You can see [here](https://github.com/nvim-neorg/neorg/wiki#default-modules) which modules are automatically required when loading `core.defaults`.

## ⚙ Usage

We recommend reading the [spec](docs/NFF-0.1-spec.md) and familiarizing yourself with the new format.
You can view a summary directly in your neovim instance by running `:h neorg` if you don't like reading a lot!

Afterwards it's as simple as hopping into a `.norg` file and typing away.

A good first step is to require the `core.norg.dirman` module, it'll help you manage Neorg workspaces.
Workspaces are basically isolated directories that you can jump between:

```lua
require('neorg').setup {
    load = {
        ["core.defaults"] = {},
        ["core.norg.dirman"] = {
            config = {
                workspaces = {
                    work = "~/notes/work",
                    home = "~/notes/home",
                }
            }
        }
    }
}
```

Changing workspaces is easy, just do `:Neorg workspace work`, where `work` is the name of your workspace.
Note that `:Neorg` is only available when the Neorg environment is loaded, i.e. when you're
in a `.norg` file or have loaded a `.norg` file already in your Neovim session.

If the Neorg environment isn't loaded you'll find a `:NeorgStart` command which will launch Neorg and pop
you in to your last (or only) workspace.

#### It works, cool! What are the next steps?

We recommend you add some core modules that can greatly improve your experience, such as:

- Using the concealer module to enable icons (`core.norg.concealer`)
- Setting up a completion engine (`core.norg.completion`)

Setting these up is discussed in the wiki, so be sure to check there!

**You're now basically set**! The rest of this README will be additional information, so keep reading
if you care about what makes Neorg tick, or you want to genuinely get good at using it.

## 🥡 Modules

As you saw previously, we loaded `core.defaults` and recommended that you load `core.norg.dirman`.
As you probably know those are modules. But what are they, exactly?

Modules are basically isolated bits of code that provide a specific subset of features. They can be docked into
the environment at any time and can be essentially stacked together like lego bricks!
They can bind themselves to events and callbacks and communicate with each other.

To require a module, just do:

```lua
require('neorg').setup {
    load = {
        -- Require the module with the default configurations for it
        ["your.required.module"] = {},

        -- Require the module, and override the configurations (with the "config" table)
        ["your.required.module"] = {
            config = {
                some_option = true
            }
        }
    }
}
```

As always, for a little more info you can consult the wiki page [here](https://github.com/nvim-neorg/neorg/wiki/Installation#the-concept-of-modules).
To know which configurations are provided by default for a module, just click on their link: you'll go to the module page in the [wiki](https://github.com/nvim-neorg/neorg/wiki).

### Core Modules

Here is a list of core modules that aren't part of `core.defaults` and can be added
individually by you.

Feel free to try by adding them to your Neorg setup.

<!-- TODO: Use docgen to generate this automatically -->

<details>
<summary>List of Core Modules:</summary>

| Module name                                                                     | Description                                                                 |
| :------------------------------------------------------------------------------ | :-------------------------------------------------------------------------- |
| [`core.gtd.base`](https://github.com/nvim-neorg/neorg/wiki/Getting-Things-Done) | Manages your tasks with Neorg using the Getting Things Done methodology.    |
| [`core.norg.completion`](https://github.com/nvim-neorg/neorg/wiki/Completion)   | A wrapper to interface with several different completion engines.           |
| [`core.norg.concealer`](https://github.com/nvim-neorg/neorg/wiki/Concealer)     | Enhances the basic Neorg experience by using icons instead of text.         |
| [`core.norg.dirman`](https://github.com/nvim-neorg/neorg/wiki/Dirman)           | This module is be responsible for managing directories full of .norg files. |
| [`core.norg.journal`](https://github.com/nvim-neorg/neorg/wiki/Journal)         | Easily create files for a journal.                                          |
| [`core.norg.qol.toc`](https://github.com/nvim-neorg/neorg/wiki/Qol-Toc)         | Generates a Table of Contents from the Neorg file.                          |
| [`core.presenter`](https://github.com/nvim-neorg/neorg/wiki/Core-Presenter)     | Neorg module to create gorgeous presentation slides.                        |

</details>

### External Modules

Users can contribute and create their own modules for Neorg.
To use them, just download the plugin with your package manager, for instance with Packer:

```lua
use {
    "nvim-neorg/neorg",
    requires = "john-cena/cool-neorg-plugin",
}
```

After that it's as easy as loading the module it exposes normally:

```lua
require('neorg').setup {
    load = {
        ["cool.module"] = {},
    }
}
```

<details>
<summary>List of community modules:</summary>

| Module name                                                                       | Description                                                                          |
| :-------------------------------------------------------------------------------- | :----------------------------------------------------------------------------------- |
| [`core.integrations.telescope`](https://github.com/nvim-neorg/neorg-telescope)    | Neorg integration with [Telescope](https://github.com/nvim-telescope/telescope.nvim) |
| [`external.gtd-project-tags`](https://github.com/esquires/neorg-gtd-project-tags) | Provides a view of tasks grouped with a project tag. Requires `core.gtd.base`        |
| [`external.integrations.gtd-things`](https://github.com/danymat/neorg-gtd-things) | Use Things3 database to fetch and update tasks instead. Requires `core.gtd.base`     |
| [`external.context`](https://github.com/max397574/neorg-contexts) | Display headings in which you are at the top of the window in a float popup. |
| [`external.kanban`](https://github.com/max397574/neorg-kanban) | Display your gtd todos in a kanban-like board in floating windows. Requires `core.gtd.base` |

</details>
<br>

If you ever end up making a module for Neorg feel free to make a pull request and add it to this README!

## ❓ Philosophy

Our goals are fairly simple:

1. Revise the org format: simple, extensible, unambiguous. Will make you feel right at home. Alternate markup formats have several flaws, but the most
   notable one is the requirement for **complex parsers**.
   I really advise checking [some writeups](https://talk.commonmark.org/t/beyond-markdown/2787) out on how bad it can get at times.
   What if we told you it's possible to alleviate those problems, all whilst keeping that familiar feel?
   Enter the `.norg` file format, whose [base spec](docs/NFF-0.1-spec.md) is practically complete.
   The cross between all the best things from org and the best things from markdown, revised and merged into one.

2. Keybinds that _make sense_: vim's keybind philosophy is unlike any other, and we want to keep that vibe.
   Keys form a "language", one that you can speak, not one that you need to learn off by heart.

3. Infinite extensibility: no, that isn't a hyperbole. We mean it. Neorg is built upon an insanely modular and
   configurable backend - keep what you need, throw away what you don't care about. Use the defaults or change 'em.
   You are in control of what code runs and what code doesn't run!

4. Logic: everything has a reason, everything has logical meaning. If there's a feature, it's there because it's necessary, not because
   two people asked for it.
   If something has a more niche use case, it should be documented.

## 🗺 Roadmap

We track a high-level roadmap, so that you can know what to expect. Just do `:h neorg-roadmap`.
To know exactly what's being worked on, just check out the [repo's PRs](https://github.com/nvim-neorg/neorg/pulls).

## 📚 FAQ

<!-- TODO(vhyrro): Populate with common issues -->

The wiki is the go-to place if you need answers to anything Neorg-related. Usage, Keybinds, User Callbacks, Modules, Events?
It's all there, so we recommend you seriously go [read it](https://github.com/nvim-neorg/neorg/wiki)!

## Contributing

Have an idea? An improvement to existing functionality? Feedback in general?

We seriously recommend you join our [discord](https://discord.gg/T6EgTAX7ht) to hang out and chat about your ideas,
plus that you read the [CONTRIBUTING.md](docs/CONTRIBUTING.md) file for more info about developer-related stuff!

## Credits

Massive shoutouts go to all the contributors actively working on the project together to form a fantastic
integrated workflow:

- [mrossinek](https://github.com/mrossinek) - for basically being my second brain when it comes to developing new features
  and adding new syntax elements
- [danymat](https://github.com/danymat) - for creating the excellent GTD workflow in Neorg that we literally use internally
  to plan new features

And an extra thank you to:

- [Binx](https://github.com/Binx-Codes/) - for making that gorgeous logo for free!
- [bandithedoge](https://github.com/bandithedoge) - for converting the PNG version of the logo into SVG form

## Support

Love what I do? Want to see more get done faster? Want to support future projects? Any sort of support is always
heartwarming and fuels the urge to keep going :heart:. You can show support here:

- [Buy me a coffee!](https://buymeacoffee.com/vhyrro)
- [Support me on LiberaPay](https://liberapay.com/vhyrro)
- [Donate directly via paypal](https://paypal.me/ewaczupryna?locale.x=en_GB)
- [Support me on Patreon](https://patreon.com/vhyrro)
- Donate to my monero wallet: `86CXbnPLa14F458FRQFe26PRfffZTZDbUeb4NzYiHDtzcyaoMnfq1TqVU1EiBFrbKqGshFomDzxWzYX2kMvezcNu9TaKd9t`
- Donate via bitcoin: `bc1q4ey43t9hhstzdqh8kqcllxwnqlx9lfxqqh439s`

<!-- TODO: Create table of donation links for all maintainers -->
