name=draft
handoutname=Mining\ Texts\ with\ the\ Extracted\ Features\ Dataset
LESSON=$(shell cat lesson-order.txt)

files: $(name).ipynb
	# Make lesson files
	rm -rf lesson_files/{data, examples, handouts, ipynb_checkpoints}
	mkdir -p lesson_files/examples
	cp draft.ipynb lesson_files/examples/"Lesson Draft.ipynb"
	cp -r data lesson_files/
	cp -r handouts lesson_files/handouts
	cp -r images lesson_files/examples/
	cp Within-Book\ Sentiment\ Trends.ipynb lesson_files/
	zip -r lesson_files.zip lesson_files

$(name).ipynb:
	python scripts/merge-notebooks.py -o $@ $(LESSON)

$(name).md: $(name).ipynb
	jupyter nbconvert --to markdown $(name).ipynb

$(name).html: $(name).ipynb
	jupyter nbconvert --to html --template full $(name).ipynb

clean:
	rm -f $(name).{md,html,ipynb}
	rm -rf $(name)_files
	rm -f $(handoutname).{md,html,ipynb}
	rm -rf $(handoutname)_files
	rm -f *.{tex,out,log,aux}

handout: $(name).ipynb
	mv $(name).ipynb $(handoutname).ipynb
	jupyter nbconvert $(handoutname).ipynb --to latex
	pdflatex $(handoutname)
	pdflatex $(handoutname)
	pdflatex $(handoutname)
	mv $(handoutname).pdf handouts/
