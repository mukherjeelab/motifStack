#' read pcm from a path
#' 
#' read position count matrix from a path
#' 
#' 
#' @param path a character vector of full path names
#' @param pattern an optional regular expression
#' @return A list of \code{\link{pcm}} objects
#' @export
#' @importFrom utils read.table
#' @examples
#' 
#' pcms<-readPCM(file.path(find.package("motifStack"), "extdata"),"pcm$")
#' 
readPCM <- function(path=".", pattern=NULL){
    pcms <- dir(path,pattern)
    pcml <- lapply(pcms, function(.ele){
        data <- read.table(file.path(path, basename(.ele)))
        classes <- sapply(data, class)
        data <- data[, classes %in% c("integer", "numeric")]
        rownames(data) <- c("A", "C", "G", "T")
        data
    })
    names(pcml) <- gsub("\\.(pcm|txt)$", "", basename(pcms), ignore.case=TRUE)
    pcm <- mapply(function(.d, .n){
        new("pcm", mat=as.matrix(.d), name=gsub("\\.", "_", make.names(.n))) 
    }, pcml, names(pcml))
    names(pcm) <- gsub("\\.", "_", make.names(names(pcm)))
    pcm
}

readPWM <- function(path=".", pattern=NULL, to=c("pfm", "pcm")){
    to <- match.arg(to)
    pwms <- dir(path,pattern)
    pwml <- lapply(pwms, function(.ele){
        data <- readLines(file.path(path, basename(.ele)))
        data <- data[grepl("^[ACGT]:",data)]
        data <- do.call(rbind, strsplit(data, "\\t"))
        rownames(data) <- gsub(":", "", data[,1])
        data <- data[c("A","C","G","T"), -1]
        data <- as.data.frame(data)
        for(i in 1:ncol(data)) data[,i] <- as.numeric(as.character(data[,i]))
        as.matrix(data)
    })
    names(pwml) <- gsub("[\\._](pwm|txt|pwm\\.txt)$", "", basename(pwms), ignore.case=TRUE)
    pwm <- mapply(function(.d, .n){
        if(!all(colSums(.d)==1)) .d <- .25*exp(.d)
        if(to=="pfm") new("pfm", mat=as.matrix(.d), name=gsub("\\.", "_", make.names(.n)))
        else{
            .d <- round(.d * 1000)
            new("pcm", mat=as.matrix(.d), name=gsub("\\.", "_", make.names(.n)))
        }
    }, pwml, names(pwml))
    names(pwm) <- gsub("\\.", "_", make.names(names(pwm)))
    pwm
}



#' retrieve color setting for logo
#' 
#' retrieve color setting for logo
#' 
#' 
#' @param alphabet character, 'DNA', 'RNA' or 'AA'
#' @param colorScheme 'auto', 'charge', 'chemistry', 'classic' or
#' 'hydrophobicity' for AA, 'auto', 'basepairing', or 'blindnessSafe' for DNA
#' ro RNA
#' @return A character vector of color scheme
#' @export
#' @examples
#' 
#' col <- colorset("AA", "hydrophobicity")
#' 
colorset<-function(alphabet="DNA", colorScheme='auto'){
    if(!alphabet %in% c("DNA","RNA","AA")) stop("alphabet must be one of 'DNA', 'RNA' or 'AA'")
    if(alphabet=='PROTEIN' & !(colorScheme %in% c('auto', 'charge', 'chemistry', 'classic', 'hydrophobicity')))
    stop("color scheme must be one of 'auto', 'charge', 'chemistry', 'classic' or 'hydrophobicity' for protein")
    if(alphabet %in% c('DNA','RNA') & !(colorScheme %in% c('auto', 'basepairing', 'blindnessSafe')))
    stop("color scheme must be one of 'auto', 'basepairing' or 'blindnessSafe'")
    taylor<-c(  'A'='#CCFF00',
                'C'='#FFFF00',
                'D'='#FF0000',
                'E'='#FF0066',
                'F'='#00FF66',
                'G'='#FF9900',
                'H'='#0066FF',
                'I'='#66FF00',
                'K'='#6600FF',
                'L'='#33FF00',
                'M'='#00FF00',
                'N'='#CC00FF',
                'P'='#FFCC00',
                'Q'='#FF00CC',
                'R'='#0000FF',
                'S'='#FF3300',
                'T'='#FF6600',
                'V'='#99FF00',
                'W'='#00CCFF',
                'Y'='#00FFCC')
    charge<-c(   'A'='#CCCCCC',
                 'C'='#CCCCCC',
                 'D'='#FFB32C',
                 'E'='#FFB32C',
                 'F'='#CCCCCC',
                 'G'='#CCCCCC',
                 'H'='#2000C7',
                 'I'='#CCCCCC',
                 'K'='#2000C7',
                 'L'='#CCCCCC',
                 'M'='#CCCCCC',
                 'N'='#CCCCCC',
                 'P'='#CCCCCC',
                 'Q'='#CCCCCC',
                 'R'='#2000C7',
                 'S'='#CCCCCC',
                 'T'='#CCCCCC',
                 'V'='#CCCCCC',
                 'W'='#CCCCCC',
                 'Y'='#CCCCCC')
    chemistry<-c(   'A'='#000000',
                    'C'='#00811B',
                    'D'='#D00001',
                    'E'='#D00001',
                    'F'='#000000',
                    'G'='#00811B',
                    'H'='#2000C7',
                    'I'='#000000',
                    'K'='#2000C7',
                    'L'='#000000',
                    'M'='#000000',
                    'N'='#800080',
                    'P'='#000000',
                    'Q'='#800080',
                    'R'='#2000C7',
                    'S'='#00811B',
                    'T'='#00811B',
                    'V'='#000000',
                    'W'='#000000',
                    'Y'='#00811B')
    hydrophobicity<-c(   'A'='#00811B',
                         'C'='#2000C7',
                         'D'='#000000',
                         'E'='#000000',
                         'F'='#2000C7',
                         'G'='#00811B',
                         'H'='#00811B',
                         'I'='#2000C7',
                         'K'='#000000',
                         'L'='#2000C7',
                         'M'='#2000C7',
                         'N'='#000000',
                         'P'='#00811B',
                         'Q'='#000000',
                         'R'='#000000',
                         'S'='#00811B',
                         'T'='#00811B',
                         'V'='#2000C7',
                         'W'='#2000C7',
                         'Y'='#2000C7')
    base_pairing<-c('A'="#ff8c00",'C'="#2000C7",'G'="#2000C7",'TU'="#ff8c00")
    nucleotide<-c('A'="#00811B",'C'="#2000C7",'G'="#FFB32C",'TU'="#D00001")
    blindnessSafe <- c('A'="#009E73", 'C'="#0072B2", 'G'="#E69F00", 'TU'="#D55E00")
    if(alphabet=='DNA'){
        color<-switch(colorScheme, auto=nucleotide, 
                      basepairing=base_pairing, blindnessSafe=blindnessSafe)
        names(color)<-c('A','C','G','T')
        color
    }else{
        if(alphabet=='RNA'){
            color<-switch(colorScheme, auto=nucleotide, 
                          basepairing=base_pairing, blindnessSafe=blindnessSafe)
            names(color)<-c('A','C','G','U')
            color
        }else{
            switch(colorScheme, 
                   auto=taylor, 
                   charge=charge, 
                   chemistry=chemistry, 
                   classic=taylor, 
                   hydrophobicity=hydrophobicity)
        }
    }
}




#' add alpha transparency value to a color
#' 
#' An alpha transparency value can be specified to a color, in order to get
#' better color for background.
#' 
#' 
#' @param col vector of any of the three kinds of R color specifications, i.e.,
#' either a color name (as listed by \link[grDevices]{colors}()), a hexadecimal
#' string of the form "#rrggbb" or "#rrggbbaa" (see \link[grDevices]{rgb}), or
#' a positive integer i meaning \link[grDevices]{palette}()[i].
#' @param alpha a value in [0, 1]
#' @return a vector of colors in hexadecimal string of the form "#rrggbbaa".
#' @author Jianhong Ou
#' @keywords misc
#' @export
#' @importFrom grDevices col2rgb rgb
#' @examples
#' 
#'     highlightCol(1:5, 0.3)
#'     highlightCol(c("red", "green", "blue"), 0.3)
#' 
highlightCol <- function (col, alpha=0.5){
  if(alpha==1){
    return(col)
  }
  if(alpha<0 || alpha >1){
    stop("alpha must be a number in [0, 1].")
  }
    n <- names(col)
    col <- col2rgb(col,alpha=TRUE)
    col <- apply(col, 2, function(.ele, alpha){rgb(.ele[1], .ele[2], .ele[3], alpha=ceiling(alpha*.ele[4]), maxColorValue=255)}, alpha)
    col <- unlist(col)
    names(col) <- n
    col
}



#' convert pfm object to PWM
#' 
#' convert pfm object to PWM
#' 
#' 
#' @param x an object of \code{\link{pfm}} or \code{\link{pcm}} or matrix
#' @param N Total number of event counts used for pfm generation.
#' @return A numeric matrix representing the Position Weight Matrix for PWM.
#' @author Jianhong Ou
#' @seealso \code{\link[Biostrings:matchPWM]{PWM}}
#' @keywords misc
#' @export
#' @importFrom Biostrings PWM
#' @examples
#' 
#' library("MotifDb")
#' matrix.fly <- query(MotifDb, "Dmelanogaster")
#' pfm2pwm(matrix.fly[[1]])
#' 
pfm2pwm <- function(x, N=10000){
    if(!inherits(x, c("pfm", "pcm", "matrix")))
        stop("x must be an object of matrix or pcm or pfm")
  if(inherits(x, c("pcm", "pfm"))){
    prior.params=x@background
  }else{
    prior.params=rep(1/nrow(x), nrow(x))
    names(prior.params) <- rownames(x)
  }
  if(is(x, "pcm")){
    x <- x@mat
  }else{
    if(is(x, "pfm")){
      x <- x@mat*N
    }else{
      x <- x*N
    }
    x <- round(x)
    x[nrow(x),] <- N - colSums(x[-nrow(x),])
    id <- which(x[nrow(x),] < 0)
    if(length(id)>0){
      max.id <- apply(x, 2, function(.e) which(.e==max(.e))[1])
      for(i in 1:length(id)){
        x[max.id[id[i]], id[i]] <- x[max.id[id[i]], id[i]] + x[nrow(x), id[i]]
      }
      x[nrow(x), id] <- 0
    }
  }
  mode(x) <- "integer"
  PWM(x, prior.params=prior.params)
}

#' @importFrom stats loess predict
isHomoDimer <- function(x, t=0.001){
    if(!inherits(x, c("pfm", "pcm"))) stop("x must be an object of pfm or pcm")
    if(is(x, "pcm")) x <- pcm2pfm(x)
    ic <- getIC(x)
    if(length(ic)<11) return(FALSE)
    x.loess <- loess(y ~ x, span=.75, data.frame(x=1:length(ic), y=ic))
    x.predict <- predict(x.loess, data.frame(x=1:length(ic)))
    names(x.predict) <- NULL
    x.sign <- rle(sign(diff(x.predict)))
    x.values <- x.sign$values[x.sign$lengths>1]
    if(length(x.values)<3 && !identical(x.values, c(-1,1))) return(FALSE)
    y <- matrixReverseComplement(x)
    pfms <- list(x=x, y=y)
    d <- matalign(pfms, revComp=FALSE)
    ifelse(d$distance<t, TRUE, FALSE)
}


getHomoDimerCenter <- function(x){
    if(!inherits(x, c("pfm", "pcm"))) stop("x must be an object of pfm or pcm")
    if(is(x, "pcm")) x <- pcm2pfm(x)
    len <- ncol(x@mat)
    if(len < 6) return(NA)
    ra <- 3:(len-3) ## minimal monomer 3mer
    dist <- sapply(ra, function(pos){
        a <- b <- c <- x
        a@mat <- a@mat[, 1:pos]
        b@mat <- b@mat[, (pos+1):len]
        c@mat <- c@mat[, (pos+2):len]
        b <- matrixReverseComplement(b)
        c <- matrixReverseComplement(c)
        pfms <- list(a=a, b=b)
        d <- matalign(pfms, revComp=FALSE)
        pfms2 <- list(a=a, c=c)
        d2 <- matalign(pfms2, revComp=FALSE)
        c(d1=d$distance, d2=d2$distance)
    })
    colnames(dist) <- ra
    n <- which(dist==min(dist))
    
    j <- ceiling(n/2)
    i <- n + 2 - (2*j)
    pos <- ra[j]
    pos <- ifelse(i==2, pos+1, pos)
    ord <- order(abs(len/2 - pos))[1]
    pos <- pos[ord]
    type <- ifelse(i[ord]==2, "odd", "even")
    c(pos=pos, type=type)
}
