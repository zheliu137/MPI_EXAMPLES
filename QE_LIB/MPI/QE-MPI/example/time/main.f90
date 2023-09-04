program test
  USE ISO_C_BINDING
  USE mp_global
  USE mp
  USE mp_world
  implicit none
  integer :: i
  CALL mp_startup()
  
  call init_clocks(.true.)
  call start_clock('a')

  call stop_clock('a')

  call print_clock('a')

  CALL mp_global_end()
end program test
