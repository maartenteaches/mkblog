*! version 0.1.0 MLB 20Feb2023

program define mkblog, rclass
	version 17
	syntax using, [debug] *
	
	local olddir = c(pwd)
	
	local blog mb__blog_class_instance
	mata: `blog' = mkblog()	
	
	capture noisily mkblog_main `using', `options' blog(`blog')
	
	if _rc {
		if `"`olddir'"' != `"`c(pwd)'"' {
			qui cd `olddir'
		}
		mata : `blog'.sp_fcloseall()
		if "`debug'" == "" {
			mata: mata drop `blog'
		}
		exit _rc
	}
	if "`debug'" == "" {
		mata: mata drop `blog'
	}
end

program define mkblog_main, rclass
	version 17
	syntax using/, blog(string) [replace dir(string)]
	
	mata: `blog'.run()
	
	Closingmsg, blog(`blog')
end

program define Closingmsg
	version 17
	syntax, blog(string)
	
	mata st_local("dir", `blog'.settings.other.destdir)
	mata st_local("stub", `blog'.settings.other.stub)
	
	di as txt "{p}to view the blog:{p_end}"
    di as txt "{p}first change the directory to where the blog is stored:{p_end}"
    di `"{p}{stata `"cd "`dir'""'}{p_end}"'
	di as txt "{p}Then type:{p_end}"
	di `"{p}{browse "`stub'.html"}{p_end}"'
end
