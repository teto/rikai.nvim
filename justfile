# justfile to run Busted tests

# Target to run Busted tests
test:
	@busted --lua=nlua


kokoro-test:
	# pipe it into mpv ?
	python3 -m kokoro --text "The sky above the port was the color of television, tuned to a dead channel." -o file.wav --debug
