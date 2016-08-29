#!/usr/bin/sh

BUILD_FOLDER="gym-rankings-frontend/"
HTML_FOLDER="/var/www/gym.rationell.nu/public/"

npm run build && cd dist && \
ssh contabo "rm -rf $BUILD_FOLDER*" && \
rsync -r * contabo:gym-rankings-frontend && \
ssh contabo \
"cp -r $BUILD_FOLDER* $HTML_FOLDER && chown -R legopelle:apache $HTML_FOLDER"

