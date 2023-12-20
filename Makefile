DEVICE='platform=iOS Simulator,name=iPhone 14,OS=17.2'

setup: 
	brew install swift-format
	touch TMDB/Networking/Secrets.plist

format:
	set -o pipefail && swift-format format -i --recursive ./

lint:
	set -o pipefail && swift-format lint --recursive ./

build:
	set -o pipefail && xcodebuild build -project TMDB.xcodeproj -scheme TMDB -destination $(DEVICE)

test:
	set -o pipefail && xcodebuild test -project TMDB.xcodeproj -scheme TMDB -destination $(DEVICE) -testPlan TMDB