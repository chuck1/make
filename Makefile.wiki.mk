
files_md   := $(shell find pages/ -name '*.md')

files_html := $(patsubst pages/%.md, html/%.html, $(files_md))



all: $(files_html) pages.xml


pages.xml: $(files_html)
	@echo building $@...
	@python ~/Programming/Python/wiki/build.py


debug:
	@echo $(files_md)
	@echo $(files_html)


html/%.html: pages/%.md
	@echo building $@...
	@mkdir -p $(dir $@)
	@perl Markdown/Markdown.pl $< > $@



