con = url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlCode = readLines(con)
close(con)
x <- nchar(htmlCode)
x[c(10,20,30,100)]