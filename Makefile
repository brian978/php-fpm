.DEFAULT_GOAL := 84

type=fpm
env=prod

84:
	@sh ./build.sh 8.4 $(type) $(env)

all:
	sh ./build.sh 8.4 $(type) $(env)