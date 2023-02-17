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
	
	void                              run()
	
	
	real                    scalar    mb_fo pen()
	void                              mb_fclose()
	void                              mb_fcloseall()
}

struct mbsettings {
	string                  scalar    replace
}
end