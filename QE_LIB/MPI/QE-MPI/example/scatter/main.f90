program scatter
  USE mp_global
  USE mp
  USE mp_world,  ONLY : nproc, mpime
  implicit none
  real(kind=8) :: i_all(4,2)
  real(kind=8),allocatable :: i(:,:)
  integer :: n1_start, n1_end
  integer :: n1, li
  character(LEN=6),external :: int_to_char
  character(len=30) :: filename

  CALL mp_startup()
  
  i_all = reshape((/1,2,3,4,5,6,7,8/),(/4,2/))
  
  CALL mp_bcast (i_all, ionode_id, intra_pool_comm)
  
  n1  =   size(i_all,1)/nproc
  allocate (i(n1 ,size(i_all,2)))

  n1_start = mpime * size(i,1) + 1
  n1_end   = (mpime + 1) * size(i,1)

  i(:, :) = i_all(n1_start:n1_end,:) 

 
  filename = trim(int_to_char(mpime))//'.dat'
  open(unit=10,file=filename)
  do li = 1, n1
    write(10,*) i(li,:)
  end do
  close(10)

  CALL mp_global_end()
end program
