program main
implicit none
include 'mpif.h'
integer :: myid, ierr, nproc
integer :: a
a = 0
call MPI_INIT( ierr )

call MPI_COMM_RANK( MPI_COMM_WORLD, myid, ierr )

call MPI_COMM_SIZE( MPI_COMM_WORLD, nproc, ierr )

if(myid.eq.0) a = 3
write(*,'("Process ", I2, ",   a = ", I3)') myid,a

call MPI_BCAST(a, 1, MPI_INTEGER, 0, MPI_COMM_WORLD, ierr)
call MPI_BARRIER(MPI_COMM_WORLD, ierr)

if(myid.eq.0) write(*,*) 'after bcast:'

call MPI_BARRIER(MPI_COMM_WORLD, ierr)
write(*,'("Process ", I2, ",   a = ", I3)') myid,a
call MPI_FINALIZE(ierr)

end
