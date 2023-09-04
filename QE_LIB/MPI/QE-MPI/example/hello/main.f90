program test
  USE mp_global
  USE mp
  USE mp_world
  implicit none
  integer :: i
  i=3
  CALL mp_startup()

  !write(*,*)
  CALL mp_sum(i,intra_pool_comm)
  write(*,*) mpime
  write(6,*) i

  CALL mp_global_end()
end program test
