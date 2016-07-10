name=draft
LESSON=$(shell cat lesson-order.txt)

files: $(name).ipynb
	# Make lesson files
	rm -rf lesson_files/{data, examples, ipynb_checkpoints}
	mkdir -p lesson_files/examples
	cp draft.ipynb lesson_files/examples/"Lesson Draft.ipynb"
	cp -r data lesson_files/
	cp -r images lesson_files/examples/
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
