.DEFAULT_GOAL := 74

73:
	sh ./build.sh 7.3

74:
	sh ./build.sh 7.4

80:
	sh ./build.sh 8.0


all:
	sh ./build.sh 7.3
	sh ./build.sh 7.4
	sh ./build.sh 8.0