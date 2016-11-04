#!/bin/bash
# Created by Patrick Nuckolls '20
#    patrick(dot)nuckolls(at)gmail(dot)com

# This tool requires git, make, and racket along with 
# gimp (> 2.0) and should be run upon every update of racket or gimp
#
# All libraries are built and placed in the directory this script is run from,
# so run it in an EMPTY DIRECTORY unless you know what you're doing
#
# (shameless plug) If you plan or running racket from the command line, I would also 
# recommend that you add (require rackunit) to your ~/.racketrc file,
# it makes command line racket much more managable (/shameless plug)
#
# I bulit this tool on Arch linux, and while it should work on your distro/computer,
# I can make no guarantees. 

# Install directory, currently set to install in the directory it is placed in
INSTALLPATH=`pwd`
GIMPPLUGINSPATH='~/.gimp-2.8/plug-ins'

#remove old installation and clone new copies of repositories
initialpath=`pwd`
cd $INSTALLPATH
rm -rfv $INSTALLPATH/gigls $INSTALLPATH/gimp-dbus $INSTALLPATH/louDBus/
rm -fv $GIMPPLUGINSPATH/ggimp-irgb-new $GIMPPLUGINSPATH/ggimp-rgb-list $GIMPPLUGINSPATH/ggimp-irgb-component $GIMPPLUGINSPATH/gimp-dbus
git clone https://github.com/GlimmerLabs/gimp-dbus.git 
git clone https://github.com/GlimmerLabs/louDBus.git 
git clone https://github.com/GlimmerLabs/gigls.git 
rm -rf */.git*


#unlink old libraries
giglsPath="$(raco link -l | grep gigls | grep -o 'path: ".*"' | sed 's/path: //g' | sed 's/"//g')" 
louDBusPath="$(raco link -l | grep louDBus | grep -o 'path: ".*"' | sed 's/path: //g' | sed 's/"//g')" 
if [ -n "$giglsPath" ]; then raco link -r $giglsPath; fi
if [ -n "$louDBusPath" ]; then raco link -r $louDBusPath; fi

#make
cd $INSTALLPATH/louDBus
make
cd $INSTALLPATH/gigls
make
cd $INSTALLPATH/gimp-dbus
make

#link newly compiled libraries
raco link $INSTALLPATH/louDBus
raco link $INSTALLPATH/gigls
cd $initialpath
