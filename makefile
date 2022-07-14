
test:
	$(shell vessel bin)/moc -r $(shell vessel sources) -wasi-system-api ./tests/*Test.mo

docs: test
	$(shell vessel bin)/mo-doc