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
	void                              read_file()
    real                    scalar    _read_file()
    real                    scalar    countlines()    
	void                              parsedirs()
	void                              cd()
	real                    scalar    mb_fopen()
	void                              mb_fclose()
	void                              mb_fcloseall()
    real                    rowvector parse_version()
    real                    scalar    blog_lt_val()
    real                    scalar    blog_leq_val()
    real                    scalar    blog_gt_val()
    real                    scalar    blog_geq_val()
    void                              parse_set()
    
	
	//_write.mata
	void                              write_header()
	void                              write_footer()
	void                              write_pagetitle()
	void                              beginsec()
	void                              endsec()
	void                              beginart()
	void                              endart()
    void                              truncfile()
    void                              copyfile()
    void                              open_ex()
    void                              close_ex()
    void                              log2html()
    void                              opentxt()
    void                              closetxt()
    void                              write_blog()
    void                              fill_blog()
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
    real                    scalar    tab
    string                  scalar    title
}

struct mbstate {
	real                    scalar    secopen
	real                    scalar    artopen
	real                    scalar    exopen
    real                    scalar    txtopen
	real                    scalar    sec
	real                    scalar    art
	real                    scalar    ex
    string                  scalar    exname
    real                    scalar    fh_ex
    real                    scalar    exline
}

void mkblog::new()
{
    state.secopen = 0
    state.artopen = 0
    state.exopen  = 0
    state.txtopen = 0
    state.sec     = 0
    state.art     = 0
    state.ex      = 0
    
    settings.tab  = 4
    settings.title = "A blog"
    
    mkblog_version = (0,1,0)
	
	files.reinit("real")
	source = J(0,3,"")
	source_version = J(0,3,.)
}
void mkblog::run()
{
    parsedirs()
    read_file()
    cd(settings.destdir)
    write_blog()
    cd(settings.olddir)
}
end
do _read.mata
do _write.mata