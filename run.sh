#!/bin/bash

# Some of this is modified to fit other needs from: https://bitbucket.org/xenoterracide/wercker-step-maven
# Original Author of the above repo: Caleb Cushing

# if no settings are specified, default to the home default
WERCKER_MAVEN_SETTINGS=${WERCKER_MAVEN_SETTINGS:-${HOME}/.m2/settings.xml}

# check if maven is installed
if ! type mvn &>/dev/null; then
  error "mvn is not installed"
else
  debug "$(mvn -version)"
fi

# verify goals exist
if [ -z "$WERCKER_MAVEN_GOALS" ]; then
  fail "Must provide goals to run"
fi

function run {
    # skip if we're on specified skipped branch
    if [ ! -z "$WERCKER_MAVEN_SKIP_ON_BRANCH" ]; then
      for skip_if_branch in $WERCKER_MAVEN_SKIP_ON_BRANCH
        do
        if [ "$WERCKER_GIT_BRANCH" == "$skip_if_branch" ]; then
          info "Skipping step due to being on branch ${WERCKER_GIT_BRANCH}"
          return 0
        fi
      done
    fi

    # skip if we're expecting to be on a branch we're not
    if [ ! -z "$WERCKER_MAVEN_ONLY_ON_BRANCH" ]; then
      found=0
      for only_on_branch in $WERCKER_MAVEN_SKIP_ON_BRANCH
        do
        if [ "$WERCKER_GIT_BRANCH" == "$only_on_branch" ]; then
          found=1
        fi
      done
      if [ $found -eq 0 ]; then
        info "Skipping due to being on branch ${WERCKER_GIT_BRANCH} (expecting ${WERCKER_MAVEN_ONLY_ON_BRANCH})"
        return 0
      fi
    fi

    mvn --update-snapshots \
        --batch-mode \
        -Dmaven.repo.local=${WERCKER_CACHE_DIR} \
        -s ${WERCKER_MAVEN_SETTINGS} \
        ${WERCKER_MAVEN_GOALS}

    return 0
}

run()
