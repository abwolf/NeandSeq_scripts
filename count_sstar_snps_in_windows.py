from __future__ import print_function
import sys
import gzip

infile = gzip.open(sys.argv[1], 'rb')

nonAFR_count = 0
AFR_count = 0
for line in infile:
	ls = line.strip().split('\t')
#	print(line_ls[0], line_ls[1], line_ls[2], file=sys.stdout)
	chrom=ls[0]
	start=ls[1]
	stop=ls[2]
	anc_allele=ls[3]
	der_allele=ls[4]
	anc_der_code=ls[5]
	Afr_Amer_de_allele_freq=float(ls[6])
	Afr_der_allele_freq=float(ls[7])
	Amer_der_allele_freq=float(ls[8])
	EAS_der_allele_freq=float(ls[9])
	EUR_der_allele_freq=float(ls[10])
	PNG_der_allele_freq=float(ls[11])
	SAS_der_allele_freq=float(ls[12])
	Neand_base=ls[13]
	Deni_base=ls[14]
	
	#if Afr_der_allele_freq>0.98:
	#	if EAS_der_allele_freq==0 and EUR_der_allele_freq==0 and SAS_der_allele_freq==0 and PNG_der_allele_freq==0:
	#		print(chrom+'\t'+start+'\t'+stop, file=sys.stdout)
	#		nonAFR_count+=1
		#elif EAS_der_allele_freq!=0 or EUR_der_allele_freq!=0 or SAS_der_allele_freq!=0 or PNG_der_allele_freq!=0:
		#	continue
	if Afr_der_allele_freq==0.0:
		#if EAS_der_allele_freq!=0 and EUR_der_allele_freq!=0 and SAS_der_allele_freq!=0 and PNG_der_allele_freq!=0:
		if EAS_der_allele_freq!=0 or EUR_der_allele_freq!=0 or SAS_der_allele_freq!=0 or PNG_der_allele_freq!=0:
			if Neand_base in ['A','C','T','G']:
				#print(chrom+'\t'+start+'\t'+stop, file=sys.stdout)
				print(line.strip(), file=sys.stdout)
				AFR_count+=1

print('nonAFR_count: ', nonAFR_count, 'AFR_count: ',AFR_count, file=sys.stderr)
print('END', file=sys.stderr)




infile.close()
