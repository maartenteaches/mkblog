mata:

void mkblog::write_blog()
{
    write_header()
    write_pagetitle()
    fill_blog()
    write_footer()
}

void mkblog::fill_blog()
{
    real scalar i
    string scalar part
    transmorphic scalar t

    t = tokeninit()
    
    for(i=1; i <= rows_source; i++) {
        tokenset(t, source[i,1])
        part = tokenget(t)
        if (part == "//sec") {
            beginsec(tokenrest(t), i)
        }
        else if (part == "//endsec") {
            endsec(i)
        }
        else if (part == "//art") {
            beginart(tokenrest(t), i)
        }
        else if (part == "//endart") {
            endart(i)
        }
        else if (part == "//ex") {
            open_ex(i)
        }
        else if (part == "//endex") {
            close_ex(i)
        }
        else if (part == "/*txt") {
            opentxt(i)
        }
        else if (part == "txt*/") {
            closetxt(i)
        }
        else if (state.exopen == 1) {
            fput(state.fh_ex, source[i,1])
            state.exline = state.exline + 1
        }
        else {
            fput(fh_main, source[i,1])
        }
    }
}

void mkblog::write_header()
{
	string scalar destfile
	
	destfile = pathjoin(settings.destdir, settings.stub + ".html")
	fh_main = mb_fopen(destfile, "w") 
	
	fput(fh_main, `"<html>"')
	fput(fh_main, `"<head>"')
	fput(fh_main, `"<meta http-equiv="Content-type" content="text/html; charset=iso-8859-1">"')
	fput(fh_main, `"<meta name="viewport" content="width=device-width, initial-scale=1">"')
	fput(fh_main, `"<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">"')
	fput(fh_main, `"<style>"')
	fput(fh_main, `".input, .error{font-weight: bold}"')
	fput(fh_main, `".input {color: black}"')
	fput(fh_main, `".result{color: #435761}"')
	fput(fh_main, `".error{color: red}"')
	fput(fh_main, `"div.w3-code {"')
	fput(fh_main, `"    width: 90%;"')
	fput(fh_main, `"    max-height: 500px;"')
	fput(fh_main, `"    overflow: auto;"')
	fput(fh_main, `"    margin: 0px auto 0px auto;"')
	fput(fh_main, `"}"')
    fput(fh_main, `".dolink{"')
    fput(fh_main, `"    text-align:right; "')
    fput(fh_main, `"    padding:0px; "')
    fput(fh_main, `"    margin:0px;"')
    fput(fh_main, `"}"')
	fput(fh_main, `"   "')     
	fput(fh_main, `"</style>"')
	fput(fh_main, `"</head>"')
	fput(fh_main, `"<body>"')
}

void mkblog::write_pagetitle()
{

	fput(fh_main, `"<div class="w3-row">"')
	fput(fh_main, `"	<div class="w3-col m1 w3-container"></div>"')
	fput(fh_main, `"	<div class="w3-col m10 w3-container w3-blue-gray" >"')
	fput(fh_main, `"		<h2>"' + settings.title + `"</h2>"')
	fput(fh_main, `"	</div>"')
	fput(fh_main, `"</div>"')
	fput(fh_main, " ")
	fput(fh_main, `"<div class="w3-row">"') // begins row
	fput(fh_main, `"	<div class="w3-col w3-container m1 "></div>"')
	fput(fh_main, `"	<div class="w3-col m10 ">"') // begins column
}

void mkblog::beginsec(string scalar title, sourcerow)
{
	string scalar secid, towrite, errmsg
	
	if(state.exopen == 1) {
		errmsg = "{p}{err}Starting a new section and an example is still open{p_end}"
		printf(errmsg)
		where_err(sourcerow)
		exit(198)
	}
	if(state.secopen==1) {
		errmsg = "{p}{err}Starting a new section and an section is still open{p_end}"
		printf(errmsg)
		where_err(sourcerow)
		exit(198)
	}
	if(state.artopen==1){
		errmsg = "{p}{err}Starting a new section and an article is still open{p_end}"
		printf(errmsg)
		where_err(sourcerow)
		exit(198)
	}
    if (state.txtopen == 1) {
        errmsg = "{p}{err}Starting a new section and a text block is still open{p_end}"
        printf(errmsg)
        where_err(sourcerow)
        exit(198)
    }
	
	state.sec = state.sec + 1
	secid = "sec"+strofreal(state.sec)
	
	towrite = `"<button onclick="myFunction('"' + secid + `"')" "'
	towrite = towrite + `"class="w3-container w3-block w3-white w3-left-align w3-border w3-border-blue-gray">"'
	fput(fh_main, towrite)
	towrite = `"<H4>&#x25BC; "' + title + `"</H4>"' 
    fput(fh_main, towrite)    
    fput(fh_main, "</button>")
	towrite = `"<div id=""' + secid + `"" class="w3-hide">"'
	fput(fh_main, towrite)
       
	state.secopen = 1
}
void mkblog::endsec(real scalar sourcerow)
{
	string scalar errmsg
	if (state.secopen == 0) {
		errmsg = "{p}{err}Tried to close a section, but none was open{p_end}"
		printf(errmsg)
		where_err(sourcerow)
		exit(198)
	}
    if (state.txtopen==1) {
		errmsg = "{p}{err}Tried to close a section, but a text block was open{p_end}"
		printf(errmsg)
		where_err(sourcerow)
		exit(198)        
    }
    if (state.exopen==1) {
		errmsg = "{p}{err}Tried to close a section, but an example was open{p_end}"
		printf(errmsg)
		where_err(sourcerow)
		exit(198)        
    }
    if (state.artopen==1) {
		errmsg = "{p}{err}Tried to close a section, but an article was open{p_end}"
		printf(errmsg)
		where_err(sourcerow)
		exit(198)        
    }
	fput(fh_main, "</div>")
	state.secopen = 0
}

void mkblog::beginart(string scalar title, real scalar sourcerow)
{
	string scalar artid, towrite, errmsg
	
	if(state.exopen == 1) {
		errmsg = "{p}{err}Starting a new article and an example is still open{p_end}"
		printf(errmsg)
		where_err(sourcerow)
		exit(198)
	}
	if(state.artopen==1){
		errmsg = "{p}{err}Starting a new article and an article is still open{p_end}"
		printf(errmsg)
		where_err(sourcerow)
		exit(198)
	}
    if (state.txtopen == 1) {
        errmsg = "{p}{err}Starting a new article and a text block is still open{p_end}"
        printf(errmsg)
        where_err(sourcerow)
        exit(198)
    }
	
	state.art = state.art + 1
    state.ex  = 0
	artid = "art"+strofreal(state.art)
	
	towrite = `"<button onclick="myFunction('"' + artid + `"')" "'
	towrite = towrite + `"class="w3-container w3-block w3-white w3-left-align w3-border-0">"'
	fput(fh_main, towrite)
	towrite = `"<H5>&#x25BC; "' + title + `"</H5>"' 
    fput(fh_main, towrite)    
    fput(fh_main, "</button>")
	towrite = `"<div id=""' + artid + `"" class="w3-hide">"'
	fput(fh_main, towrite)
       
	state.artopen = 1
}
void mkblog::endart(real scalar sourcerow)
{
	string scalar errmsg
	if (state.artopen == 0) {
		errmsg = "{p}{err}Tried to close an article, but none was open{p_end}"
		printf(errmsg)
		where_err(sourcerow)
		exit(198)
	}
	if(state.exopen == 1) {
		errmsg = "{p}{err}Tried to close an article and an example is still open{p_end}"
		printf(errmsg)
		where_err(sourcerow)
		exit(198)
	}
    if (state.txtopen == 1) {
        errmsg = "{p}{err}Tried to close an article and a text block is still open{p_end}"
        printf(errmsg)
        where_err(sourcerow)
        exit(198)
    }
	fput(fh_main, "</div>")
	state.artopen = 0
}


void mkblog::write_footer()
{
	string scalar errmsg

	if(state.exopen == 1) {
		errmsg = "{p}{err}Reached the end of the file and an example is still open{p_end}"
		printf(errmsg)
		exit(198)
	}
	if(state.artopen == 1) {
		errmsg = "{p}{err}Reached the end of the file and an article is still open{p_end}"
		printf(errmsg)
		exit(198)
	}
	if(state.secopen == 1) {
		errmsg = "{p}{err}Reached the end of the file and a section is still open{p_end}"
		printf(errmsg)
		exit(198)
	}
    if (state.txtopen == 1) {
        errmsg = "{p}{err}Reached the end of the file and a text block is still open{p_end}"
		printf(errmsg)
		exit(198)
    }
	fput(fh_main, "</div>") //ends column
	fput(fh_main, "</div>") //ends row
	
	fput(fh_main, `"<script>"')
	fput(fh_main, `"function myFunction(id) {"')
	fput(fh_main, `"  var x = document.getElementById(id);"')
	fput(fh_main, `"  if (x.className.indexOf("w3-show") == -1) {"')
	fput(fh_main, `"    x.className += " w3-show";"')
	fput(fh_main, `"    x.previousElementSibling.className ="')
	fput(fh_main, `"    x.previousElementSibling.className.replace("w3-white", "w3-blue-gray");"')
	fput(fh_main, `"  } else {"')
	fput(fh_main, `"    x.className = x.className.replace(" w3-show", "");"')
	fput(fh_main, `"    x.previousElementSibling.className ="')
	fput(fh_main, `"    x.previousElementSibling.className.replace("w3-blue-gray", "w3-white");"')
	fput(fh_main, `"  }"')
	fput(fh_main, `"}"')
	fput(fh_main, `"</script>"')
	fput(fh_main, "</body>")
	fput(fh_main, "</html>")
	mb_fclose(fh_main)
}

void mkblog::truncfile(string scalar orig, string scalar dest, 
                       real scalar lb, real scalar ub)
{
    string scalar EOF, line
    real scalar fh_in, fh_out, i
    
    EOF = J(0,0,"")
    fh_in = mb_fopen(orig, "r")
    if (settings.replace == "replace") {
        unlink(dest)
    }
    fh_out = mb_fopen(dest, "w")    
    i = 0
    while ((line=fget(fh_in)) != EOF) {
        i = i + 1
        if (i >= lb & i <= ub) {
            fput(fh_out, line)
        }
    }
    mb_fclose(fh_in)
    mb_fclose(fh_out)
}

void mkblog::copyfile(string scalar orig)
{
    string scalar EOF, line
    real scalar fh_in
    
    EOF = J(0,0,"")
    fh_in = mb_fopen(orig, "r")
    
    while ((line=fget(fh_in)) != EOF) {
        fput(fh_main, line)
    }
    mb_fclose(fh_in)
}

void mkblog::open_ex(real scalar sourcerow)
{
    string scalar errmsg
    
    if (state.exopen==1){
        errmsg = "{p}{err}Tried to open an example when one was already open{p_end}"
        printf(errmsg)
        where_err(sourcerow)
    }
    if (state.artopen==0){
        errmsg = "{p}{err}Tried to open an example when no article was open{p_end}"
        printf(errmsg)
        where_err(sourcerow)
    }
    state.ex = state.ex + 1
    state.exopen = 1
    state.exname = "art" + strofreal(state.art) + "ex" + strofreal(state.ex) + ".do"
    state.exline = 1

    state.fh_ex = mb_fopen(settings.tempdo, "w")
    fput(state.fh_ex, "log using "+ settings.templog  + ", smcl name("+ settings.tempname +") nomsg replace")
}
void mkblog::close_ex(real scalar sourcerow)
{
    string scalar cmd, errmsg
    
    if (state.exopen==0){
        errmsg = "{p}{err}Tried to close an example when none was open{p_end}"
        printf(errmsg)
        where_err(sourcerow)
    }
    if (state.artopen==0){
        errmsg = "{p}{err}Tried to close an example when no article was open{p_end}"
        printf(errmsg)
        where_err(sourcerow)
    }
    
    fput(state.fh_ex, "log close " + settings.tempname)
    mb_fclose(state.fh_ex)
    
    cmd = "do " +  settings.tempdo
    stata(cmd)
    
    truncfile(settings.tempdo, state.exname, 2, state.exline)
    unlink(settings.tempdo)
    
    log2html()
	state.exopen = 0
}


// port of log2html by Kit Baum, Nick Cox, and Bill Rising
void mkblog::log2html()
{
    string scalar cmd, EOF, line
    real scalar fh_clog, fh_rlog, nlines, i, c, cprev

    EOF = J(0,0, "")
    
    cmd = `"log html ""' + settings.templog + `"" ""' + settings.temphtml + `"", replace yebf whbf "'
    stata(cmd, 1)
    unlink(settings.templog)
    
    nlines = countlines(settings.temphtml)
    
    fh_clog = mb_fopen(settings.templog, "w")
    fput(fh_clog, `"<div class="w3-code notranslate w3-border-blue-gray"><code>"')
    
    fh_rlog = mb_fopen(settings.temphtml,"r")
    i = 0
    cprev = 0
    while((line=fget(fh_rlog)) != EOF) {
        i++
        if (i==2) continue
        if (i==nlines-2 & line == "<p>") continue
        if (i==nlines-1) continue
        
        line = subinstr(line, "<p>", "<br><br>")
		
        c = strpos(line,"<b>. ")
		line = subinstr(line, "<b>. ", "<span class=input>. ", 1)
	
		// catch continuation lines
		if (substr(line,1,7) == "<b>&gt;" & cprev == 1) { 
			line = subinstr(line, "<b>", "<span class=input>", 1)
            c = 1 
		} 	
		else { 
			line = subinstr(line, "<b>", "<span class=result>")
		}
		
		line = subinstr(line, "</b>", "</span>")

		fput(fh_clog, line)
		cprev = c 
    }
    
    fput(fh_clog, "</code> </div>")
    fput(fh_clog, `"<a href=""' + state.exname + `"" class = "w3-button w3-blue-gray w3-right">do-file</a>"')
    mb_fclose(fh_clog)
    mb_fclose(fh_rlog)
    copyfile(settings.templog)
}

void mkblog::opentxt(real scalar sourcerow)
{
    string scalar errmsg
    
    if (state.txtopen == 1){
        errmsg = "{p}{err}tried to open a text block, but one is already open{p_end}"
        printf(errmsg)
        where_err(sourcerow)
        exit(198)
    }
    if (state.exopen  == 1){
        errmsg = "{p}{err}tried to open a text block, but an example is already open{p_end}"
        printf(errmsg)
        where_err(sourcerow)
        exit(198)        
        
    }
    fput(fh_main, `"<div class="w3-container">"')
	state.txtopen = 1
}

void mkblog::closetxt(real scalar sourcerow)
{
    string scalar errmsg
    if (state.txtopen== 0) {
        errmsg = "{p}{err}Tried to close a text block, but none was open{p_end}"
        printf(errmsg)
        where_err(sourcerow)
        exit(198)
    }
    fput(fh_main, "</div>")
	state.txtopen = 0
}

end