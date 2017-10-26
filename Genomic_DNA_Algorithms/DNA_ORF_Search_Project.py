# PART 1 - INPUT DATA AND ORGANIZE ======================================================================

file = open('dna1.fasta') # file = open('dna1.fasta')
lines = file.readlines()

# remove newline character 
for x in range(0,len(lines)):
    lines[x] = lines[x].rstrip('\n')

# put data into dictionary key-value form 
data = {}
for line in lines:
    if line[0] == '>':
        #words = line.split(); name = words[0][1:]        
        name = line
        data[name] = ''
    else:
        data[name] = data[name] + line

# close file
file.close

# number of records
len(data)


# PART 2 - FIND SMALLEST AND LONGEST SEQUENCES IN DATA ===================================================

max_name = ''; max_seq = ''
for x in data:
    if len( data[x] ) >= len( max_seq ):
        max_name = x
        max_seq = data[x]
min_name = ''; min_seq = max_seq
for x in data:
    if len( data[x] ) < len( min_seq ):
        min_name = x
        min_seq = data[x]
        
len(max_seq)
len(min_seq)

for x in data:
    if len( data[x] ) == len(max_seq) :
        print x
for x in data:
    if len( data[x] ) == len(min_seq) :
        print x


# PART 3 - FIND ORFs =====================================================================================

# initialize max ORF sequence variables 
max_sequence_size = -1
max_sequence_name = ''
max_sequnce_id = ''
max_sequence_frame = -1
max_sequence_start = -1
max_sequence_stop = -1

# list of frame(s) to search
frames_selected = [1,2,3]

# loop for each record in dictionary 
for x in data:
    
    # get sequence from dictionary
    seq = data[x]
    
    # loop through reading frames
    for frame in frames_selected:
                
        print ("\nID: " + x)        
        print ("Reading Frame: " + str(frame))
        print ("Sequence: " + seq[frame-1:])
        frame_seq = seq[frame-1:]    
        
        # loop through sequences by 3 n-bases
        for i in range(0, len(frame_seq), 3):
            
            # find start codon            
            if frame_seq[i:i+3] == 'ATG':
                
                # loop through remaining bases                 
                for j in range(i, len(frame_seq), 3):

                    # find stop codon                    
                    if (frame_seq[j:j+3] == 'TAA') or (frame_seq[j:j+3] == 'TAG') or (frame_seq[j:j+3] == 'TGA'):
                        
                        # print out ORF information 
                        print("ORF of size: " + str(j+3-i) + " at position " + str(i) + " to " + str(j+3) )                        
                        
                        # log max ORF information
                        if (j+3-i) > max_sequence_size: 
                            max_sequence_size = (j-i+3)
                            max_sequence_name = frame_seq[i:j+3]
                            max_sequnce_id = x
                            max_sequence_frame = frame
                            max_sequence_start = i
                            max_sequence_stop = j+3
                        
                        # look for next ORF
                        break
          
# max sequence information       
print("\nThe longest OFT in the file is " + str(max_sequnce_id) + 
    " in reading frame " + str(max_sequence_frame) + " from position " + 
    str(max_sequence_start) + " to " + str(max_sequence_stop) + ", " + 
    str(max_sequence_size) + " bases long" )


# PART 4 - FIND REPEAT SUB-SEQUENCES ======================================================================

import collections
repeat_table = collections.Counter()

# define repeat size
n = 7

# list of frame(s) to search
frames_selected = [1]

# loop for each record in dictionary 
for x in data:
    
    # get sequence from dictionary
    seq = data[x]
    
    # loop through reading frames
    for frame in frames_selected:
        
        # sequence         
        frame_seq = seq[frame-1:]    
        # split sequence in n-size pieces        
        splits = [frame_seq[x:x+n] for x in range(0,len(frame_seq))]
        # count repeats 
        repeat_table = repeat_table + collections.Counter(splits)
        
print repeat_table 
        

