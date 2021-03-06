#' @name checkimg-methods
#' @docType methods 
#' @aliases checkimg
#' @description Ensures the output to be a character filename (or vector) from an input
#' image or \code{nifti}.  
#' @title Force object to filename 
#' @param file character or \code{nifti} object
#' @param allow_array allow arrays to be passed in
#' @param ... options passed to \code{\link{tempimg}}
#' @return character filename of image or temporary nii, 
#' with .nii extension
#' 
#' @export
#' @author John Muschelli \email{muschellij2@@gmail.com}
setGeneric("checkimg", function(file, 
                                allow_array = FALSE, ...) standardGeneric("checkimg"))

#' @rdname checkimg-methods
#' @aliases checkimg,nifti-method
#' @export
setMethod("checkimg", "nifti", function(file, ...) { 
  file = tempimg(file, ...)
  return(file)
})


#' @rdname checkimg-methods
#' @aliases checkimg,ANY-method
#' @export
setMethod("checkimg", "ANY", function(file, allow_array = FALSE, ...) {
            # workaround because can't get class
            if (inherits(file, "niftiImage")) {
              tfile = tempfile(fileext = ".nii.gz")
              RNifti::writeNifti(image = file, file = tfile, ...)
              return(tfile)
            } else {
              if (allow_array) {
                if (is.array(file)) {
                  file = as.nifti(file)
                  return(checkimg(file, ...))
                }
              }
              stop("Not implemented for this type!")
            }
            return(file)
          })

#' @rdname checkimg-methods
#' @aliases checkimg,character-method
#' @importFrom R.utils gunzip
#'  
#' @export
setMethod("checkimg", "character", function(file, ...) { 
  ### add vector capability
  if (length(file) > 1) {
    file = sapply(file, checkimg, ...)
    return(file)
  } else {
    file = path.expand(file)
    file = file.path(dirname(file), basename(file))
    suppressWarnings({
      file = normalizePath(file)
    })
    return(file)
  }
})




#' @rdname checkimg-methods
#' @aliases checkimg,list-method
#' @export
setMethod("checkimg", "list", function(file, ...) { 
  ### add vector capability
  file = sapply(file, checkimg, ...)
  return(file)
})



