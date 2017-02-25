# step-maven

A simple maven executor written in `bash`

# Options

- `goals` String with all of the options you want to use
- `skip_on_branch` Skips running this step if the branch specified is the one being run
- `only_on_branch` Skips running this step if the branch specified is not the one being run
- `settings` Path to the settings.xml to use, defaults to $HOME/.m2/settings.xml
- `as_user` Run the maven commands as a user already set up on the box


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
        as_user: postgres
```

# License

Apache 2.0

# Changelog

## 1.0.0

- Initial release

## 1.0.5

- update skip_on_branch and only_on_branch so they accept regex

## 1.0.6

- Fix hardcoded 0 in return bug

## 1.0.9

- Add as_user option
