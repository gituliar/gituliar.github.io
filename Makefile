.PHONY: deploy deploy-github serve

serve:
	jekyll serve -d _site/ --drafts --watch

deploy:
	jekyll build -d _site/
	rsync -av --delete --exclude 'notes' --exclude '.git' --exclude 'usage' _site/ gituliar@gituliar.net:/var/www/html/
