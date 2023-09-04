program calpi
  USE mp_global
  USE mp
  USE mp_world
  implicit none
  integer :: i
  real(kind=8) :: pi
  integer :: N, ni, start_n, last_n, rest
  real(kind=8),allocatable:: x(:), x_all(:)
  character(len=6) :: int_to_char
  CALL mp_startup()
  CALL init_clocks(.true.)
  CALL start_clock('pi')
  open(unit = 10, file=trim(int_to_char(mpime))//'.dat')
  N = 1e6
  allocate(x_all(N) )
  do i = 1, N
    x_all(i) = (dble(i)*2.0 - 1.0) / (2.0 * dble(N))
  end do
  write(10,*) x_all

  
  ni = N/nproc
  rest = N-nproc*ni
  !write(*,*) rest
  if (mpime.lt.rest) then
    ni = ni + 1
    start_n = mpime * ni + 1
    last_n = (mpime+1) * ni
  else
    start_n = mpime * ni + rest + 1
    last_n = (mpime+1) * ni + rest + 1
  end if
  !write(*,*)mpime, start_n, last_n
 
  !CALL mp_bcast(x_all,world_comm)
  allocate(x(ni))
  x(:) = x_all(start_n:last_n)

  write(10,*) x
  pi = 0.0_8
  do i = 1, ni
    pi = pi + 4.0_8/(1.0_8 + x(i)**2)
  end do

  CALL mp_sum(pi,intra_pool_comm)

  pi = pi / N

  if(ionode)write(*,'(f35.30)')pi
  CALL stop_clock('pi')
  CALL print_clock('pi')

  CALL mp_global_end()
end program calpi
