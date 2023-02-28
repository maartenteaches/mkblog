cd "c:\Mijn documenten\projecten\stata\mkblog\" 
clear all
version 17

mata 
mata clear
mata set matastrict on
end

do mkblog.mata

lmbuild lmkblog, replace dir(.)
