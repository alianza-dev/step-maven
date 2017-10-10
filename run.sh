#!/bin/bash

# Some of this is modified to fit other needs from: https://bitbucket.org/xenoterracide/wercker-step-maven
# Original Author of the above repo: Caleb Cushing
# Current differences are:
## skip_on_branch feature -- allows you to specify branches you don't want to run the maven step on
## only_on_branch feature -- allows you to specify branches you only want to run the maven step on, and skip on all others
## Slightly trimmed down the bash involved and changed how things are tested

# check if maven is installed
if ! type mvn &>/dev/null; then
  error "mvn is not installed"
else
  debug "$(mvn -version)"
fi

# verify goals exist
if [[ -z $WERCKER_MAVEN_GOALS ]]; then
  fail "Must provide goals to run"
fi

function run() {
    # skip if we're on specified skipped branch
    if [[ ! -z $WERCKER_MAVEN_SKIP_ON_BRANCH ]]; then
      for skip_if_branch in $WERCKER_MAVEN_SKIP_ON_BRANCH
        do
        if [[ $WERCKER_GIT_BRANCH =~ $skip_if_branch ]]; then
          info "Skipping step due to being on branch ${WERCKER_GIT_BRANCH}"
          return 0
        fi
      done
    fi
    echo "TRY TO RUN WITH $WERCKER_MAVEN_SKIP_BUILD"
    # skip if skip_build was passed in with the string TRUE
    if [[ ! -z $WERCKER_MAVEN_SKIP_BUILD ]]; then
      local skipme=$(eval echo "\$SKIPBUILD");
      info "RUN RUN NOW"
      return 0
      if [[ "TRUE" =~ $skipme ]]; then
        info "Skipping step due to TRUE being passed by environment Variable SKIPBUILD"
        return 0
      fi
    fi

    # skip if we're expecting to be on a branch we're not
    if [[ ! -z $WERCKER_MAVEN_ONLY_ON_BRANCH ]]; then
      found=0
      #for only_on_branch in $WERCKER_MAVEN_SKIP_ON_BRANCH
      for only_on_branch in $WERCKER_MAVEN_ONLY_ON_BRANCH
        do
        if [[ $WERCKER_GIT_BRANCH =~ $only_on_branch ]]; then
          found=1
        fi
      done
      if [[ $found -eq 0 ]]; then
        info "Skipping due to being on branch ${WERCKER_GIT_BRANCH} (expecting ${WERCKER_MAVEN_ONLY_ON_BRANCH})"
        return 0
      fi
    fi

    if [[ ! -z $WERCKER_MAVEN_AS_USER ]]; then
        USER=$WERCKER_MAVEN_AS_USER
        if [[ $USER != 'root' ]]; then
            HOME=/home/$USER
        fi
    fi

    # if no settings are specified, default to the home default
    WERCKER_MAVEN_SETTINGS=${WERCKER_MAVEN_SETTINGS:-${HOME}/.m2/settings.xml}


    su $USER -c "mvn --update-snapshots \
        --batch-mode \
        -Dmaven.repo.local=${WERCKER_CACHE_DIR} \
        -DbuildServer=true \
        -s ${WERCKER_MAVEN_SETTINGS} \
        ${WERCKER_MAVEN_GOALS}"

    return $?
}

run
