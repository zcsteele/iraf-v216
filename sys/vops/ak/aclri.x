# Copyright(c) 1986 Association of Universities for Research in Astronomy Inc.

# ACLR -- Zero a vector (generic).

procedure aclri (a, npix)

int	a[ARB]
int	npix, i

begin
	do i = 1, npix
	    a[i] = 0
end
