#!/usr/bin/env python3
# coding=utf-8
#-*- coding: utf-8 -*-

import logging
from os.path import exists, isdir, isfile
from os import walk
import re
import platform
import sys


reExtension= re.compile(r"\.(jar|class|java|war|jnlp)$", re.IGNORECASE)
reJavaFile = re.compile(r"(log4j|JndiLookup)", re.IGNORECASE)

def ValidatePath( path ):
	if exists(path):
		if isdir( path ):
			logging.info( "\tDir Exists: {}".format(path) )
			return True
		elif isfile( path ):
			logging.info( "\tFile Exists {}".format(path) )
			return True
		logging.error("\tError")
		return False


def SearchPath( path ):
	logging.info( "Searching {}".format(path) )
	for root, dirs, files in walk(path, topdown=False):
		for file in files:
			if reExtension.search( file ):
				tempFN = root + delimiter + file
				if reJavaFile.search( file ):
					logging.error( tempFN )

SearchPaths = []
delimiter  = "/"
tempDor     = "/tmp"


if __name__ == "__main__":
	if platform.system() == "Windows":
		delimiter = "\\"
		tempDir   = "C:\\Windows\\Temp"
		logging.basicConfig(filename="C:\\Windows\\Temp\\kcsirtLog4jPythonScanner.log", 
							level=logging.INFO,
							format='%(asctime)s:%(levelname)s:%(message)s',
                    		filemode='w')
	else:
		logging.basicConfig(filename="/tmp/kcsirtLog4jPythonScanner.log", 
							level=logging.INFO,
							format='%(asctime)s:%(levelname)s:%(message)s',
                    		filemode='w')
		
	if len(sys.argv) >= 2:
		for arg  in sys.argv[1:]:
			SearchPaths.append( arg )
	else:
		if platform.system() == "Windows":
			SearchPaths.append("C:\\")
		elif platform.system() == "Linux":
			SearchPaths.append("/")
		else:
			logging.error( "No params provided and unknown system" )
			sys.exit(1)
	
	
	for path in SearchPaths:
		logging.info( "Validating: {}".format(path) )
		if ValidatePath( path ):
			SearchPath( path )
		logging.info("------------------------------------")
		