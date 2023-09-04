program gather2
  USE mp_global
  USE mp
  USE mp_world,  ONLY : nproc, mpime, world_comm
  implicit none
  real(kind=8) :: i(2,2)
  real(kind=8),allocatable :: i_all(:,:), i_ (:,:), i_all_(:,:)
  integer :: n1_start, n1_end
  integer,allocatable :: n1recv(:), disp(:)
  integer :: n1all, li

  CALL mp_startup()
  
  n1all =   nproc * size(i,1)

  allocate (i_all(n1all ,size(i,2)))
  allocate (i_all_(size(i,2), n1all))
  allocate (i_(size(i,2), size(i,1)))
  allocate (n1recv(nproc))
  allocate (disp(nproc))
  
  n1recv = size(i,1)
  do li = 1, nproc
    disp(li) = (li-1) * size(i,1)
  end do

  i = reshape((/1,2,3,4/),(/2,2/))
  i = i + (mpime) * 4
  i_ = transpose(i)

  CALL mp_gather(i_, i_all_, n1recv, disp, ionode_id, world_comm)
  i_all = transpose(i_all_)

  if(ionode) then
    do li = 1, n1all
      write(*,*) i_all(li,:)
    end do
  end if

  CALL mp_global_end()
end program gather2
