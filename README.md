# Structural Variation caused by mPing
---------------------------------------

## Goals of this Project

  1. Create code that will determine mPings that are within a certain proximal 
  range from one another. The location of these proximal mPings will be used as
  a filter so that specific areas within the genome can be looked at for structural
  variation (SV). The output data from RelocaTE2 will be used to to first determine
  where mPings are, and separate code will be used to determine which mPings are 
  proximal to one another.

  2. Run different tools that will use short and long read sequencing data
  to determine where SVs occur and what specific type of SV was the result.

  3. The output from the differe SV calling tools will be compared to one another.
  To do this, a figure will be made to see how SVs correlate with proximal mPings.
