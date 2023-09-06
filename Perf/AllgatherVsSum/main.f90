program main
implicit none
    USE parallel_include
    USE mp_global
    USE mp
    USE mp_world,  ONLY : nproc, myid=>mpime, world_comm
    implicit none
integer :: myid, ierr
integer :: npp=10
integer :: i, j, k, l
integer,allocatable :: ifull(:)
integer,allocatable:: np(:), offset(:)

CALL mp_startup()

ALLOCATE(ifull(npp*nproc),&
np(nproc),offset(nproc))

ifull=myid

CALL MPI_BARRIER(world_comm, ierr)
write(*,"('myid = ',I4,' ifull : ',10I4)"), myid, ifull
np=npp
do i = 1 nproc
    offset(i) = myid * npp
enddo

CALL MPI_ALLGATHERV( MPI_IN_PLACE, 0, MPI_DATATYPE_NULL, &
       ifull, np, offset, MPI_INTEGER, world_comm, ierr )

CALL MP_BARRIER(world_comm)
write(*,"('myid = ',I4,' ifull : ',10I4)"), myid, ifull

CALL MP_BARRIER(world_comm)

CALL mp_global_end()

end program
