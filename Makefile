CC ?= gcc
CFLAGS_common ?= -Wall -std=gnu99
CFLAGS_orig = -O0
CFLAGS_opt  = -O0 -pthread -g -pg
CFLAGS_pool  = -pthread -g

ifdef THREAD
CFLAGS_opt  += -D THREAD_NUM=${THREAD}
endif

ifeq ($(strip $(DEBUG)),1)
CFLAGS_opt += -DDEBUG -g
endif

EXEC = phonebook_orig phonebook_opt_row phonebook_opt_col 
all: $(EXEC)

SRCS_common = main.c

file_align: file_align.c
	$(CC) $(CFLAGS_common) $^ -o $@

threadpool: threadpool.c threadpool.h
	$(CC) $(CFLAGS_common) $(CFLAGS_pool) $@.c $@

phonebook_orig: $(SRCS_common) phonebook_orig.c phonebook_orig.h
	$(CC) $(CFLAGS_common) $(CFLAGS_orig) \
		-DIMPL="\"$@.h\"" -o $@ \
		$(SRCS_common) $@.c

phonebook_opt_row: $(SRCS_common) phonebook_opt.c phonebook_opt.h threadpool.h 
	$(CC) $(CFLAGS_common) $(CFLAGS_opt) \
		-DIMPL="\"phonebook_opt.h\"" -DROW -o $@ \
		$(SRCS_common) phonebook_opt.c threadpool.c

phonebook_opt_col: $(SRCS_common) phonebook_opt.c phonebook_opt.h threadpool.h 
	$(CC) $(CFLAGS_common) $(CFLAGS_opt) \
		-DIMPL="\"phonebook_opt.h\"" -DCOL -o $@ \
		$(SRCS_common) phonebook_opt.c threadpool.c

run: $(EXEC)
	echo 3 | sudo tee /proc/sys/vm/drop_caches
	watch -d -t "./phonebook_orig && echo 3 | sudo tee /proc/sys/vm/drop_caches"

cache-test: $(EXEC)
	perf stat --repeat 100 \
		-e cache-misses,cache-references,instructions,cycles \
		./phonebook_orig
	perf stat --repeat 100 \
		-e cache-misses,cache-references,instructions,cycles \
		./phonebook_opt_row
	perf stat --repeat 100 \
		-e cache-misses,cache-references,instructions,cycles \
		./phonebook_opt_col

output.txt: cache-test calculate
	./calculate

plot: output.txt
	gnuplot scripts/runtime.gp

calculate: calculate.c
	$(CC) $(CFLAGS_common) $^ -o $@

.PHONY: clean
clean:
	$(RM) $(EXEC) *.o perf.* \
	      	calculate orig.txt row.txt col.txt output.txt runtime.png file_align align.txt new.txt sort.txt
