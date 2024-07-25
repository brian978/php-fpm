.DEFAULT_GOAL := 82

type=fpm
env=prod

80:
	@sh ./build.sh 8.0 $(type) $(env)

81:
	@sh ./build.sh 8.1 $(type) $(env)

82:
	@sh ./build.sh 8.2 $(type) $(env)

all:
	sh ./build.sh 8.0 $(type) $(env)
	sh ./build.sh 8.1 $(type) $(env)
	sh ./build.sh 8.2 $(type) $(env)