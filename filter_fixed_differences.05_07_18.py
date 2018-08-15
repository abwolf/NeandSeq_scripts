from __future__ import print_function
import sys
import gzip

# infile : altai_neand_filtered_vcfs.all.allele_info.gz --> allele info (1kG, Ancestral/Derived, and Altai) taken from altai_neand_vcf
with gzip.open(sys.argv[1], 'rb') as infile:
	for line in infile:
		if "CHROM" in line:
			#continue
			print(line.strip(),file=sys.stdout)
		else:
			line_list = line.strip().split('\t')
			#print(line_list,file=sys.stderr)
			CHROM=line_list[0]
			POS=line_list[1]
			REF=line_list[2]			# Reference allele
			ALT=line_list[3]			# Alternative allele
			ALT_1kG=line_list[4]			# Alternative allele in 1kG
			CAnc=line_list[5]			# Chimp Ancestral allele
			CAnc = 'NA' if CAnc=='?' else CAnc
			
			###############
			AF_1kG=line_list[6]		# Alternative allele freq in 1kG
			AF_1kG = 'NA' if AF_1kG=='?' else float(AF_1kG)
			
			AF_AMR=line_list[7]		# Alternative allele freq in American Indians 	(1kG)
			AF_AMR = 'NA' if AF_AMR=='?' else float(AF_AMR)
			
			AF_ASN=line_list[8]		# Alternative allele freq in Asians		(1kG)
			AF_ASN = 'NA' if AF_ASN=='?' else float(AF_ASN)
			
			AF_AFR=line_list[9]		# Alternative allele freq in Africans		(1kG)
			AF_AFR = 'NA' if AF_AFR=='?' else float(AF_AFR)
			
			AF_EUR=line_list[10]		# Alternative allele freq in Europeans		(1kG)
			AF_EUR = 'NA' if AF_EUR=='?' else float(AF_EUR)
			###############

			AC_Neand=line_list[11]			# Alt allele count in genotypes for Neand
					

			# Set 'print' FLAG to False, switch this later if you want to print the line
			FLAG=False

			# Check REF and ALT are SNVs and Neand is Homozygous
			if REF in ['A','C','T','G'] and ALT in ['A','C','T','G'] and ALT_1kG in ['A','C','T','G'] and AC_Neand in ['0','2']:
				# Check ALT_1kG matches either REF or ALT alleles
				if ALT_1kG in [REF, ALT]:
					# If ALT_1kG matches the noted ALT allele
					if ALT_1kG == ALT:
						# Keep sites where Neand is fixed for ALT and AFR is fixed for REF
						if AC_Neand == '2' :
							if AF_AFR <= 0.02 or AF_AFR == 'NA' :
								FLAG=True
						# Keep sites where Neand is fixed for REF and AFR is fixed for ALT
						if AC_Neand == '0' :
							if AF_AFR >= 0.98 :
								FLAG=True
					
					# If ALT_1kG matches the noted REF allele
					if ALT_1kG == REF:
						# Keep sites where Neand is fixed for ALT, and AFR is fixed for REF (high ALT_1kG freq)
						if AC_Neand == '2' :
							if AF_AFR >=0.98 :
								FLAG=True
						# Keep sites where Neand is fixed for REF, and AFR is fixed for ALT (low ALT_1kG freq)
						if AC_Neand == '0' :
							if AF_AFR <= 0.02 or AF_AFR == 'NA' :
								FLAG=True
			


			# If the line pass the criteria and FLAG has been set to TRUE, print the line
			if FLAG==True:
				line_str = '\t'.join(
						[CHROM, POS, REF, ALT, ALT_1kG, CAnc, 
						str(AF_1kG), str(AF_AMR), str(AF_ASN),
						str(AF_AFR), str(AF_EUR), AC_Neand]
						)
				print(line_str, file=sys.stdout)
			else:
				continue
