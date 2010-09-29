#! /usr/bin/python

# generate-jobs-rmapbs.py
# Song Qiang <qiang.song@usc.edu> 2010
# generate rmapbs jobs

import os, sys

from optparse import OptionParser

opt_parser = OptionParser("usage: %prog [options] reads_file")
opt_parser.add_option("-j", "--JobDir", dest = "jobs_dir", default = ".", \
					  help="Jobs directory ")
opt_parser.add_option("-r", "--rmap", help="Full path to the rmap program", dest = "rmap", \
					  default="/home/cmbpanfs-01/andrewds/sge_bin/rmap")
opt_parser.add_option("-m", "--mismatch", help="Number of mismatches allowed", dest = "mismatches", \
					  type="int",  default=2)
opt_parser.add_option("-A", "--AG_wildcard", dest = "ag_wildcard", default = False, \
					  action = "store_true", help="Using A/G wildcard when mapping negative strand" )

(options, args) = opt_parser.parse_args()

template = """
#PBS -S /bin/sh
#PBS -q cmb
#PBS -e %(ERROR_DIR)s 
#PBS -o %(OUTPUT_DIR)s
#PBS -l mem=1500M
#PBS -l nodes=1:ppn=1
#PBS -l walltime=72:00:00

# global environment
export Human_Genome_Dir=/home/cmbpanfs-01/qiangson/DataCenter/human/genome
export Chimp_Genome_Dir=/home/cmbpanfs-01/qiangson/DataCenter/genome/chimp

export rmap=%(RMAP)s
export MergeLanes=/home/cmb-01/qiangson/Documents/bsutils/code/bsutils/mergelanes
export MethCounts=/home/cmb-01/qiangson/Documents/bsutils/code/bsutils/methcounts
export Allelic=/home/cmb-01/qiangson/Documents/bsutils/code/bsutils/allelic
export MethSeg=/home/cmb-01/qiangson/Documents/bsutils/code/methseg/methseg
export MethDiff=/home/cmb-01/qiangson/Documents/bsutils/code/bsutils/methdiff
export DMR_Finder=/home/cmb-01/qiangson/Documents/bsutils/code/bsutils/dmr-h/dmr-andrew
export Sortbed=/home/cmbpanfs-01/andrewds/sge_bin/sortbed
export JackpotDel=/home/cmb-01/qiangson/Documents/bsutils/code/bsutils/tools/jackpot-del2.py
export Sortreads=/home/cmb-01/qiangson/Documents/bsutils/code/bsutils/sortreads

${rmap} -f  %(AG_WILDCARD)s  -m %(MISMATCH)s -s fa -c ${Human_Genome_Dir} -o %(BED_FILE)s %(READS_FILE)s -v

"""

p = os.path.abspath(sys.argv[1])

dirname = os.path.dirname(p)
basename = os.path.basename(p)

reads_file = p
bed_file = os.path.splitext(reads_file.replace("/reads/", "/mapped/"))[0] + ".bed"
error_dir = os.path.join(dirname.replace("/reads", "/work"), "error")
output_dir = os.path.join(dirname.replace("/reads", "/work"), "output")
	
jobs_dir = options.jobs_dir

job_file_name_templ = "rmap-%s.qsub" 

job_file_name = os.path.join(jobs_dir, job_file_name_templ  % (os.path.splitext(basename)[0]) )

job_file = open(job_file_name, "w")
if options.ag_wildcard:
	ag_wildcard = " -A "
else:
	ag_wildcard = " "
job_file.write(template % {"ERROR_DIR":error_dir, "OUTPUT_DIR":output_dir,\
						   "BED_FILE":bed_file, "READS_FILE":reads_file,\
						   "RMAP":options.rmap, "MISMATCH":options.mismatches,\
						   "AG_WILDCARD":ag_wildcard})
job_file.close()
