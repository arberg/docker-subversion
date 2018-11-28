set -ex

# ensure we're up to date
git pull

./build.sh

# load env after building, because it updates VERSION file
. env.sh

# tag it
git add -A
git diff-index --quiet HEAD || git commit -m "version $VERSION"
git tag -a "$VERSION" -m "version $VERSION"
git push
git push --tags

VARIANT=ubuntu
docker tag $USERNAME/$IMAGE:latest $USERNAME/$IMAGE:$VERSION-$VARIANT
# push it - below may kill shell if not logged in, see 'docker login'
docker push $USERNAME/$IMAGE:latest
docker push $USERNAME/$IMAGE:$VERSION-$VARIANT
