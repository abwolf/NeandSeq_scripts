from __future__ import print_function
import sys


ancestral_allele_file=open(sys.argv[1], 'r')
genotype_file=open(sys.argv[2], 'r')

# Create a dictionary fom the ancestral allele data,
# key = position, 
# values = list of ref, alt, and Ancestral alleles
ancestral_allele_dict = {}
print('Loading ancestral alleles', file=sys.stderr)
for line in ancestral_allele_file:
	if "chr" in line:
		continue
	else:
		line_list = line.strip().split('\t')
		chrm=line_list[0]
		pos=line_list[1]
		ref=line_list[2]
		alt=line_list[3]
		anc=line_list[4]
		
		if ref in ['A','C','T','G'] and alt in ['A','C','T','G']:
			if anc in ['A|||','C|||','T|||','G|||','A','C','T','G']:
				anc = anc[0]
				#print(chrm, pos, ref, alt, anc)
				#NOTE: Could just keep sites where " ref!=anc " ?, wold be a smaller dictionary, may run faster...
				ancestral_allele_dict.update({pos : [ref, alt, anc]})
			
#print(ancestral_allele_dict.keys(), file=sys.stdout)

ancestral_allele_file.close()

# Run through genotype file by position, and see if it is present in the ancestral allele dictionary
# Rewrite a new line that converts Altai allele count based on ancestral allele
# ref = 0, alt = 1, 0|0=0, 0|1=1, 1|1=2
print('Reading genotype file', file=sys.stderr)
for i in genotype_file:
	i_list = i.strip().split('\t')
	chrm_i=i_list[0]
	pos_i=i_list[1]
	ref_i=i_list[2]
	alt_i=i_list[3]
	Altai_i=i_list[4]

	if pos_i in ancestral_allele_dict:
#	if pos_i in ancestral_allele_dict.keys():
		#print('pos: ',pos_i,
		#		'ref: ',ancestral_allele_dict[pos_i][0],
		#		'alt: ',ancestral_allele_dict[pos_i][1],
		#		'anc: ',ancestral_allele_dict[pos_i][2])
		ref_anc = ancestral_allele_dict[pos_i][0]
		alt_anc = ancestral_allele_dict[pos_i][1]
		anc_anc = ancestral_allele_dict[pos_i][2]
		
		if ref_i != ref_anc:
			print('ERROR: Refs dont match', file=sys.stderr)
			print(chrm_i, pos_i, 'ref_i: ', ref_i, 'ref_anc: ',ref_anc, 'alt_i: ',alt_i, 'alt_anc: ', alt_anc, file=sys.stderr)
			#sys.exit(1)
			continue
		elif alt_i != alt_anc:
			print('ERROR: Alts dont match', file=sys.stderr)
			print(chrm_i, pos_i, 'ref_i: ', ref_i, 'ref_anc: ',ref_anc, 'alt_i: ',alt_i, 'alt_anc: ', alt_anc, file=sys.stderr)
			#sys.exit(1)
			continue
		
		# If ref_i is the same as anc, then the count of alt alleles in Altai is the count of derived alleles
		#	genotype is set to ref, and ref is same as ancestral allele
		# If alt_i is the same as anc, then the count of alt alleles in Altai is the count of ancestral alleles
		#	if the genotype is 0, it means the Archaic carries 2 ref alleles, but these are actually 2 DERIVED alleles
		#	so we need to reverse the coding from 0 to 2. Hets can stay the same...
		if ref_i == anc_anc:
			#print(chrm_i, pos_i, ref_i, alt_i, anc_anc, Altai_i)
			Altai_i_mod = Altai_i
		elif alt_i == anc_anc:
			if Altai_i == '0':	# Altai carries 2 ref alleles, which in this case are the derived alleles
				Altai_i_mod = 2	# redefine as carrying 2 derived alleles
			elif Altai_i == '2':	# Altai carries 2 alt alleles, which in this case are the ancestral alleles
				Altai_i_mod = 0	# redfine as carrying 0 derived alleles
			elif Altai_i == '1':
				Altai_i_mod = 1
		#print(chrm_i, pos_i, ref_i, alt_i, anc_anc, Altai_i, Altai_i_mod, sep='\t', file=sys.stdout)
		print(chrm_i, pos_i, ref_i, alt_i, Altai_i_mod, sep='\t', file=sys.stdout)

genotype_file.close()

print('FIN', file=sys.stderr)
