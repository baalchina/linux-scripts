#/bin/dash
 
fatal() {
  echo "$1"
  exit 1
}
 
warn() {
  echo "$1"
}
 
# Find a source mirror near you which supports rsync on
# https://launchpad.net/ubuntu/+archivemirrors
# rsync://<iso-country-code>.rsync.archive.ubuntu.com/ubuntu should always work
RSYNCSOURCE=rsync://mirrors.ustc.edu.cn/ubuntu/
 
# Define where you want the mirror-data to be on your mirror
BASEDIR=/data/web/ubuntuarchive/
 
if [ ! -d ${BASEDIR} ]; then
  warn "${BASEDIR} does not exist yet, trying to create it..."
  mkdir -p ${BASEDIR} || fatal "Creation of ${BASEDIR} failed."
fi
 
rsync --recursive --times --links --hard-links \
  --stats \
  --exclude "Packages*" --exclude "Sources*" \
  --exclude "Release*" \
  ${RSYNCSOURCE} ${BASEDIR} || fatal "First stage of sync failed."
 
rsync --recursive --times --links --hard-links \
  --stats --delete --delete-after \
  ${RSYNCSOURCE} ${BASEDIR} || fatal "Second stage of sync failed."
 
date -u > ${BASEDIR}/project/trace/$(hostname -f)
