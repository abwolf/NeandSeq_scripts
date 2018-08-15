from __future__ import print_function
import sys


infile=open(sys.argv[1], 'r')

# Create a large list of lists for the annotated sites,
# each sublist contains information about the variant position, ref and alt alleles, and the genotype of the Altai
ls = []
print('Load genotype file', file=sys.stderr)
for line in infile:
	if "chr" in line:
		continue
	else:
		line_list=line.strip().split('\t')
		chr=line_list[0]
		pos=line_list[1]
		ref=line_list[2]
		alt=line_list[3]
		ARCH=line_list[4]
		ls.append([chr,pos,ref,alt,ARCH])

# What is the total number of sites contained in this list
print('Length list: ', len(ls), file=sys.stderr)


# Starting at the first variant in the list,
# take this start position in bp, and then continue through the sequential sites,
# so long as the legnth of the window we are looking at is less than 50kb
# and count how many times the Altai carries a derived allele
# Print the initial variant, the starting bp position, the number of bps covered in the window, and the count of derived alleles
i=0
while i in range(0,len(ls)):
	strt_bp=int(ls[i][1])
	bp=0
	z=i
	site_count=1
	der_count=int(ls[i][4])
	while int(ls[z][1])-strt_bp<=50000:
		bp=int(ls[z][1])-strt_bp
		## NOTE: Only count IF(ARCH > 0)
		if int(ls[z][4]) > 0:
			der_count+=1
			#der_count+=int(ls[z][4])
		if z+1 < len(ls):
			z+=1
			site_count+=1
		else:
			break
			

	print(i, strt_bp, bp, site_count, der_count, file=sys.stdout)

# Now redefine the starting position,
# by finding a new_i in the list of sites whose start bp is <=10kb away from the previous start site
# without exceeding the length of the list of possible sites.
	new_i=i
	while int(ls[new_i][1])-strt_bp<=10000:
		if new_i + 1 < len(ls):
			new_i+=1
		else:
			print('END', file=sys.stderr)
			break
	i = new_i + 1
	

infile.close()
