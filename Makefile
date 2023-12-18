format:
	set -o pipefail && swift-format format -i --recursive ./

lint:
	set -o pipefail && swift-format lint --recursive ./