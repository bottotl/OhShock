#coding=utf-8
import sys, os, argparse
filesList = []
parser = argparse.ArgumentParser()
parser.add_argument("project_path", help="path to folder")
parser.add_argument("-t", "--file_type", nargs='?', help="need statistics file type")
parser.add_argument("-p", "--line_prefix", nargs='?', help="list of lines prefix to ignore")
args = parser.parse_args()
filePath = args.project_path
fileTypes = args.file_type
exceptFlag = args.line_prefix
 
def listAllFiles(route):
    if os.path.isdir(route):
        for i in os.listdir(route):
            filename = os.path.join(route, i)
            if os.path.isdir(filename):
                listAllFiles(filename)
            else:
                addFile(filename)
    else:
        addFile(route)
 
def addFile(filename):
    if fileTypes is None:
        filesList.append(filename)
    elif os.path.splitext(filename)[1][1:] in fileTypes.split(','):
        filesList.append(filename)
 
numOfLines = 0
listAllFiles(filePath)
for subFilePath in filesList:
    for line in open(subFilePath):
        if exceptFlag is None:
            if len(line.strip()) is not 0:
                numOfLines = numOfLines + 1
        else:
            if not line.strip().startswith(tuple(exceptFlag.split(','))) and len(line.strip()) is not 0:
                numOfLines = numOfLines + 1
print '该项目共计 %s 行代码' % (str(numOfLines))
