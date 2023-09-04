program gather
  USE mp_global
  USE mp
  USE mp_world,  ONLY : nproc, mpime
  implicit none
  real(kind=8) :: i(2,2)
  real(kind=8),allocatable :: i_all(:,:)
  integer :: n1_start, n1_end
  integer :: n1all, li

  CALL mp_startup()
  
  n1all =   nproc * size(i,1)
  allocate (i_all(n1all ,size(i,2)))

  i = reshape((/1,2,3,4/),(/2,2/))
  i = i + (mpime) * 4

  n1_start = mpime * size(i,1) + 1
  n1_end   = (mpime + 1) * size(i,1)

  i_all = 0
  i_all(n1_start:n1_end,:) = i(:, :)

  CALL mp_sum(i_all,intra_pool_comm)
  
  if(ionode) then
    do li = 1, n1all
      write(*,*) i_all(li,:)
    end do
  end if

  CALL mp_global_end()
end program gather
