clear all
mata:
mata set matastrict on
class mkblog {
	string                  matrix    source
	real                    matrix    source_version
	real                    scalar    rows_source
	real                    rowvector mkblog_version
	class  AssociativeArray scalar    files
	struct mbsettings       scalar    settings
	struct mbstate          scalar    state
	real                    scalar    fh_main
	
	void                              run()
	void                              new()
	
	//_read.mata
	void                              where_err()
	void                              read()
	void                              parsedirs()
	void                              cd()
	real                    scalar    mb_fopen()
	void                              mb_fclose()
	void                              mb_fcloseall()
	
	//_write.mata
	void                              write_header()
	void                              write_footer()
	void                              write_pagetitle()
	void                              beginsec()
	void                              endsec()
	void                              beginart()
	void                              endart()
    void                              truncfile()
}

struct mbsettings {
	string                  scalar    replace
	string                  scalar    stub
	string                  scalar    sourcedir
	string                  scalar    source 
	string                  scalar    olddir
	string                  scalar    destdir
	string                  scalar    pagetitle
    string                  scalar    tempdo
    string                  scalar    templog
    string                  scalar    temphtml
    string                  scalar    tempname
}

struct mbstate {
	real                    scalar    secopen
	real                    scalar    artopen
	real                    scalar    exopen
	real                    scalar    sec
	real                    scalar    art
	real                    scalar    ex
}

void mkblog::new()
{
    state.secopen = 0
    state.artopen = 0
    state.exopen  = 0
    state.sec     = 0
    state.art     = 0
    state.ex      = 0
}
void mkblog::run()
{
	
}
end
do _read.mata
do _write.mata