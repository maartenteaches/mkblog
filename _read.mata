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
    settings.tempdo    = st_local("do")
    settings.templog   = st_local("log")
    settings.temphtml  = st_local("html")
    settings.tempname  = st_local("name")
}

void mkblog::cd(string scalar path) {
    real scalar rc
    string scalar errmsg
    rc = _chdir(path)
    if (rc != 0) {
        errmsg = "{p}{err}directory " + path + " not found{p_end}"
        printf(errmsg)
        exit(rc)
    }
}

real scalar mkblog::_read_file(string scalar filename, real scalar lnr, real rowvector current_version) {
    transmorphic scalar t
    string matrix EOF, toadd
    real matrix toadd_v
    real scalar fh, i, newlines
    string scalar line, part, cmd
    real rowvector old_version
    
    EOF = J(0,0,"")
    newlines = count_lines(filename)
    toadd = J(newlines,3,"")
    source = source \ toadd
    toadd_v = J(newlines,3,.)
    source_version = source_version \toadd_v
    

    fh = mb_fopen(filename, "r")
    i = 0
    t = tokeninit()
    while ((line=fget(fh))!=EOF) {
        i++
        tokenset(t,line)
        part = tokenget(t)
        if (part == "//include") {
            source = source[|1,1 \ rows(source)-1,3|]
            source_version = source_version[|1,1 \ rows(source_version)-1,3|]
            part = tokenget(t)
            if (!pathisabs(part)) part = settings.sourcedir + part
            old_version = current_version
            lnr = _read_file(part, lnr, current_version)
            current_version = old_version
        }
        else if (part == "//version") {
            source = source[|1,1 \ rows(source)-1,3|]
            source_version = source_version[|1,1 \ rows(source_version)-1,3|]
            part = tokenget(t)
            current_version = parse_version(part, filename, i)
        }
        else if (part == "//set") {
            source = source[|1,1 \ rows(source)-1,3|]
            source_version = source_version[|1,1 \ rows(source_version)-1,3|]
            parse_set(tokenrest(t))
        }
        else {
            source[lnr,1] = line
            source[lnr,2] = filename
            source[lnr,3] = strofreal(i)
            source_version[lnr++,.] = current_version
        }
    }
    sp_fclose(fh)
    return(lnr)
}

void mkblog::read_file() {
    real scalar i

    i = _read_file(settings.source,1, mkblog_version)
    rows_source = rows(source)
    // replace tab with white spaces
    source[.,1] = usubinstr(source[.,1], char(9), settings.tab*" ", .)
}

real scalar mkblog::countlines(string scalar filename) {
    string matrix EOF
    real scalar fh, i
    
    fh = mb_fopen(filename, "r")
    EOF = J(0,0,"")
    
    i=0
    while (fget(fh)!=EOF) {
       i++ 
    }
    mb_fclose(fh)
    return(i)
}

real rowvector mkblog::parse_version(string scalar valstr, string scalar filename, real scalar lnr)
{
	real scalar l, i, j
	real rowvector v
	string scalar part, errmsg, where
	string rowvector res, nr

    where = "{p}{err}This error occured on line " + strofreal(lnr) + " of " + filename + "{p_end}"
	res = "", J(1,2,"0")
	l = ustrlen(valstr)
	j=1
	nr = "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"
	
	for(i=1; i<=l; i++) {
		part = usubstr(valstr,i,1)
		if (anyof(nr,part)) {
			res[j] = res[j]+part
		}
		else if (part == "." ) {
			if (i!=l) {
				j=j+1
				if (j>3) {
                    printf("{p}{err}format for version number is #.#.#{p_end}")
                    printf(where)
					exit(198)
				}
				res[j]=""
			}
		}
		else {
			printf("{p}{err}format for version number is #.#.#{p_end}")
            printf(where)
            exit(198)
		}
	}
	v = strtoreal(res)
    if (blog_lt_val(1, v, "max")) {
        errmsg = invtokens(strofreal(mkblog_version), ".")
        errmsg = "{p}{err}this is version " + errmsg + " of mkblog{p_end}"    
        printf(errmsg)
        printf("{p}{err}a version specified in //version cannot exceed that{p_end}")
        printf(errmsg)
        printf(where)
        exit(198)
    }
	return(v)
}

real scalar mkblog::blog_lt_val(real scalar sourcerow, real rowvector tocheck, | string scalar max) 
{
    real scalar i, res
	real rowvector pres
	
    if (args()==2) {
		pres = source_version[sourcerow,.]
	}
	else {
		pres = mkblog_version
	}

	res = 0
	for (i=1; i<=3 ; i++) {
		if (pres[i] > tocheck[i]) {
			break
		}
	    if (pres[i] < tocheck[i]) {
		    res = 1
			break
		}
	}
	return(res)
}

real scalar mkblog::blog_leq_val(real scalar sourcerow, real rowvector tocheck) 
{
	if (tocheck==source_version[sourcerow,.]) return(1)
	return(blog_lt_val(sourcerow, tocheck))
}

real scalar mkblog::blog_geq_val(real scalar sourcerow, real rowvector tocheck) 
{
	if (tocheck==source_version[sourcerow,.]) return(1)
	return(pres_gt_val(sourcerow, tocheck))
}

real scalar mkblog::blog_gt_val(real scalar sourcerow, real rowvector tocheck) 
{
    real scalar i, res
	
	res = 0
	for (i=1; i<=3 ; i++) {
		if (source_version[sourcerow, i] > tocheck[i]) {
			res = 1
			break
		}
	    if (source_version[sourcerow, i] < tocheck[i]) {
			break
		}
	}
	return(res)
}
end