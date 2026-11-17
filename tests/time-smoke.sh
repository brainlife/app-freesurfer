#!/usr/bin/env bash
set -eu
: "${FREESURFER_HOME:?FREESURFER_HOME must be set by the image}"
input=${1:-"$FREESURFER_HOME/subjects/fsaverage3/surf/lh.white"}
output_dir=$(mktemp -d /tmp/freesurfer-time-smoke.XXXXXX)
trap 'rm -rf "$output_dir"' EXIT
test -x /usr/bin/time
/usr/bin/time --version
/usr/bin/time -f 'time_smoke_exit=%x' -o "$output_dir/exit.txt" /bin/sh -c 'exit 7' && exit 1 || status=$?
test "$status" -eq 7
grep -q '^time_smoke_exit=7$' "$output_dir/exit.txt"
"$FREESURFER_HOME/bin/fs_time" -o "$output_dir/remesh.time" \
  "$FREESURFER_HOME/bin/mris_remesh" --remesh --iters 3 \
  --input "$input" --output "$output_dir/remeshed.surf"
test -s "$output_dir/remeshed.surf"
grep -q '^@#@FSTIME ' "$output_dir/remesh.time"
sha256sum "$FREESURFER_HOME/build-stamp.txt" \
  "$FREESURFER_HOME/bin/recon-all" \
  "$FREESURFER_HOME/bin/fs_time" \
  "$FREESURFER_HOME/bin/mris_remesh"
printf '%s\n' 'GNU time and FreeSurfer remeshing smoke test passed'
