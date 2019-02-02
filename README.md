# Aqua

**Aqua** is generalt templating and scaffolding solution for **Elixir** projects,
that helps:

* make the **Elixir's** development experience smoother
* follow the best practices for project structuring
* increase development speed

**Aqua** by itself tries to bring the most common and general templates and code snippets, that are widely used in development,
and also allowes it's users to create there own templates and snippets.

## Acknowledgements

**Aqua** is heavily inspired by [Dave's Thomas](https://pragdave.me) solutions:

* [Mix Generator](https://github.com/pragdave/mix_generator)
* [Mix Templates](https://github.com/pragdave/mix_templates)

while tries to bring some new features, that probably can be usfull for day-by-day coding experience.

Also, because **Aqua** is used as a **Mix** archive, other **Elixir** packages can not be used as it's dependencies.

While **JSON** configurations are widely used across **Aqua** and it's templates, 
[Jason](https://github.com/michalmuskala/jason) library is fully copied, namespaced and backed inside **Aqua** package.
All copyrights and notes for this library can be found in it's [license](https://github.com/michalmuskala/jason/blob/master/LICENSE) section.

## Installation

**Note:** you should not add `aqua` as dependency for your project.

Install it locally as mix archive, using:

```bash
mix archive.install hex aqua
```

## Quick-start

Simply run

```bash
mix aqua
```

and follow the instructions :)

## General information

### Domain Terminology

Across **Aqua** ecosystems, next terminology is accepted:

* **Template** - repository, properly structured, that contains data that can be used by **Aqua** to generate **Scaffolds** and **Injects**;
    * **Official template** - no more official then other, but is placed on GitHub under **aquapm** organisation;
    * **Custome template** - any template, that can be found across entire Internet;
* **Scaffold** - *full* project files bundle, that is generated in separate folder, and generally is **Mix project**;
* **Inject** - single file, that in most cases represents **Elixir module**, and can be placed (or *injected*) in any proper place of your **Mix project**;
* **Args** - command line arguments, that can be passed to different **Aqua** commands;
    * **Common args** - args, that are accepted by every **Aqua** command, obviosly optional;
    * **Custom args** - args, that are specified in config of **Template**. Are specific for every **Scaffold** or **Inject**;

### File system artifactory

**Aqua** uses `~/.aqua` folder for it's internal needs. This means that:

* Each user will have his own **Aqua** configuration;
* Different **Elixir** version (for example, switchable by ASDF) will share **same** configuration;

### Templates

**Templates** generally can have information about **Scaffold** and **Injects**, including there configuration and **Args**.

Official templates list can be found under:

* **AquaPM** Github organization - [here](https://github.com/aquapm)
* After calling:
  ```bash
  mix aqua list
  ```

Custom templates can be found everywhere, or created by yourself. Read [Documentation](#documentation) to get information about **Template creation**.

### Scaffold

**Scaffold** can be created using **new** command. Use:

```bash
mix aqua help new
```

in order to get information about this command. **Args** for the scaffold can be found it it's **Template** documentation

### Inject

**Inject** can be created using **add** command. Use:

```bash
mix aqua help add
```

in order to get information about this command. **Args** for the scaffold can be found it it's **Template** documentation


## Documentation

The docs can be found at [https://hexdocs.pm/aqua](https://hexdocs.pm/aqua).
