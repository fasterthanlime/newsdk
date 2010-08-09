.PHONY: all clean

all:
	rm -rf rock_tmp && rock -sdk=sdk test -v -nolibcache -driver=sequence -g -nolines

clean:
	rm -rf rock_tmp test
