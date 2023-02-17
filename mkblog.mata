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
	struct mbstate          scalar    write_sectitle
	struct mbstate          scalar    write_arttitle()
}

struct mbsettings {
	string                  scalar    replace
	string                  scalar    stub
	string                  scalar    sdir
	string                  scalar    source 
	string                  scalar    odir
	string                  scalar    ddir
	string                  scalar    pagetitle
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
	
}
void mkblog::run()
{
	
}
end
do _read.mata
do _write.mata