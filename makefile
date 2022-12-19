test: 
	find tests -type f -name '*.Test.mo' -not -path "tests/utils/*" -print0 | xargs -0 $(shell vessel bin)/moc -r $(shell mops sources) -wasi-system-api

doc:
	$(shell vessel bin)/mo-doc
	$(shell vessel bin)/mo-doc --format plain