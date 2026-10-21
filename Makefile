.DEFAULT_GOAL := 84

type=fpm
env=prod

84:
	@sh ./build.sh 8.4 $(type) $(env)

all:
	sh ./build.sh 8.4 $(type) $(env)

# arm64 images for local development on a Mac, built into its Docker under the
# usual tags and never pushed. Prod first, so the dev image is built on it
# rather than on whatever 8.4 image is already cached. Re-run it whenever the
# 8.4 Dockerfiles change.
mac:
	@sh ./build.sh 8.4 $(type) prod local
	@sh ./build.sh 8.4 $(type) dev local