all: benchmark-report.html

sync: benchmark-report.ipynb

benchmark-report.ipynb: benchmark-report.py benchmark-report.md
	@echo "Running sync"
	jupytext --sync $@

rendered.ipynb: benchmark-report.md
	@echo "Executing Report Notebook"
	jupytext $< --set-kernel "python3" --to ipynb -o - \
| jupyter nbconvert \
      --stdin \
      --execute \
      --to ipynb \
      --stdout \
      > $@

benchmark-report.html: rendered.ipynb
	@echo "Convert to HTML"
	cat $< | jupyter nbconvert \
      --stdin \
      --no-input \
      --to html \
      --template lab \
      --stdout \
      --ExecutePreprocessor.store_widget_state=True \
      | sed 's/<title>Notebook/<title>Benchmark Report/g' > $@

_export/index.html: benchmark-report.html
	mkdir -p _export
	cp -a $< $@

export: _export/index.html
	mkdir -p _export/data
	mkdir -p _export/images
	cp -a data/* _export/data/
	cp -a images/* _export/images/

clean:
	rm -f benchmark-report.html
	rm -rf _export
