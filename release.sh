# ensure we're up to date
git pull

LAST_VERSION=$(cat VERSION)

./build.sh

# load env after building, because it updates VERSION file
. env.sh


if [[ "$LAST_VERSION" != "$VERSION" ]] ;  then
	set -ex
	# tag it
	git add -A
	# Do 'git diff-index || git commit' to avoid committing nothing and to avoid failing due to exitcode 1 and 'set -ex'
	git diff-index --quiet HEAD || git commit -m "version $VERSION"
	git tag -a "$VERSION" -m "version $VERSION"
	git push
	git push --tags

	VARIANT=ubuntu
	docker tag $USERNAME/$IMAGE:latest $USERNAME/$IMAGE:$VERSION-$VARIANT
	# push it - below may kill shell if not logged in, see 'docker login'
	docker push $USERNAME/$IMAGE:latest
	docker push $USERNAME/$IMAGE:$VERSION-$VARIANT
else 
	echo "Skip release, because version has already been released"
fi
