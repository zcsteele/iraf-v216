# Copyright(c) 1986 Association of Universities for Research in Astronomy Inc.

include	<syserr.h>
include	<gio.h>

# GRSCALE -- Rescale the world coordinates of either the X or Y axis to fit the
# data vector.  This is done by taking the minimum and maximum of the current
# WCS limits and the data vector.  May be called repeatedly to find the range
# of a family of vectors.

procedure grscale (gp, v, npts, axis)

pointer	gp			# graphics descriptor
real	v[ARB]			# data vector
int	npts			# length of data vector
int	axis			# asis to be scaled (1=X, 2=Y)

int	start, i
real	minval, maxval, pixval
pointer	w

begin
	# Find first definite valued pixel.  If entire data vector is
	# indefinite we merely ignore it, since the window is presumably
	# already set.

	for (start=1;  start <= npts;  start=start+1)
	    if (!IS_INDEF (v[start]))
		break
	if (start > npts)
	    return

	minval = v[start]
	maxval = minval

	# Compute min and max values of data vector.
	do i = start+1, npts {
	    pixval = v[i]
	    if (!IS_INDEF(pixval))
		if (pixval < minval)
		    minval = pixval
		else if (pixval > maxval)
		    maxval = pixval
	}

	w = GP_WCSPTR (gp, GP_WCS(gp))

	# Update the window limits.
	switch (axis) {
	case 1:
	    WCS_WX1(w) = min (WCS_WX1(w), minval)
	    WCS_WX2(w) = max (WCS_WX2(w), maxval)
	case 2:
	    WCS_WY1(w) = min (WCS_WY1(w), minval)
	    WCS_WY2(w) = max (WCS_WY2(w), maxval)
	default:
	    call syserr (SYS_GSCALE)
	}

	WCS_FLAGS(w) = or (WCS_FLAGS(w), WF_DEFINED)
	GP_WCSSTATE(gp) = MODIFIED
	call gpl_reset()
end
