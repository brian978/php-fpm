.DEFAULT_GOAL := 81

env=prod

74:
	@sh ./build.sh 7.4 $(env)

80:
	@sh ./build.sh 8.0 $(env)

81:
	@sh ./build.sh 8.1 $(env)

all:
	sh ./build.sh 7.3
	sh ./build.sh 7.4
	sh ./build.sh 8.0 $(env)
	sh ./build.sh 8.1 $(env)