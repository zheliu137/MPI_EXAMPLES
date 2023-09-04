# Makefile for Modules

include make.inc

# location of needed modules

# list of modules

MODFLAGS = -IMP

MODULES = MP/libqempi.a

all : mpi main.x

## If no update_version is found, or it is not executable,
## just copy version.f90.in (that contains 'version=unknown').
## We use cat and not cp so that version.f90 has a new timestamp,
## forcing recompilation of version.f90.
## We use the inner if to avoid recompilation at each make.


main.x: main.o	$(MODULES)
	$(LD) $(LDFLAGS) -o $@ \
	main.o $(MODULES) $(LIBS)

mpi :
	cd MP; make


clean :
	- /bin/rm -f *.o *.a *.d *.i *~ *_tmp.f90 *.mod *.L

# .PHONY forces execution of a rule irrespective of the presence of an
# updated file with the same name of the rule. In this way, the script 
# that generates version.f90 always runs, updating the version if you 
# execute "svn update". The update_version script takes care of not
# changing the file if the svn version did not change

.PHONY: version all clean

