program main
    USE parallel_include
    USE mp_global
    USE mp
    USE mp_world,  ONLY : nproc, myid=>mpime, world_comm
    implicit none
    integer :: ierr
    integer :: npp=100000,nloop=10000
    integer :: i, j, k, l
    integer,allocatable :: ifull(:)
    integer,allocatable:: np(:), offset(:)
    CALL mp_startup()

    ! write(*,"('myid = ',I4,' nproc : ',I4)"), myid, nproc
    ALLOCATE(ifull(npp*nproc),&
    np(nproc),offset(nproc))


    ! write(*,"('myid = ',I4,' start ifull : ',1000I4)"), myid, ifull
    CALL MP_BARRIER(world_comm)
    np=npp
    do i = 1, nproc
        offset(i) = (i-1) * npp
    enddo
    ! write(*,"('myid = ',I4,' offset : ',1000I4)"), myid, offset
    do i = 1, nloop
        CALL start_clock("allgatherv")
        ifull(offset(myid+1)+1:offset(myid+1)+npp)=myid
        CALL MPI_ALLGATHERV( MPI_IN_PLACE, 0, MPI_DATATYPE_NULL, &
            ifull, np, offset, MPI_INTEGER, world_comm, ierr )
        CALL stop_clock("allgatherv")
    enddo

    CALL MP_BARRIER(world_comm)
    ! check results
    do i = 1, nproc
        do j = 1,npp
            if( ifull((i-1)*npp+j) .ne. i-1 ) write(*,*)"ERROR",myid,i,j
        enddo
    enddo

    ! write(*,"('myid = ',I4,' ifull : ',1000I4)"), myid, ifull

    CALL MP_BARRIER(world_comm)

    np=npp
    do i = 1, nproc
        offset(i) = (i-1) * npp
    enddo
    ! write(*,"('myid = ',I4,' offset : ',1000I4)"), myid, offset
    CALL start_clock("MPSUM")
    do i = 1, nloop
        ifull=0
        ifull(offset(myid+1)+1:offset(myid+1)+npp)=myid
        CALL mp_sum(ifull,world_comm)
    enddo
    CALL stop_clock("MPSUM")

    CALL MP_BARRIER(world_comm)
    ! check results
    do i = 1, nproc
        do j = 1,npp
            if( ifull((i-1)*npp+j) .ne. i-1 ) write(*,*)"ERROR",myid,i,j
        enddo
    enddo

    if(myid==0)CALL print_clock("allgatherv")
    if(myid==0)CALL print_clock("MPSUM")
    CALL mp_global_end()

end program
