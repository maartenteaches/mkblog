mata:
void smclpres::where_err(real scalar rownr)
{
	string scalar errmsg
	errmsg = "{p}{err}This error occured on line {res}" + source[rownr,3] + " {err}in {res}" + source[rownr,2] + "{p_end}"
	printf(errmsg)
}

real scalar mkblog::mb_fopen ( string scalar file, string scalar mode, | real scalar sourcerow) {
	real scalar fh, errcode
	string scalar errmsg

    if (mode == "w" & settings.replace == "replace") {
        errcode = _unlink(file)
        if (errcode != 0){
			errmsg = "{p}{err}an error occured when replacing file " + file + "{p_end}"
            printf(errmsg)
            if (args() == 3) {
                where_err(sourcerow)
            }
			exit(abs(errcode))
        }
    }
	fh = _fopen(file, mode)
    if (fh < 0 ) {
        errmsg = "{p}{err}An error occured when opening file " + file +"{p_end}"
        printf(errmsg)
		if (args() == 3) {
            where_err(sourcerow)
        }
        exit(abs(fh))
    }
	files.put(fh, "open")
	return(fh)
}

void mkblog::mb_fclose ( real scalar fh,| real scalar sourcerow) {
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

void mkblog::mb_fcloseall () {
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

void mkblog::parsedirs()
{
    string scalar usingpath, dir, replace
    string scalar file, stub, odir, path, sdir, source, ddir

    usingpath = st_local("using")
    dir = st_local("dir")
    replace = st_local("replace")
    pathsplit(usingpath, path="", file="")
    stub = pathrmsuffix(file)
    odir = pwd()
    if(path != "") cd(path)
    sdir = pwd()
    source = pathjoin(sdir,file)
    if (dir!= "") {
        cd(odir)
        cd(dir)
        ddir = pwd()
    }
    else {
        ddir = odir
    }
    cd(odir)
	settings.stub      = stub
	settings.sourcedir = sdir
	settings.source    = source
	settings.olddir    = odir
	settings.destdir   = ddir
	settings.replace   = replace
    settings.tempfile  = st_local("temp")
    settings.tempname  = st_local("name")
}

void smclpres::cd(string scalar path) {
    real scalar rc
    string scalar errmsg
    rc = _chdir(path)
    if (rc != 0) {
        errmsg = "{p}{err}directory " + path + " not found{p_end}"
        printf(errmsg)
        exit(rc)
    }
}

end