mata:

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
	fput(fh_main, `"   "')     
	fput(fh_main, `"</style>"')
	fput(fh_main, `"</head>"')
	fput(fh_main, `"<body>"')
}

void mkblog::write_pagetitle(string scalar title)
{

	fput(fh_main, `"<div class="w3-row">"')
	fput(fh_main, `"	<div class="w3-col m1 w3-container"></div>"')
	fput(fh_main, `"	<div class="w3-col m10 w3-container w3-blue-gray" >"')
	fput(fh_main, `"		<h2>"' + title + `"</h2>"')
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
	
	state.art = state.art + 1
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
                       real scalar lb, real scalar ub, | real scalar sourcerow)
{
    string scalar EOF, line
    real scalar fh_in, fh_out, i
    
    EOF = J(0,0,"")
    if (args() == 4) {
        fh_in = mb_fopen(orig, "r")
        fh_out = mb_fopen(dest, "w")    
    }
    else {
        fh_in = mb_fopen(orig, "r", sourcerow)
        fh_out = mb_fopen(orig, "w", sourcerow)
    }
    i = 0
    while ((line=fget(fh_in)) != EOF) {
        i = i + 1
        if (i >= lb & i <= ub) {
            fput(fh_out, line)
        }
    }
}
end