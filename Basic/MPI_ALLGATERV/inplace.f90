program main
implicit none
include "mpif.h"
integer :: myid, ierr, nproc
integer :: ifull(10)
integer :: np(4), offset(4)
CALL MPI_INIT(ierr)
CALL MPI_COMM_RANK(MPI_COMM_WORLD, myid, ierr)
CALL MPI_COMM_SIZE(MPI_COMM_WORLD, nproc, ierr)

ifull=0
if (myid == 0)ifull(1)=1

if (myid == 1)then
    ifull(2)=2
    ifull(3)=3
endif

if (myid == 2)then
    ifull(4)=4
    ifull(5)=5
    ifull(6)=6 
endif

if (myid == 3) then
    ifull(7)=7 
    ifull(8)=8 
    ifull(9)=9 
    ifull(10)=10
endif

CALL MPI_BARRIER(MPI_COMM_WORLD, ierr)
write(*,"('myid = ',I4,' ifull : ',10I4)"), myid, ifull
np=(/1,2,3,4/)
offset=(/0,1,3,6/)

CALL MPI_ALLGATHERV( MPI_IN_PLACE, 0, MPI_DATATYPE_NULL, &
       ifull, np, offset, MPI_INTEGER, MPI_COMM_WORLD, ierr )

CALL MPI_BARRIER(MPI_COMM_WORLD, ierr)
write(*,"('myid = ',I4,' ifull : ',10I4)"), myid, ifull

CALL MPI_BARRIER(MPI_COMM_WORLD, ierr)

CALL MPI_FINALIZE(ierr)

end program
