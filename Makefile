.PHONY: all pkgdown

readme:
	@quarto render README.qmd

air:
	@air format

check:
	@R -e "devtools::check()" --quiet --no-restore --no-save

pkgdown:
	@R -e "pkgdown::build_site()" --quiet --no-restore --no-save

readme-pkgdown: readme pkgdown

roxydoc:
	@R -e "devtools::document()" --quiet --no-restore --no-save

build:
	@R -e "pak::local_install(upgrade = FALSE, dependencies = FALSE)" --quiet --no-restore --no-save

build-readme: build readme

bump:
ifndef VERSION
	$(error VERSION is not set. Usage: make bump VERSION=x.y.z)
endif
	@bump-my-version bump --new-version $(VERSION)
	@$(MAKE) --no-print-directory build-readme
	@git add README.md
	@git commit --amend --no-edit

web-preview:
	@quarto preview inst/website/index.qmd --port 4242 --no-browser --no-watch-inputs --output-dir nogit/website-tmp --embed-resources

web-render:
	@quarto render inst/website/
