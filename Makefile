.PHONY: deploy deploy-github serve

# Install Jekyll:
#   $ sudo apt install ruby ruby-dev
#   $ sudo gem install bundler jekyll 
serve:
	jekyll serve -d _site/ --drafts --watch

deploy:
	jekyll build -d _site/
	rsync -av --delete --exclude 'notes' --exclude '.git' --exclude 'usage' _site/ gituliar@gituliar.net:/var/www/html/
