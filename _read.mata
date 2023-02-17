mata:
real scalar mkblog::mb_fopen ( string scalar file, string scalar mode, | real scalar sourcerow) {
	real scalar fh, errcode
	string scalar errmsg

    if (mode == "w" & settings.other.replace == "replace") {
        errcode = _unlink(file)
        if (errcode != 0){
            if (args() == 3) {
                errmsg = "{p}{err}an error occured when replacing file " + file + "{p_end}"
                printf(errmsg)
                where_err(sourcerow)
                exit(abs(errcode))
            }
            else {
                errmsg = "{p}{err}an error occured when replacing file " + file + "{p_end}"
                printf(errmsg)
                exit(error(abs(errcode)))
            }
        }
    }
	fh = _fopen(file, mode)
    if (fh < 0 ) {
        if (args() == 3) {
            errmsg = "{p}{err}An error occured when opening file " + file +"{p_end}"
            printf(errmsg)
            where_err(sourcerow)
            exit(abs(fh))
        }
        else {
            errmsg = "{p}{err}An error occured when opening file " + file +"{p_end}"
            printf(errmsg)
            exit(error(abs(fh)))
        }
    }
	files.put(fh, "open")
	return(fh)
}

void smclpres::sp_fclose ( real scalar fh,| real scalar sourcerow) {
    real scalar errcode
    string scalar errmsg

    errcode = _fclose(fh)
    if (errcode < 0 ) {
        if (args() == 2) {
            errmsg = "{p}{err}An error occured when closing a file {p_end}"
            printf(errmsg)
            where_err(sourcerow)
            exit(abs(errcode))
        }
        else {
            exit(error(abs(errcode)))
        }
    }
	files.put( fh, "closed")
}

void smclpres::sp_fcloseall () {
	transmorphic scalar notfound
	real         scalar fh
    string       scalar val
	
    notfound = files.notfound()
    for (val=files.firstval(); val!=notfound; val=files.nextval()) {
        if (val == "open") {
            fh = files.key()
            fclose(fh)
            files.put(fh, "closed")
        }
    }
}
end