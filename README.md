# step-maven

A simple maven executor written in `bash`

# Options

- `goals` String with all of the options you want to use
- `skip_on_branch` Skips running this step if the branch specified is the one being run
- `only_on_branch` Skips running this step if the branch specified is not the one being run
- `settings` Path to the settings.xml to use, defaults to $HOME/.m2/settings.xml


# Example

```yaml
build:
    steps:
      - alianza/maven:
        goals: -Dmaven.test.failure.ignore=false test
        settings: $HOME/.m2/settings.xml
        skip_on_branch: master

      - alianza/maven:
        goals: -Dmaven.test.failure.ignore=false deploy
        settings: $HOME/.m2/settings.xml
        only_on_branch: master
```

# License

Apache 2.0

# Changelog

## 1.0.0

- Initial release
