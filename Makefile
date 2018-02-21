DEST = /usr/local/bin/

SCRIPTS = $(filter-out LICENSE Makefile, $(wildcard *))
SCRIPTS_DEST = $(addprefix $(DEST), $(SCRIPTS))

make_symlinks: $(SCRIPTS_DEST)

$(DEST)%: %
	ln -sf $(realpath $<) $@

clean:
	$(RM) $(SCRIPTS_DEST)
