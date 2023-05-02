.PHONY: serve

# Install Jekyll:
#   $ sudo apt install ruby ruby-dev
#   $ sudo gem install bundler jekyll 
serve:
	bundler exec jekyll serve -d _site/ --drafts --watch --livereload

install:
	bundler install
