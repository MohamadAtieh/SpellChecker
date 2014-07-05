#!/usr/bin/perl

open(MFILE, "dictionary.txt") || die "File Not Found\n";

@lines = <MFILE>; #store the file in an array
%hash = ();
@values = ();

for($i=0; $i < $#lines; $i++){
    chomp @lines[$i]; #remove \n
    $first_char = substr(@lines[$i],0,1); #first char
    if($i > 0){
	$step_back = substr(@lines[$i-1],0,1); #first char of previous element
       	if(!($step_back eq $first_char)){ #if not equal, add the values to hash
	    $hash{$step_back} = [ @values ];#and empty array;
	    @values = ();
	} 
    }
    	push @values, @lines[$i];  #if equal, keep on pushing to array
    
    if($i == ($#lines-1)){ #add z words
	$hash{$first_char} = [ @values ];
    } 
    
  }



print "Enter a sentence of your choice:\n";
$sentence = <STDIN>;
chomp $sentence;
@splited = split(/\s+/, $sentence); #split on 1 or more spaces



#-----Iterate through every input word and check with %hash if exist or not----

%hash2=();
@list=();

OUTERLOOP: foreach  $word (@splited){
    $word = lc $word; #convert to lower case
    $first_char = substr($word,0,1);  #first letter (key)
    
INNERLOOP: foreach $y (@{$hash{$first_char}}){
    $y =~ s/[^\w]//g;  #remove any non alphanumeric
    if($y eq $word){  #if equal:
        @list=(); #empty list
	next OUTERLOOP; #exit this iteration
    }else{
	$test = leven($y,$word); #short distance should return 1.
	if($test==1){
	  push @list, $y;  #add to list
	}
    }
}
   $hash2{$word} = [ @list ]; #add all words with differences to hash
   @list = (); #empty the list, and iterate
}




#when done, print results.

if(%hash2){

 print "The misspelled words are:\n\n";
 foreach (keys %hash2){
     print "$_: ";
     foreach $k (@{$hash2{$_}}){
	 print "*$k\n";
     }
     print "---------------------\n";
 }
}else{
    print "No misspelled words\n";
} 
close MFILE;


#----------------------------String Edit Distance----------------------------
#----------------returns, recursively, the # of different letters at -------
#----------------------each index between two given words-------------


use List::Util 'min';
 
my %cache;
 
sub leven {
        my ($s, $t) = @_;
        return length($t) if !$s;
        return length($s) if !$t;
 
	$cache{$s}{$t} //= # try commenting out this line to notice speed difference
        do {
                my ($s1, $t1) = (substr($s, 1), substr($t, 1));
 
                (substr($s, 0, 1) eq substr($t, 0, 1))
                        ? leven($s1, $t1)
                        : 1 + min(leven($s1, $t1),
                                  leven($s,  $t1),
                                  leven($s1, $t ));
        };
}
 
