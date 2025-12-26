SRC := main.jule
OUT := juleup
JC := julec # please prefer 0.1.6 release
CC := clang

all: $(OUT)

$(OUT):
	julec --compiler $(CC) . -o $(OUT)

clean:
	rm -f $(OUT)

.PHONY: all $(OUT) clean
