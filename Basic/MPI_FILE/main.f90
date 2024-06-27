! program test
!   USE mpi
!   implicit none
!   character(len=200) :: filename
!   real :: a(5)=(/1,2,3,4,5/)
!   integer :: myid, nproc
!   integer(kind=MPI_OFFSET_KIND) :: offset
!   integer :: lrec
!   integer :: num
!   integer :: ierr, iunit
!   CALL MPI_INIT(ierr)
!   CALL MPI_COMM_RANK(MPI_COMM_WORLD, myid, ierr)
!   CALL MPI_COMM_SIZE(MPI_COMM_WORLD, nproc, ierr)

!   ! print*, "RANK : ", ierr, myid
  
!   !call MPI_COMM_SIZE( MPI_COMM_WORLD, nproc, ierr )

!   filename='file'
!   iunit = 10086

!   CALL MPI_FILE_OPEN(MPI_COMM_WORLD, filename, MPI_MODE_RDONLY, MPI_INFO_NULL, iunit, ierr)

!   ! print*, trim(filename), myid
!   offset = INT(myid,kind=MPI_OFFSET_KIND)*4_MPI_OFFSET_KIND
!   lrec = 4
!   ! print*, "offset = ", offset, myid
!   CALL MPI_FILE_READ_AT(iunit, offset, num, lrec, MPI_INTEGER, MPI_STATUS_IGNORE, ierr)

!   print*, "num = ", num, myid

!   call MPI_FINALIZE(ierr)

! end program 

program test
  USE mpi
  implicit none
  character(len=200) :: filename
  real :: a(5)=(/1,2,3,4,5/)
  integer :: myid, nproc
  integer(kind=MPI_OFFSET_KIND) :: offset
  integer :: lrec
  integer :: num
  integer :: ierr, iunit
  CALL MPI_INIT(ierr)
  CALL MPI_COMM_RANK(MPI_COMM_WORLD, myid, ierr)
  CALL MPI_COMM_SIZE(MPI_COMM_WORLD, nproc, ierr)

  print*, "RANK : ", ierr, myid
  !call MPI_COMM_SIZE( MPI_COMM_WORLD, nproc, ierr )

  filename='file'
  iunit = 10086

  CALL MPI_FILE_OPEN(MPI_COMM_WORLD, filename, MPI_MODE_WRONLY + MPI_MODE_CREATE, MPI_INFO_NULL, iunit, ierr)

  print*, trim(filename), myid
  offset = INT(myid,kind=MPI_OFFSET_KIND)*4_MPI_OFFSET_KIND
  lrec = 1
  print*, "offset = ", offset, myid
  num = myid
  CALL MPI_FILE_WRITE_AT(iunit, offset, num, lrec, MPI_INTEGER, MPI_STATUS_IGNORE, ierr)

  print*, "num = ", num, myid
  call MPI_FILE_CLOSE(iunit, ierr)

  CALL MPI_FILE_OPEN(MPI_COMM_WORLD, filename, MPI_MODE_RDONLY, MPI_INFO_NULL, iunit, ierr)

  ! print*, trim(filename), myid
  offset = INT(myid,kind=MPI_OFFSET_KIND)*4_MPI_OFFSET_KIND
  lrec = 4
  ! print*, "offset = ", offset, myid
  if(myid < 5) then
    CALL MPI_FILE_READ_AT(iunit, offset, num, lrec, MPI_INTEGER, MPI_STATUS_IGNORE, ierr)

    print*, " read num = ", num, myid
  endif

  call MPI_FINALIZE(ierr)

end program 


! program mpi_file_example
!   use mpi
!   implicit none

!   integer :: mpi_err, rank, size, file, status(MPI_STATUS_SIZE)
!   integer(kind=MPI_OFFSET_KIND) :: offset
!   integer :: i
!   integer, parameter :: N = 100
!   integer :: buf(N)
!   character(len=30) :: filename

!   call MPI_INIT(mpi_err)
!   call MPI_COMM_RANK(MPI_COMM_WORLD, rank, mpi_err)
!   call MPI_COMM_SIZE(MPI_COMM_WORLD, size, mpi_err)

!   ! Each process will write its rank to a different portion of the file
!   filename = 'mpi_output.dat'

!   ! Initialize buffer with rank-specific values
!   buf = rank + 1

!   ! Open the file for writing (create it if it doesn't exist)
!   call MPI_FILE_OPEN(MPI_COMM_WORLD, filename, MPI_MODE_WRONLY + MPI_MODE_CREATE, MPI_INFO_NULL, file, mpi_err)

!   ! Each process writes its buffer at a different offset
!   offset = rank * N * 4 ! 4 bytes per integer
!   call MPI_FILE_WRITE_AT(file, offset, buf, N, MPI_INTEGER, status, mpi_err)

!   ! Close the file
!   call MPI_FILE_CLOSE(file, mpi_err)

!   ! Barrier to synchronize processes before reading
!   call MPI_BARRIER(MPI_COMM_WORLD, mpi_err)

!   ! Reopen the file for reading
!   call MPI_FILE_OPEN(MPI_COMM_WORLD, filename, MPI_MODE_RDONLY, MPI_INFO_NULL, file, mpi_err)

!   ! Read the data back
!   call MPI_FILE_READ_AT(file, offset, buf, N, MPI_INTEGER, status, mpi_err)

!   ! Print the read values
!   print *, 'Rank', rank, 'read values:', buf

!   ! Close the file
!   call MPI_FILE_CLOSE(file, mpi_err)

!   call MPI_FINALIZE(mpi_err)

! end program mpi_file_example
