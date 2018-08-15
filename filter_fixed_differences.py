from __future__ import print_function
import sys
import gzip


# infile : 1KG_PNG_phase3_essentials.110515.chr**.bed.gz --> allele info (Anc/Der, 1kG derived frequencies, Altai genotype call)
with gzip.open(sys.argv[1], 'rb') as infile:
	for line in infile:
		if "CHROM" in line:
			#continue
			print(line.strip(),file=sys.stdout)
		else:
			line_list = line.strip().split('\t')
			#print(line_list,file=sys.stderr)
			CHROM=line_list[0]
			POS_start=line_list[1]
			POS_end=line_list[2]
			ANC=line_list[3]			# Ancestral allele
			DER=line_list[4]			# Derived allele
			CODE=line_list[5]			# Confidence code for ancestral/derived call --> 1 = hi-conf, 2 = low-conf, 3 = failure
			
			AF_AfAm=float(line_list[6])			# African American derived allele frequency
			AF_AFR=float(line_list[7])			# African derived allele frequency
			AF_AMR=float(line_list[8])			# American derived allele frequency
			AF_EAS=float(line_list[9])			# East Asian derived allele frequency
			AF_EUR=float(line_list[10])			# European derived allele frequency
			AF_PNG=float(line_list[11])			# Papuan derived allele frequency
			AF_SAS=float(line_list[12])			# South Asian derived allele frequency

			Neand=line_list[13]			# Neanderthal base, N for LowQual or missing
			Denis=line_list[14]			# Denisovan base, N for LowQual or missing
			
			
			# Set 'print' FLAG to False, switch this later if you want to print the line
			FLAG=False
			

			# Check Confidence code is hi-conf and Neand is homozygous
			if CODE == '1' and Neand in ['A','C','T','G']:
				if Neand==DER and AF_AFR<=0.02:
					FLAG=True
				elif Neand==ANC and AF_AFR>=0.98:
					FLAG=True
			
			if FLAG==True:
#				line_str = '\t'.join(
#						[CHROM, POS, REF, ALT, ALT_1kG, CAnc, 
#						str(AF_1kG), str(AF_AMR), str(AF_ASN),
#						str(AF_AFR), str(AF_EUR), AC_Neand]
#						)
				print(line.strip(), file=sys.stdout)
			else:
				continue



#			# Check REF and ALT are SNVs and Neand is Homozygous
#			if REF in ['A','C','T','G'] and ALT in ['A','C','T','G'] and ALT_1kG in ['A','C','T','G'] and AC_Neand in ['0','2']:
#				# Check ALT_1kG matches either REF or ALT alleles
#				if ALT_1kG in [REF, ALT]:
#					# If ALT_1kG matches the noted ALT allele
#					if ALT_1kG == ALT:
#						# Keep sites where Neand is fixed for ALT and AFR is fixed for REF
#						if AC_Neand == '2' :
#							if AF_AFR <= 0.02 or AF_AFR == 'NA' :
#								FLAG=True
#						# Keep sites where Neand is fixed for REF and AFR is fixed for ALT
#						if AC_Neand == '0' :
#							if AF_AFR >= 0.98 :
#								FLAG=True
#					
#					# If ALT_1kG matches the noted REF allele
#					if ALT_1kG == REF:
#						# Keep sites where Neand is fixed for ALT, and AFR is fixed for REF (high ALT_1kG freq)
#						if AC_Neand == '2' :
#							if AF_AFR >=0.98 :
#								FLAG=True
#						# Keep sites where Neand is fixed for REF, and AFR is fixed for ALT (low ALT_1kG freq)
#						if AC_Neand == '0' :
#							if AF_AFR <= 0.02 or AF_AFR == 'NA' :
#								FLAG=True
#			
#
#
#			# If the line pass the criteria and FLAG has been set to TRUE, print the line
#			if FLAG==True:
#				line_str = '\t'.join(
#						[CHROM, POS, REF, ALT, ALT_1kG, CAnc, 
#						str(AF_1kG), str(AF_AMR), str(AF_ASN),
#						str(AF_AFR), str(AF_EUR), AC_Neand]
#						)
#				print(line_str, file=sys.stdout)
#			else:
#				continue
