#!/bin/bash
set -e
set -u
set -o pipefail

repos='spec threads simd exception-handling gc bulk-memory-operations tail-call nontrapping-float-to-int-conversions multi-value host-bindings sign-extension-ops mutable-global'

log_and_run() {
    echo ">>" $*
    if ! $*; then
        echo "sub-command failed: $*"
        exit
    fi
}

try_log_and_run() {
    echo ">>" $*
    $*
}

pushdir() {
    pushd $1 >/dev/null || exit
}

popdir() {
    popd >/dev/null || exit
}

update_repo() {
    local repo=$1
    pushdir repos
        if [ -d ${repo} ]; then
            log_and_run git -C ${repo} fetch origin
            log_and_run git -C ${repo} reset origin/master --hard
        else
            log_and_run git clone https://github.com/WebAssembly/${repo}
        fi

        # Add upstream spec as "spec" remote.
        if [ "${repo}" != "spec" ]; then
            pushdir ${repo}
                if ! git remote | grep spec >/dev/null; then
                    log_and_run git remote add spec https://github.com/WebAssembly/spec
                fi

                log_and_run git fetch spec
            popdir
        fi
    popdir
}

merge_with_spec() {
    local repo=$1

    [ "${repo}" == "spec" ] && return

    pushdir repos/${repo}
        # Create and checkout "try-merge" branch.
        if ! git branch | grep try-merge >/dev/null; then
            log_and_run git branch try-merge origin/master
        fi
        log_and_run git checkout try-merge

        # Attempt to merge with spec/master.
        log_and_run git reset origin/master --hard
        try_log_and_run git merge -q spec/master -m "merged"
        if [ $? -ne 0 ]; then
            git merge --abort
            popdir
            return 1
        fi
    popdir
    return 0
}


echo -e "update repos\n" > commit_message

failed_repos=

for repo in ${repos}; do
    echo "++ updating ${repo}"
    update_repo ${repo}

    if ! merge_with_spec ${repo}; then
        echo -e "!! error merging ${repo}, skipping\n"
        failed_repos="${failed_repos} ${repo}"
        continue
    fi

    if [ "${repo}" = "spec" ]; then
        wast_dir=.
        log_and_run cp repos/${repo}/test/core/*.wast ${wast_dir}
    else
        wast_dir=proposals/${repo}
        mkdir -p ${wast_dir}

        # Don't add tests from propsoal that are the same as spec.
        pushdir repos/${repo}
            for new in test/core/*.wast; do
                old=../../repos/spec/${new}
                if [[ ! -f ${old} ]] || ! diff ${old} ${new} >/dev/null; then
                    log_and_run cp ${new} ../../${wast_dir}
                fi
            done
        popdir
    fi

    # Check whether any files were updated.
    if [ $(git status -s ${wast_dir}/*.wast | wc -l) -ne 0 ]; then
        log_and_run git add ${wast_dir}/*.wast

        repo_sha=$(git -C repos/${repo} log --max-count=1 --pretty=oneline | sed -e 's/ .*//')
        echo "  ${repo}: ${repo_sha}" >> commit_message
    fi

    echo -e "-- ${repo}\n"
done

git commit -a -F commit_message
# git push

echo "done"

if [ -n "${failed_repos}" ]; then
  echo "!! failed to update repos: ${failed_repos}"
fi
