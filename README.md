# Unraid Templates
Collection of Unraid docker container templates

# Gettings Started

Add this repo to your unraid docker templates list.

# Updating templates
This repo uses [go-jsonnet](https://github.com/google/go-jsonnet) to render templates compatible with the [DockerTemplateSchema](https://wiki.unraid.net/DockerTemplateSchema). You can make changes to the templates found in the [jsonnet/](jsonnet/) folder. Anything ending in `.jsonnet` is a template consumed by jsonnet. There you will also find the [jsonnet/lib/](jsonnet/lib/) folder, which has helper libraries for conforming to the specification, as well as an XML abstraction layer.

To re-render the templates, simply run
```bash
task render
```

This will install a local copy of `jsonnet` and render all templates.

- Note, you must have Go installed and in your path to perform jsonnet commands.
